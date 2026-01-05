//kala-tick/src/discriminant.rs
use kala_common::error::{CVDFError, KalaError, KalaResult};
use rug::rand::RandState;
use rug::Integer;
use serde::{Deserialize, Serialize};

/// Discriminant for the class group
/// Using negative discriminants for imaginary quadratic fields
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Discriminant {
    /// The discriminant value (negative)
    #[serde(with = "integer_serde")]
    pub value: Integer,
    /// Bit length for security
    pub bit_length: u32,
}

impl Discriminant {
    /// Generate a random negative discriminant
    /// Ensures -D ≡ 3 (mod 4) for unique factorization
    pub fn generate(bits: u32) -> KalaResult<Self> {
        // Create a random state using the default algorithm
        let mut rand_state = RandState::new();

        // Generate random number with the desired bit length
        let mut d = Integer::from(Integer::random_bits(bits, &mut rand_state));

        // Ensure negative
        if d > 0 {
            d = -d;
        }

        // Ensure -D ≡ 3 (mod 4) which means D ≡ 1 (mod 4)
        let four = Integer::from(4);
        let remainder = d.clone().modulo(&four);

        // Adjust to ensure D ≡ 1 (mod 4)
        // Since D is negative, we want D ≡ 1 (mod 4)
        // which is equivalent to -D ≡ 3 (mod 4)
        match remainder.to_i32().unwrap_or(0) {
            1 | -3 => {
                // Already correct
            }
            0 | -4 => {
                d += 1;
            }
            2 | -2 => {
                d -= 1;
            }
            3 | -1 => {
                d -= 2;
            }
            _ => {
                // Handle any other case (shouldn't happen with mod 4)
                d = d - remainder + 1;
            }
        }

        Ok(Discriminant {
            value: d,
            bit_length: bits,
        })
    }

    /// Create from a specific value (for testing or known discriminants)
    pub fn from_value(value: Integer) -> KalaResult<Self> {
        if value >= 0 {
            return Err(KalaError::CVDFError(CVDFError::InvalidDiscriminant));
        }

        // Check -D ≡ 3 (mod 4)
        let four = Integer::from(4);
        let neg_d = Integer::from(-&value);
        if neg_d.modulo(&four) != 3 {
            return Err(KalaError::CVDFError(CVDFError::InvalidDiscriminant));
        }

        let bit_length = value.significant_bits();
        Ok(Discriminant { value, bit_length })
    }

    /// Create from a hex string (useful for Chia's discriminant)
    pub fn from_hex(hex_str: &str) -> KalaResult<Self> {
        let value = Integer::from_str_radix(hex_str, 16)
            .map_err(|_| KalaError::CVDFError(CVDFError::InvalidDiscriminant))?;
        Self::from_value(value)
    }

    /// Create from a decimal string
    pub fn from_dec(dec_str: &str) -> KalaResult<Self> {
        let value = Integer::from_str_radix(dec_str, 10)
            .map_err(|_| KalaError::CVDFError(CVDFError::InvalidDiscriminant))?;
        Self::from_value(value)
    }
}

// Helper module for serializing/deserializing Integer
mod integer_serde {
    use super::*;
    use serde::{Deserializer, Serializer};

    pub fn serialize<S>(value: &Integer, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        // Serialize as hex string for compactness
        serializer.serialize_str(&value.to_string_radix(16))
    }

    pub fn deserialize<'de, D>(deserializer: D) -> Result<Integer, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        Integer::from_str_radix(&s, 16)
            .map_err(|e| serde::de::Error::custom(format!("Invalid integer: {}", e)))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_discriminant_generation() {
        let disc = Discriminant::generate(256).unwrap();

        // Check it's negative
        assert!(disc.value < 0);

        // Check -D ≡ 3 (mod 4)
        let four = Integer::from(4);
        let neg_d = Integer::from(-&disc.value);
        assert_eq!(neg_d.modulo(&four), 3);

        // Check bit length is approximately correct
        assert!(disc.value.significant_bits() <= 256);
    }

    #[test]
    fn test_from_value_valid() {
        // -7 is a valid discriminant since -(-7) = 7 ≡ 3 (mod 4)
        let disc = Discriminant::from_value(Integer::from(-7)).unwrap();
        assert_eq!(disc.value, -7);
    }

    #[test]
    fn test_from_value_invalid_positive() {
        // Positive values should be rejected
        let result = Discriminant::from_value(Integer::from(7));
        assert!(result.is_err());
    }

    #[test]
    fn test_from_value_invalid_modulus() {
        // -8 is invalid since -(-8) = 8 ≡ 0 (mod 4), not 3
        let result = Discriminant::from_value(Integer::from(-8));
        assert!(result.is_err());
    }

    #[test]
    fn test_chia_production_discriminant() {
        // Chia's production discriminant (1024-bit)
        let chia_disc_str = "-124066695684124741398798927404814432744698427125735684128131855064976895337309138910015071214657674309443149407457784008482598157929231340464085999434282861720534396192739736935050532214954818802779747295302822211107847281287030932738037727304145398879969731231251163866678649517086953552040496395816730581483";

        let disc = Discriminant::from_dec(chia_disc_str).unwrap();
        assert_eq!(disc.value.to_string_radix(10), chia_disc_str);

        // Verify it satisfies the congruence condition
        let four = Integer::from(4);
        let neg_d = Integer::from(-&disc.value);
        assert_eq!(neg_d.modulo(&four), 3);

        // Check it's approximately 1024 bits
        let bits = disc.value.significant_bits();
        assert!(bits >= 1023 && bits <= 1024);
    }

    #[test]
    fn test_serialization() {
        let disc = Discriminant::from_value(Integer::from(-23)).unwrap();

        // Serialize to JSON
        let json = serde_json::to_string(&disc).unwrap();

        // Deserialize back
        let disc2: Discriminant = serde_json::from_str(&json).unwrap();

        assert_eq!(disc.value, disc2.value);
        assert_eq!(disc.bit_length, disc2.bit_length);
    }
}
