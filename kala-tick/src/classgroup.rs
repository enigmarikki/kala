use crate::discriminant::Discriminant;
use crate::form::QuadraticForm;
use crate::types::CVDFError;
use rug::ops::DivRounding;
use rug::rand::RandState;
use rug::Integer;
use std::cmp::min;
use std::ops::Neg;
use tracing::debug;

/// Class group operations
pub struct ClassGroup {
    discriminant: Discriminant,
}

impl ClassGroup {
    pub fn new(discriminant: Discriminant) -> Self {
        ClassGroup { discriminant }
    }

    /// Extended GCD: returns (g, u, v) where g = gcd(a,b) = a*u + b*v
    fn extended_gcd(a: &Integer, b: &Integer) -> (Integer, Integer, Integer) {
        let mut old_r = a.clone();
        let mut r = b.clone();
        let mut old_s = Integer::from(1);
        let mut s = Integer::from(0);
        let mut old_t = Integer::from(0);
        let mut t = Integer::from(1);
        while r != 0 {
            let quotient = Integer::from(&old_r / &r);
            let temp_r = Integer::from(&old_r - &quotient * &r);
            let temp_s = Integer::from(&old_s - &quotient * &s);
            let temp_t = Integer::from(&old_t - &quotient * &t);
            old_r = r;
            r = temp_r;
            old_s = s;
            s = temp_s;
            old_t = t;
            t = temp_t;
        }
        if old_r < 0 {
            (old_r.neg(), old_s.neg(), old_t.neg())
        } else {
            (old_r, old_s, old_t)
        }
    }

    /// Partial XGCD - computes partial extended GCD
    fn xgcd_partial(
        r2: &Integer,
        r1: &Integer,
        L: &Integer,
    ) -> (Integer, Integer, Integer, Integer) {
        let mut r2 = r2.clone();
        let mut r1 = r1.clone();
        let mut co2 = Integer::from(0);
        let mut co1 = Integer::from(-1);

        while r1 != 0 && &r1 > L {
            let bits2 = r2.significant_bits() as i64;
            let bits1 = r1.significant_bits() as i64;
            let bits = std::cmp::max(bits2, bits1) - 64 + 1;
            let bits = if bits < 0 { 0 } else { bits as u32 };

            let rr2 = Integer::from(&r2 >> bits).to_i64().unwrap_or(0);
            let rr1 = Integer::from(&r1 >> bits).to_i64().unwrap_or(0);
            let bb = Integer::from(L >> bits).to_i64().unwrap_or(0);

            let mut aa2: i64 = 0;
            let mut aa1: i64 = 1;
            let mut bb2: i64 = 1;
            let mut bb1: i64 = 0;
            let mut rr2_mut = rr2;
            let mut rr1_mut = rr1;

            let mut i = 0;
            while rr1_mut != 0 && rr1_mut > bb {
                let qq = rr2_mut / rr1_mut;
                let t1 = rr2_mut - qq * rr1_mut;
                let t2 = aa2 - qq * aa1;
                let t3 = bb2 - qq * bb1;

                if i & 1 != 0 {
                    if t1 < -t3 || rr1_mut - t1 < t2 - aa1 {
                        break;
                    }
                } else {
                    if t1 < -t2 || rr1_mut - t1 < t3 - bb1 {
                        break;
                    }
                }

                rr2_mut = rr1_mut;
                rr1_mut = t1;
                aa2 = aa1;
                aa1 = t2;
                bb2 = bb1;
                bb1 = t3;
                i += 1;
            }

            if i == 0 {
                let q = Integer::from(&r2 / &r1);
                let temp_r1 = r1; // Move r1
                r1 = Integer::from(&r2 % &temp_r1);
                r2 = temp_r1; // Move instead of clone
                let temp_co2 = co2; // Move co2
                co2 = Integer::from(&temp_co2 - &q * &co1);
                co1 = temp_co2; // Move instead of clone
            } else {
                let new_r2 = if aa2 >= 0 {
                    Integer::from(&r2 * bb2) + Integer::from(&r1 * aa2)
                } else {
                    Integer::from(&r2 * bb2) - Integer::from(&r1 * (-aa2))
                };

                let new_r1 = if bb1 >= 0 {
                    Integer::from(&r1 * aa1) + Integer::from(&r2 * bb1)
                } else {
                    Integer::from(&r1 * aa1) - Integer::from(&r2 * (-bb1))
                };

                let new_co2 = if aa2 >= 0 {
                    Integer::from(&co2 * bb2) + Integer::from(&co1 * aa2)
                } else {
                    Integer::from(&co2 * bb2) - Integer::from(&co1 * (-aa2))
                };

                let new_co1 = if bb1 >= 0 {
                    Integer::from(&co1 * aa1) + Integer::from(&co2 * bb1)
                } else {
                    Integer::from(&co1 * aa1) - Integer::from(&co2 * (-bb1))
                };

                r2 = new_r2;
                r1 = new_r1;
                co2 = new_co2;
                co1 = new_co1;

                if r1 < 0 {
                    co1 = -co1;
                    r1 = -r1;
                }
                if r2 < 0 {
                    co2 = -co2;
                    r2 = -r2;
                }
            }
        }

        if r2 < 0 {
            co2 = -co2;
            co1 = -co1;
            r2 = -r2;
        }

        (co2, co1, r2, r1)
    }

    /// Compose two quadratic forms using NUCOMP algorithm
    pub fn compose(
        &self,
        f1: &QuadraticForm,
        f2: &QuadraticForm,
    ) -> Result<QuadraticForm, CVDFError> {
        if !f1.is_valid(&self.discriminant) || !f2.is_valid(&self.discriminant) {
            return Err(CVDFError::InvalidForm);
        }

        let identity = QuadraticForm::identity(&self.discriminant);
        if *f1 == identity {
            return Ok(f2.clone());
        }
        if *f2 == identity {
            return Ok(f1.clone());
        }

        let (f, g) = if f1.a > f2.a { (f2, f1) } else { (f1, f2) };

        let a1 = &f.a;
        let a2 = &g.a;
        let b1 = &f.b;
        let b2 = &g.b;
        let c1 = &f.c;
        let c2 = &g.c;

        let ss = Integer::from(b1 + b2) / 2;
        let m = Integer::from(b1 - b2) / 2;

        let t = Integer::from(a2 % a1);
        let (sp, v1) = if t == 0 {
            (a1.clone(), Integer::from(0))
        } else {
            let (g, v, _) = Self::extended_gcd(&t, a1);
            (g, v)
        };

        let mut k = Integer::from(&m * &v1) % a1;

        if sp != 1 {
            let (s, v2, u2) = Self::extended_gcd(&ss, &sp);
            k = Integer::from(Integer::from(&k * &u2) - Integer::from(&v2 * c2));
            if s != 1 {
                let a1_new = Integer::from(a1 / &s);
                let a2_new = Integer::from(a2 / &s);
                let c2_new = Integer::from(c2 * &s);
                k = k % &a1_new;
                // Update for use in computation
                let a1 = a1_new;
                let a2 = a2_new;
                let c2 = c2_new;
            } else {
                k = k % a1;
            }
        }

        let disc_abs = Integer::from(self.discriminant.value.abs_ref());
        let L = Integer::from(disc_abs.sqrt_ref()) / 2;

        let (ca, cb, cc) = if a1 < &L {
            let t = Integer::from(a2 * &k);
            let ca = Integer::from(a2 * a1);
            let cb = Integer::from(&t * 2) + b2;
            let cc: Integer = Integer::from(Integer::from(b2 + &t) * &k + c2) / a1;
            (ca, cb, cc)
        } else {
            let (co2, co1, r2, r1) = Self::xgcd_partial(a1, &k, &L);
            let m1 = Integer::from(Integer::from(&m * &co1) + Integer::from(a2 * &r1)) / a1;
            let m2 = Integer::from(&ss * &r1 - Integer::from(c2 * &co1)) / a1;
            let ca = if co1 < 0 {
                Integer::from(&r1 * &m1 - Integer::from(&co1 * &m2))
            } else {
                Integer::from(&co1 * &m2 - Integer::from(&r1 * &m1))
            };
            let t = Integer::from(a2 * &k);
            let cb_temp =
                Integer::from(Integer::from(&t - Integer::from(&ca * &co2)) * 2 / &co1 - b2);
            let two_ca = Integer::from(&ca * 2);
            let cb = cb_temp % &two_ca;
            let cc: Integer = Integer::from(&cb * &cb - &self.discriminant.value) / &ca / 4;
            if ca < 0 {
                (-ca, cb, -cc)
            } else {
                (ca, cb, cc)
            }
        };

        let mut b3 = cb;
        let two_ca = Integer::from(&ca * 2);
        b3 = b3 % &two_ca;
        if &b3 > &ca {
            b3 -= &two_ca;
        }

        let c3 = Integer::from(&b3 * &b3 - &self.discriminant.value) / &ca / 4;

        let mut form = QuadraticForm::new(ca, b3, c3);

        let a_abs_squared = Integer::from(form.a.abs_ref()) * Integer::from(form.a.abs_ref());
        if a_abs_squared > disc_abs / 9 {
            form = form.reduce();
        }

        Ok(form)
    }

    /// Square a quadratic form using NUDUPL algorithm
    pub fn square(&self, form: &QuadraticForm) -> Result<QuadraticForm, CVDFError> {
        if !form.is_valid(&self.discriminant) {
            return Err(CVDFError::InvalidForm);
        }

        let identity = QuadraticForm::identity(&self.discriminant);
        if *form == identity {
            return Ok(identity);
        }

        let a1 = &form.a;
        let b = &form.b;
        let c1 = &form.c;

        let (s, v2) = if *b < 0 {
            let (s, v, _) = Self::extended_gcd(&(-b.clone()), a1);
            (s, -v)
        } else {
            let (s, v, _) = Self::extended_gcd(b, a1);
            (s, v)
        };

        let mut k = Integer::from(Integer::from(&v2 * c1).neg());
        let mut a1_new = a1.clone();
        let mut c1_new = c1.clone();

        if s != 1 {
            a1_new = Integer::from(a1 / &s);
            c1_new = Integer::from(c1 * &s);
            k = k % &a1_new;
        } else {
            k = k % a1;
        }
        if k < 0 {
            k += &a1_new;
        }

        let disc_abs = Integer::from(self.discriminant.value.abs_ref());
        let L = Integer::from(disc_abs.sqrt_ref()) / 2;

        let (ca, cb, cc) = if a1_new < L {
            let t = Integer::from(&a1_new * &k);
            let ca = Integer::from(&a1_new * &a1_new);
            let cb = Integer::from(&t * 2) + b;
            let cc: Integer = Integer::from(Integer::from(b + &t) * &k + &c1_new) / &a1_new;
            (ca, cb, cc)
        } else {
            let (co2, co1, r2, r1) = Self::xgcd_partial(&a1_new, &k, &L);
            let m2 = Integer::from(b * &r1 - Integer::from(&c1_new * &co1)) / &a1_new;
            let mut ca = Integer::from(&r1 * &r1 - Integer::from(&co1 * &m2));
            if co1 >= 0 {
                ca = -ca;
            }
            let cb_temp = Integer::from(
                Integer::from(&a1_new * &r1 - Integer::from(&ca * &co2)) * 2 / &co1 - b,
            );
            let two_ca = Integer::from(ca.abs_ref()) * 2;
            let cb = cb_temp % &two_ca;
            let cc: Integer = Integer::from(&cb * &cb - &self.discriminant.value) / &ca / 4;
            if ca < 0 {
                (-ca, cb, -cc)
            } else {
                (ca, cb, cc)
            }
        };

        let mut b_new = cb;
        let two_ca = Integer::from(&ca * 2);
        b_new = b_new % &two_ca;
        if &b_new > &ca {
            b_new -= &two_ca;
        }

        let c_new = Integer::from(&b_new * &b_new - &self.discriminant.value) / &ca / 4;

        let mut form = QuadraticForm::new(ca, b_new, c_new);

        let a_abs_squared = Integer::from(form.a.abs_ref()) * Integer::from(form.a.abs_ref());
        if a_abs_squared > disc_abs / 9 {
            form = form.reduce();
        }

        Ok(form)
    }

    /// Compute form^(2^t) through repeated squaring
    pub fn repeated_squaring(
        &self,
        form: &QuadraticForm,
        t: usize,
    ) -> Result<QuadraticForm, CVDFError> {
        // Add bounds checking to prevent hanging on large values
        if t > 100_000 {
            return Err(CVDFError::ComputationError(
                "Exponent too large for repeated squaring".to_string(),
            ));
        }

        let mut result = form.clone();
        for i in 0..t {
            // Add periodic validation to prevent infinite loops on invalid forms
            if i % 1000 == 0 && !result.is_valid(&self.discriminant) {
                return Err(CVDFError::InvalidForm);
            }
            result = self.square(&result)?;
        }
        Ok(result)
    }

    /// Compute form^n using binary exponentiation
    pub fn pow(&self, form: &QuadraticForm, n: &Integer) -> Result<QuadraticForm, CVDFError> {
        if n == &0 {
            return Ok(QuadraticForm::identity(&self.discriminant));
        }
        let mut result = QuadraticForm::identity(&self.discriminant);
        let mut base = form.clone();
        let mut exp = n.clone();
        while exp > 0 {
            if exp.is_odd() {
                result = self.compose(&result, &base)?;
            }
            base = self.square(&base)?;
            exp >>= 1;
        }
        Ok(result)
    }

    /// Generate a random class group element
    pub fn random_element(&self) -> Result<QuadraticForm, CVDFError> {
        let mut rand_state = RandState::new();
        let bits = min(self.discriminant.bit_length / 4, 256);
        let max_attempts = 100;

        for _ in 0..max_attempts {
            let a = Integer::from(Integer::random_bits(bits, &mut rand_state)).abs();
            if a == 0 {
                continue;
            }
            let four_a = Integer::from(&a * 4);
            let d_mod = self.discriminant.value.clone().modulo(&four_a);
            let two_a = Integer::from(&a * 2);
            for _ in 0..100 {
                let b = Integer::from(Integer::random_bits(bits, &mut rand_state)).modulo(&two_a);
                if Integer::from(&b * &b).modulo(&four_a) == d_mod {
                    let c = Integer::from(&b * &b - &self.discriminant.value) / &four_a;
                    let temp_form = QuadraticForm::new(a.clone(), b, c);
                    if temp_form.is_valid(&self.discriminant) {
                        return Ok(temp_form.reduce());
                    }
                }
            }
        }
        Err(CVDFError::InvalidForm)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rug::Integer;

    #[test]
    fn test_compose_identity() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc.clone());
        let identity = QuadraticForm::identity(&disc);
        let form = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let result = cg.compose(&identity, &form).unwrap();
        assert_eq!(result, form.reduce());
        let result2 = cg.compose(&form, &identity).unwrap();
        assert_eq!(result2, form.reduce());
    }

    #[test]
    fn test_square() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc.clone());
        let form = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let form = form.reduce();
        let squared = cg.square(&form).expect("Square should succeed");
        let composed = cg.compose(&form, &form).expect("Compose should succeed");
        assert_eq!(
            squared.reduce(),
            composed.reduce(),
            "Reduced forms should match"
        );
        assert_eq!(squared.discriminant(), disc.value);
    }

    #[test]
    fn test_repeated_squaring() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc.clone());
        let form = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let form_4_method1 = cg
            .repeated_squaring(&form, 2)
            .expect("Repeated squaring should succeed");
        let form_2 = cg.square(&form).expect("Square should succeed");
        let form_4_method2 = cg.square(&form_2).expect("Square should succeed");
        assert_eq!(form_4_method1.discriminant(), form_4_method2.discriminant());
        assert_eq!(form_4_method1.discriminant(), disc.value);
    }

    #[test]
    fn test_pow() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc.clone());
        let form = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let result = cg
            .pow(&form, &Integer::from(0))
            .expect("Power should succeed");
        assert_eq!(result, QuadraticForm::identity(&disc));
        let result = cg
            .pow(&form, &Integer::from(1))
            .expect("Power should succeed");
        assert_eq!(result, form.reduce());
        let result = cg
            .pow(&form, &Integer::from(4))
            .expect("Power should succeed");
        assert_eq!(result.discriminant(), disc.value);
    }

    #[test]
    fn test_random_element() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc.clone());
        let form = cg.random_element().expect("Random element should succeed");
        assert_eq!(form.discriminant(), disc.value);
        assert!(form.is_reduced());
    }

    #[test]
    fn test_associativity() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let cg = ClassGroup::new(disc);
        let f1 = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let f2 = QuadraticForm::new(Integer::from(3), Integer::from(1), Integer::from(2));
        let f3 = QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        let left = cg
            .compose(&cg.compose(&f1, &f2).expect("Compose should succeed"), &f3)
            .expect("Compose should succeed");
        let right = cg
            .compose(&f1, &cg.compose(&f2, &f3).expect("Compose should succeed"))
            .expect("Compose should succeed");
        assert_eq!(left.reduce(), right.reduce(), "Reduced forms should match");
    }

    #[test]
    fn test_compose_chia_prod_discriminant() {
        let disc_value = Integer::from_str_radix("-3fe0000000000000000f", 16).unwrap();
        let disc = Discriminant {
            value: disc_value.clone(),
            bit_length: 67,
        };
        let cg = ClassGroup::new(disc.clone());
        let f1 = QuadraticForm::identity(&disc);
        let f2 = cg.random_element().expect("Random element should succeed");
        let result = cg.compose(&f1, &f2).expect("Compose should succeed");
        assert!(
            result.is_reduced(),
            "Composed form ({}, {}, {}) is not reduced",
            result.a,
            result.b,
            result.c
        );
        assert_eq!(result.discriminant(), disc_value);
    }
}
