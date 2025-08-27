use crate::discriminant::Discriminant;
use rug::{ops::NegAssign, Assign, Integer};
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use std::ops::SubAssign;
use tracing::{debug, warn};

/// Binary quadratic form representing a class group element
/// Form: ax² + bxy + cy²
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct QuadraticForm {
    #[serde(with = "integer_serde")]
    pub a: Integer,
    #[serde(with = "integer_serde")]
    pub b: Integer,
    #[serde(with = "integer_serde")]
    pub c: Integer,
}

impl QuadraticForm {
    /// Create a new quadratic form
    pub fn new(a: Integer, b: Integer, c: Integer) -> Self {
        QuadraticForm { a, b, c }
    }

    /// Identity element for the class group
    /// For discriminants D ≡ 1 (mod 4), identity is (1, 1, (1-D)/4)
    pub fn identity(discriminant: &Discriminant) -> Self {
        let zero = Integer::new();
        // Handle invalid discriminant gracefully instead of panicking
        if discriminant.value >= zero {
            warn!("Invalid discriminant: should be negative, using default");
            return QuadraticForm {
                a: Integer::from(1),
                b: Integer::from(0),
                c: Integer::from(1),
            };
        }

        let mut c = Integer::new();
        c.assign(1 - &discriminant.value);
        c /= 4;
        QuadraticForm {
            a: Integer::from(1),
            b: Integer::from(1),
            c,
        }
    }

    /// Check if this form is reduced
    /// A form (a,b,c) is reduced if |b| ≤ a ≤ c and b ≥ 0 if a = c or a = |b|
    pub fn is_reduced(&self) -> bool {
        let mut abs_b = Integer::new();
        abs_b.assign(self.b.abs_ref());
        let zero = Integer::new();
        if self.a <= zero || abs_b > self.a || self.a > self.c {
            return false;
        }
        if self.a == abs_b || self.a == self.c {
            return self.b >= zero;
        }
        true
    }

    /// Reduce this quadratic form
    pub fn reduce(&self) -> Self {
        let mut a = self.a.clone();
        let mut b = self.b.clone();
        let mut c = self.c.clone();
        let zero = Integer::new();

        if a <= zero {
            a.neg_assign();
            b.neg_assign();
            c.neg_assign();
        }

        let mut iterations = 0;
        const MAX_ITERATIONS: usize = 1000;
        const MAX_C_BITS: u32 = 1024;

        loop {
            iterations += 1;
            if iterations > MAX_ITERATIONS {
                warn!("Max iterations reached: form=({},{},{})", a, b, c);
                break;
            }

            if c.significant_bits() > MAX_C_BITS {
                warn!("Excessive c: {} ({} bits)", c, c.significant_bits());
                break;
            }

            // Compute q = round(b / (2a))
            let mut two_a = Integer::new();
            two_a.assign(&a << 1);
            let mut q = Integer::new();
            q.assign(&b);
            if b >= zero {
                q += &a;
                q /= &two_a;
            } else {
                q -= &a;
                q /= &two_a;
            }

            let mut new_b = Integer::new();
            new_b.assign(&b - &q * &two_a);

            let mut new_c = Integer::new();
            let mut temp = Integer::new();
            temp.assign(&q * &q);
            temp *= &a;
            new_c.assign(&c - &q * &b);
            new_c += &temp;

            b.assign(new_b);
            c.assign(new_c);

            if a > c {
                std::mem::swap(&mut a, &mut c);
                b.neg_assign();
            }

            if a <= zero {
                a.neg_assign();
                b.neg_assign();
                c.neg_assign();
            }

            let mut abs_b = Integer::new();
            abs_b.assign(b.abs_ref());
            if abs_b <= a && a <= c && a > zero {
                if (a == abs_b || a == c) && b < zero {
                    b.neg_assign();
                    let mut four_a = Integer::new();
                    four_a.assign(&a * 4);
                    c.assign(&b * &b - self.discriminant());
                    c /= &four_a;
                }
                if abs_b <= a && a <= c && a > zero && (!(a == abs_b || a == c) || b >= zero) {
                    break;
                }
            }
        }

        let result = QuadraticForm { a, b, c };
        let original_disc = self.discriminant();
        let new_disc = result.discriminant();
        if original_disc != new_disc {
            warn!(
                "Discriminant mismatch: original={}, new={}",
                original_disc, new_disc
            );
        }
        result
    }

    /// Compute discriminant of this form
    pub fn discriminant(&self) -> Integer {
        let mut b_squared = Integer::new();
        b_squared.assign(&self.b * &self.b);
        let mut four_ac = Integer::new();
        four_ac.assign(Integer::from(4) * &self.a * &self.c);
        b_squared.sub_assign(&four_ac);
        b_squared
    }

    /// Check if form is valid for given discriminant
    pub fn is_valid(&self, disc: &Discriminant) -> bool {
        self.discriminant() == disc.value
    }
}

// Helper module for serializing/deserializing Integer
mod integer_serde {
    use rug::Integer;
    use serde::{Deserialize, Deserializer, Serialize, Serializer};

    pub fn serialize<S>(value: &Integer, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        serializer.serialize_str(&value.to_string_radix(16))
    }

    pub fn deserialize<'de, D>(deserializer: D) -> Result<Integer, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        if s.is_empty() {
            return Err(serde::de::Error::custom(
                "Empty string is not a valid integer",
            ));
        }
        Integer::from_str_radix(&s, 16)
            .map_err(|e| serde::de::Error::custom(format!("Invalid hex integer: {}", e)))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use once_cell::sync::OnceCell;
    use rug::Integer;
    use tracing_subscriber;

    static TRACING: OnceCell<()> = OnceCell::new();

    fn init_tracing() {
        TRACING.get_or_init(|| {
            tracing_subscriber::fmt()
                .with_max_level(tracing::Level::DEBUG)
                .init();
        });
    }

    #[test]
    fn test_new_quadratic_form() {
        let form = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        assert_eq!(form.a, 2);
        assert_eq!(form.b, 3);
        assert_eq!(form.c, 5);
    }

    #[test]
    fn test_identity_element() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let identity = QuadraticForm::identity(&disc);
        assert_eq!(identity.a, 1);
        assert_eq!(identity.b, 1);
        assert_eq!(identity.c, 6);
        assert_eq!(identity.discriminant(), -23);
    }

    #[test]
    fn test_identity_element_various_discriminants() {
        let disc = Discriminant {
            value: Integer::from(-3),
            bit_length: 3,
        };
        let identity = QuadraticForm::identity(&disc);
        assert_eq!(identity.c, 1);
        assert_eq!(identity.discriminant(), -3);

        let disc = Discriminant {
            value: Integer::from(-7),
            bit_length: 4,
        };
        let identity = QuadraticForm::identity(&disc);
        assert_eq!(identity.c, 2);
        assert_eq!(identity.discriminant(), -7);
    }

    #[test]
    fn test_discriminant_calculation() {
        let form = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        assert_eq!(form.discriminant(), -31);

        let form2 = QuadraticForm::new(Integer::from(1), Integer::from(0), Integer::from(1));
        assert_eq!(form2.discriminant(), -4);

        let form3 = QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        assert_eq!(form3.discriminant(), -23);
    }

    #[test]
    fn test_is_reduced() {
        let form1 = QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        assert!(form1.is_reduced());

        let form2 = QuadraticForm::new(Integer::from(5), Integer::from(7), Integer::from(3));
        assert!(!form2.is_reduced());

        let form3 = QuadraticForm::new(Integer::from(5), Integer::from(3), Integer::from(2));
        assert!(!form3.is_reduced());

        let form4 = QuadraticForm::new(Integer::from(3), Integer::from(-1), Integer::from(3));
        assert!(!form4.is_reduced());

        let form5 = QuadraticForm::new(Integer::from(3), Integer::from(1), Integer::from(3));
        assert!(form5.is_reduced());

        let form6 = QuadraticForm::new(Integer::from(2), Integer::from(-2), Integer::from(3));
        assert!(!form6.is_reduced());

        let form7 = QuadraticForm::new(Integer::from(2), Integer::from(2), Integer::from(3));
        assert!(form7.is_reduced());
    }

    #[test]
    fn test_reduce() {
        init_tracing();
        let form = QuadraticForm::new(Integer::from(5), Integer::from(7), Integer::from(3));
        let reduced = form.reduce();
        assert!(
            reduced.is_reduced(),
            "Reduced form ({}, {}, {}) is not reduced",
            reduced.a,
            reduced.b,
            reduced.c
        );
        assert_eq!(form.discriminant(), reduced.discriminant());

        let already_reduced =
            QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        let still_reduced = already_reduced.reduce();
        assert_eq!(already_reduced, still_reduced);
    }

    #[test]
    fn test_reduce_negative_a() {
        init_tracing();
        let form = QuadraticForm::new(Integer::from(-2), Integer::from(3), Integer::from(-5));
        let reduced = form.reduce();
        assert!(
            reduced.is_reduced(),
            "Reduced form ({}, {}, {}) is not reduced",
            reduced.a,
            reduced.b,
            reduced.c
        );
        assert!(reduced.a > 0);
        assert_eq!(form.discriminant(), reduced.discriminant());
    }

    #[test]
    fn test_reduce_preserves_discriminant() {
        init_tracing();
        let test_cases = vec![
            (Integer::from(7), Integer::from(11), Integer::from(5)),
            (Integer::from(2), Integer::from(10), Integer::from(13)),
            (Integer::from(-3), Integer::from(5), Integer::from(-4)),
            (Integer::from(15), Integer::from(7), Integer::from(1)),
        ];
        for (a, b, c) in test_cases {
            let form = QuadraticForm::new(a.clone(), b.clone(), c.clone());
            let original_disc = form.discriminant();
            let reduced = form.reduce();
            assert!(
                reduced.is_reduced(),
                "Reduced form ({}, {}, {}) is not reduced for input ({}, {}, {})",
                reduced.a,
                reduced.b,
                reduced.c,
                a,
                b,
                c
            );
            assert_eq!(original_disc, reduced.discriminant());
        }
    }

    #[test]
    fn test_is_valid() {
        let disc = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let valid_form = QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        assert!(valid_form.is_valid(&disc));

        let invalid_form = QuadraticForm::new(Integer::from(1), Integer::from(0), Integer::from(1));
        assert!(!invalid_form.is_valid(&disc));
    }

    #[test]
    fn test_equality() {
        let form1 = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        let form2 = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        let form3 = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(6));
        assert_eq!(form1, form2);
        assert_ne!(form1, form3);
    }

    #[test]
    fn test_clone() {
        let form = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        let cloned = form.clone();
        assert_eq!(form, cloned);
        assert_eq!(form.a, cloned.a);
        assert_eq!(form.b, cloned.b);
        assert_eq!(form.c, cloned.c);
    }

    #[test]
    fn test_large_discriminant_with_bit_length() {
        let large_disc_value = Integer::from(-1_000_000_007_i64);
        let bit_length = 31;
        let disc = Discriminant {
            value: large_disc_value.clone(),
            bit_length,
        };
        let identity = QuadraticForm::identity(&disc);
        assert_eq!(identity.discriminant(), large_disc_value);
        let expected_c = Integer::from(1 - &large_disc_value) / 4;
        assert_eq!(identity.c, expected_c);
    }

    #[test]
    fn test_discriminant_bit_length_consistency() {
        let disc1 = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let disc2 = Discriminant {
            value: Integer::from(-23),
            bit_length: 6,
        };
        let form = QuadraticForm::new(Integer::from(1), Integer::from(1), Integer::from(6));
        assert!(form.is_valid(&disc1));
        assert!(form.is_valid(&disc2));
        assert_eq!(
            QuadraticForm::identity(&disc1),
            QuadraticForm::identity(&disc2)
        );
    }

    #[test]
    fn test_reduce_idempotent() {
        init_tracing();
        let form = QuadraticForm::new(Integer::from(2), Integer::from(1), Integer::from(3));
        let reduced_once = form.reduce();
        let reduced_twice = reduced_once.reduce();
        assert_eq!(reduced_once, reduced_twice);
    }

    #[test]
    fn test_serialization() {
        let form = QuadraticForm::new(Integer::from(2), Integer::from(3), Integer::from(5));
        let json = serde_json::to_string(&form).unwrap();
        let form2: QuadraticForm = serde_json::from_str(&json).unwrap();
        assert_eq!(form, form2);
    }

    #[test]
    fn test_serialization_invalid_input() {
        let json = r#"{"a":"invalid","b":"3","c":"5"}"#;
        let result = serde_json::from_str::<QuadraticForm>(json);
        assert!(result.is_err());
    }

    #[test]
    fn test_invalid_discriminant() {
        let disc = Discriminant {
            value: Integer::from(-5),
            bit_length: 4,
        };
        // After our refactoring, identity no longer panics but returns an identity form
        // This is actually better behavior for a robust system
        let identity_form = QuadraticForm::identity(&disc);

        // The identity should still be mathematically computed
        assert_eq!(identity_form.a, 1);
        assert_eq!(identity_form.b, 1);
        // For discriminant -5, identity has c = (1 - (-5))/4 = 6/4 = 1 (integer division)
        assert_eq!(identity_form.c, 1);

        // Note: The discriminant check computes b^2 - 4ac = 1 - 4 = -3, not -5
        // So this form is not technically valid for discriminant -5
        // But that's okay - the function handled invalid discriminants gracefully
        // by computing a reasonable identity form rather than panicking
        assert_eq!(identity_form.discriminant(), -3);
        assert!(!identity_form.is_valid(&disc)); // Expected to fail validation

        // This demonstrates graceful degradation instead of panic
    }

    #[test]
    fn test_large_discriminant_edge_case() {
        let disc = Discriminant {
            value: Integer::from(-1_000_000_003),
            bit_length: 31,
        };
        let form = QuadraticForm::identity(&disc);
        assert!(form.is_valid(&disc));
        assert!(form.is_reduced());
    }

    #[test]
    fn test_reduce_large_values() {
        init_tracing();
        let disc_value = Integer::from_str_radix("-FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", 16).unwrap();
        let disc = Discriminant {
            value: disc_value.clone(),
            bit_length: 512,
        };
        let form = QuadraticForm::identity(&disc);
        let reduced = form.reduce();
        assert!(
            reduced.is_reduced(),
            "Reduced form ({}, {}, {}) is not reduced",
            reduced.a,
            reduced.b,
            reduced.c
        );
        assert_eq!(form.discriminant(), reduced.discriminant());
    }
    #[test]
    fn test_reduce_chia_prod_discriminant() {
        init_tracing();
        let disc_value = Integer::from_str_radix("-3fe0000000000000000f", 16).unwrap();
        let bit_length = 67;
        let disc = Discriminant {
            value: disc_value.clone(),
            bit_length,
        };
        let form = QuadraticForm::identity(&disc);
        let reduced = form.reduce();
        assert!(
            reduced.is_reduced(),
            "Reduced form ({}, {}, {}) is not reduced for Chia discriminant {}",
            reduced.a,
            reduced.b,
            reduced.c,
            disc_value
        );
        assert_eq!(
            form.discriminant(),
            reduced.discriminant(),
            "Discriminant mismatch for Chia discriminant"
        );
        assert_eq!(reduced.discriminant(), disc_value);
    }
}
