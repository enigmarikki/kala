use crate::discriminant::Discriminant;
use crate::form::QuadraticForm;
use crate::types::CVDFError;
use rug::Integer;
use rug::rand::RandState;
use std::cmp::min;
use std::ops::Neg;
use rug::ops::DivRounding;
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

    /// Compose two quadratic forms using NUCOMP algorithm
    pub fn compose(&self, f1: &QuadraticForm, f2: &QuadraticForm) -> Result<QuadraticForm, CVDFError> {
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
        let a1 = &f1.a;
        let b1 = &f1.b;
        let c1 = &f1.c;
        let a2 = &f2.a;
        let b2 = &f2.b;
        let c2 = &f2.c;

        // Compute GCDs
        let (g1, u, v) = Self::extended_gcd(a1, a2);
        let s = Integer::from(b1 + b2).div_floor(Integer::from(2));
        let d = Integer::from(b1 - b2).div_floor(Integer::from(2));
        let (g, s_coeff, t) = Self::extended_gcd(&g1, &s);

        // Compute a3
        let a1_g = Integer::from(a1 / &g);
        let a2_g = Integer::from(a2 / &g);
        let a3 = Integer::from(&a1_g * &a2_g) * &g;

        // Compute b3
        let k = Integer::from(&d * &v) - Integer::from(c2 * &u);
        let l = Integer::from(&s * &t) - Integer::from(c1 * &u);
        let mut b3 = Integer::from(b2 + Integer::from(&a2_g * 2) * &k);
        let two_a3 = Integer::from(&a3 * 2);
        b3 = b3.modulo(&two_a3);
        if b3 > a3 {
            b3 -= &two_a3;
        }

        // Compute c3
        let b3_squared = Integer::from(&b3 * &b3);
        let four_a3 = Integer::from(&a3 * 4);
        let discriminant_diff = Integer::from(&b3_squared - &self.discriminant.value);
        if !discriminant_diff.is_divisible(&four_a3) {
            return Err(CVDFError::InvalidForm);
        }
        let c3 = discriminant_diff / &four_a3;

        let mut form = QuadraticForm::new(a3, b3, c3);
        // Allow reduce to fix the form
        form = form.reduce();
        if !form.is_valid(&self.discriminant) {
            return Err(CVDFError::InvalidForm);
        }

        // Partial reduction
        let disc_abs = Integer::from(self.discriminant.value.abs_ref());
        let a_abs_squared = Integer::from(form.a.abs_ref()) * Integer::from(form.a.abs_ref());
        if a_abs_squared > disc_abs / 9 {
            form = form.reduce();
        }
        Ok(form.reduce())
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
        let a = &form.a;
        let b = &form.b;
        let c = &form.c;
        let g = a.clone().gcd(b);
        if g == 0 {
            return Err(CVDFError::DivisionError);
        }
        let a_g = Integer::from(a / &g);
        let a_new = Integer::from(&a_g * &a_g) * &g;
        let (_, u, v) = Self::extended_gcd(a, &Integer::from(b / &g));
        let k = Integer::from(c * &v);
        let two_k = Integer::from(&k * 2);
        let mut b_new = Integer::from(&two_k - b);
        let two_a_new = Integer::from(&a_new * 2);
        b_new = b_new.modulo(&two_a_new);
        if b_new > a_new {
            b_new -= &two_a_new;
        }
        let b_new_squared = Integer::from(&b_new * &b_new);
        let four_a_new = Integer::from(&a_new * 4);
        if !Integer::from(&b_new_squared - &self.discriminant.value).is_divisible(&four_a_new) {
            return Err(CVDFError::InvalidForm);
        }
        let c_new = Integer::from(&b_new_squared - &self.discriminant.value) / &four_a_new;
        let mut form = QuadraticForm::new(a_new, b_new, c_new);
        if !form.is_valid(&self.discriminant) {
            return Err(CVDFError::InvalidForm);
        }
        let disc_abs = Integer::from(self.discriminant.value.abs_ref());
        let a_abs_squared = Integer::from(form.a.abs_ref()) * Integer::from(form.a.abs_ref());
        if a_abs_squared > disc_abs / 9 {
            form = form.reduce();
        }
        Ok(form.reduce())
    }

    /// Compute form^(2^t) through repeated squaring
    pub fn repeated_squaring(&self, form: &QuadraticForm, t: usize) -> Result<QuadraticForm, CVDFError> {
        let mut result = form.clone();
        for _ in 0..t {
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
        let squared = cg.square(&form).expect("Square should succeed");
        let composed = cg.compose(&form, &form).expect("Compose should succeed");
        assert_eq!(squared.reduce(), composed.reduce(), "Reduced forms should match");
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
        let form_4_method1 = cg.repeated_squaring(&form, 2).expect("Repeated squaring should succeed");
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
        let result = cg.pow(&form, &Integer::from(0)).expect("Power should succeed");
        assert_eq!(result, QuadraticForm::identity(&disc));
        let result = cg.pow(&form, &Integer::from(1)).expect("Power should succeed");
        assert_eq!(result, form.reduce());
        let result = cg.pow(&form, &Integer::from(4)).expect("Power should succeed");
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
        let left = cg.compose(&cg.compose(&f1, &f2).expect("Compose should succeed"), &f3).expect("Compose should succeed");
        let right = cg.compose(&f1, &cg.compose(&f2, &f3).expect("Compose should succeed")).expect("Compose should succeed");
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
        assert!(result.is_reduced(), "Composed form ({}, {}, {}) is not reduced", result.a, result.b, result.c);
        assert_eq!(result.discriminant(), disc_value);
    }
}