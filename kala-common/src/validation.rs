//! Input validation utilities and patterns

use crate::{
    crypto::CryptoUtils,
    error::{KalaError, KalaResult},
    types::{BlockHeight, Hash, IterationNumber, NodeId, PublicKey, Signature, Timestamp},
};

/// Validation utilities for common data types
pub struct ValidationUtils;

impl ValidationUtils {
    /// Validate hex string format and length
    pub fn validate_hex_string(hex_str: &str, expected_length: usize) -> KalaResult<()> {
        if hex_str.is_empty() {
            return Err(KalaError::validation("Hex string cannot be empty"));
        }

        if hex_str.len() != expected_length * 2 {
            return Err(KalaError::validation(format!(
                "Invalid hex length: expected {}, got {}",
                expected_length * 2,
                hex_str.len()
            )));
        }

        if !hex_str.chars().all(|c| c.is_ascii_hexdigit()) {
            return Err(KalaError::validation("Invalid hex characters"));
        }

        Ok(())
    }

    /// Validate and parse hash from hex string
    pub fn validate_hash_hex(hex_str: &str) -> KalaResult<Hash> {
        Self::validate_hex_string(hex_str, 32)?;
        CryptoUtils::hex_to_hash(hex_str)
    }

    /// Validate and parse public key from hex string
    pub fn validate_pubkey_hex(hex_str: &str) -> KalaResult<PublicKey> {
        Self::validate_hex_string(hex_str, 32)?;
        let bytes = hex::decode(hex_str)
            .map_err(|e| KalaError::validation(format!("Invalid hex: {}", e)))?;

        let mut pubkey = [0u8; 32];
        pubkey.copy_from_slice(&bytes);

        if !CryptoUtils::validate_pubkey(&pubkey) {
            return Err(KalaError::validation(
                "Invalid public key: zero or invalid format",
            ));
        }

        Ok(pubkey)
    }

    /// Validate and parse signature from hex string  
    pub fn validate_signature_hex(hex_str: &str) -> KalaResult<Signature> {
        Self::validate_hex_string(hex_str, 64)?;
        let bytes = hex::decode(hex_str)
            .map_err(|e| KalaError::validation(format!("Invalid hex: {}", e)))?;

        let mut signature = [0u8; 64];
        signature.copy_from_slice(&bytes);

        if !CryptoUtils::validate_signature(&signature) {
            return Err(KalaError::validation(
                "Invalid signature: zero or invalid format",
            ));
        }

        Ok(signature)
    }

    /// Validate node ID
    pub fn validate_node_id(node_id: &NodeId) -> KalaResult<()> {
        if *node_id == [0u8; 32] {
            return Err(KalaError::validation("Node ID cannot be zero"));
        }
        Ok(())
    }

    /// Validate timestamp
    pub fn validate_timestamp(timestamp: Timestamp) -> KalaResult<()> {
        const MIN_TIMESTAMP: u64 = 1609459200; // 2021-01-01
        const MAX_TIMESTAMP: u64 = 32503680000; // 2999-12-31

        if timestamp < MIN_TIMESTAMP {
            return Err(KalaError::validation("Timestamp too old"));
        }

        if timestamp > MAX_TIMESTAMP {
            return Err(KalaError::validation("Timestamp too far in future"));
        }

        Ok(())
    }

    /// Validate block height
    pub fn validate_block_height(height: BlockHeight) -> KalaResult<()> {
        const MAX_BLOCK_HEIGHT: u64 = u64::MAX / 2; // Reasonable upper bound

        if height > MAX_BLOCK_HEIGHT {
            return Err(KalaError::validation("Block height too large"));
        }

        Ok(())
    }

    /// Validate iteration number
    pub fn validate_iteration_number(iterations: IterationNumber) -> KalaResult<()> {
        if iterations == 0 {
            return Err(KalaError::validation("Iteration number cannot be zero"));
        }

        const MAX_ITERATIONS: u64 = 1_000_000_000; // 1B iterations max

        if iterations > MAX_ITERATIONS {
            return Err(KalaError::validation("Iteration number too large"));
        }

        Ok(())
    }

    /// Validate JSON structure
    pub fn validate_json_string(json_str: &str) -> KalaResult<serde_json::Value> {
        serde_json::from_str(json_str)
            .map_err(|e| KalaError::validation(format!("Invalid JSON: {}", e)))
    }

    /// Validate amount/value (for transactions)
    pub fn validate_amount(amount: u64) -> KalaResult<()> {
        const MAX_AMOUNT: u64 = 1_000_000_000_000_000_000; // 1 quintillion max

        if amount > MAX_AMOUNT {
            return Err(KalaError::validation("Amount too large"));
        }

        Ok(())
    }

    /// Validate string length
    pub fn validate_string_length(s: &str, max_len: usize, field_name: &str) -> KalaResult<()> {
        if s.len() > max_len {
            return Err(KalaError::validation(format!(
                "{} too long: {} bytes (max {})",
                field_name,
                s.len(),
                max_len
            )));
        }
        Ok(())
    }

    /// Validate byte array length
    pub fn validate_bytes_length(
        bytes: &[u8],
        expected_len: usize,
        field_name: &str,
    ) -> KalaResult<()> {
        if bytes.len() != expected_len {
            return Err(KalaError::validation(format!(
                "{} invalid length: {} bytes (expected {})",
                field_name,
                bytes.len(),
                expected_len
            )));
        }
        Ok(())
    }

    /// Validate address format (generic address validation)
    pub fn validate_address(address: &str) -> KalaResult<()> {
        if address.is_empty() {
            return Err(KalaError::validation("Address cannot be empty"));
        }

        Self::validate_string_length(address, 128, "Address")?;

        // Basic format validation - addresses should be hex or base58
        if address.starts_with("0x") {
            // Hex format
            Self::validate_hex_string(&address[2..], address.len() / 2 - 1)?;
        } else {
            // Assume base58 - basic character validation
            if !address
                .chars()
                .all(|c| c.is_ascii_alphanumeric() && !"0OIl".contains(c))
            {
                return Err(KalaError::validation("Invalid address format"));
            }
        }

        Ok(())
    }

    /// Validate network message size
    pub fn validate_message_size(data: &[u8]) -> KalaResult<()> {
        const MAX_MESSAGE_SIZE: usize = 16 * 1024 * 1024; // 16MB

        if data.len() > MAX_MESSAGE_SIZE {
            return Err(KalaError::validation(format!(
                "Message too large: {} bytes (max {})",
                data.len(),
                MAX_MESSAGE_SIZE
            )));
        }

        Ok(())
    }

    /// Validate VDF parameters
    pub fn validate_vdf_params(
        discriminant: &str,
        iterations: IterationNumber,
        input: &[u8],
    ) -> KalaResult<()> {
        // Validate discriminant format (should be a large negative integer)
        if !discriminant.starts_with('-') {
            return Err(KalaError::validation("VDF discriminant must be negative"));
        }

        let number_part = &discriminant[1..];
        if !number_part.chars().all(|c| c.is_ascii_digit()) {
            return Err(KalaError::validation(
                "VDF discriminant contains invalid characters",
            ));
        }

        if discriminant.len() < 100 {
            return Err(KalaError::validation("VDF discriminant too short"));
        }

        Self::validate_iteration_number(iterations)?;

        if input.is_empty() {
            return Err(KalaError::validation("VDF input cannot be empty"));
        }

        if input.len() > 1024 {
            return Err(KalaError::validation("VDF input too large"));
        }

        Ok(())
    }

    /// Validate range for numeric values
    pub fn validate_range<T: PartialOrd + Copy + std::fmt::Debug>(
        value: T,
        min: T,
        max: T,
        field_name: &str,
    ) -> KalaResult<T> {
        if value < min || value > max {
            return Err(KalaError::validation(format!(
                "{} out of range (min: {:?}, max: {:?})",
                field_name, min, max
            )));
        }
        Ok(value)
    }

    /// Batch validation for multiple values
    pub fn validate_batch<T, F>(items: &[T], validator: F, field_name: &str) -> KalaResult<()>
    where
        F: Fn(&T) -> KalaResult<()>,
    {
        for (i, item) in items.iter().enumerate() {
            validator(item)
                .map_err(|e| KalaError::validation(format!("{}[{}]: {}", field_name, i, e)))?;
        }
        Ok(())
    }
}

/// Validation patterns for common use cases
pub mod patterns {
    use super::*;

    /// Transaction validation pattern
    pub fn validate_transaction_data(
        from: &str,
        to: &str,
        amount: u64,
        signature_hex: &str,
    ) -> KalaResult<()> {
        ValidationUtils::validate_address(from)?;
        ValidationUtils::validate_address(to)?;
        ValidationUtils::validate_amount(amount)?;
        ValidationUtils::validate_signature_hex(signature_hex)?;
        Ok(())
    }

    /// Block validation pattern
    pub fn validate_block_data(
        height: BlockHeight,
        timestamp: Timestamp,
        previous_hash_hex: &str,
        merkle_root_hex: &str,
    ) -> KalaResult<()> {
        ValidationUtils::validate_block_height(height)?;
        ValidationUtils::validate_timestamp(timestamp)?;
        ValidationUtils::validate_hash_hex(previous_hash_hex)?;
        ValidationUtils::validate_hash_hex(merkle_root_hex)?;
        Ok(())
    }

    /// Network message validation pattern
    pub fn validate_network_message(
        message_type: &str,
        sender_id_hex: &str,
        payload: &[u8],
        signature_hex: &str,
    ) -> KalaResult<()> {
        ValidationUtils::validate_string_length(message_type, 32, "Message type")?;
        ValidationUtils::validate_pubkey_hex(sender_id_hex)?;
        ValidationUtils::validate_message_size(payload)?;
        ValidationUtils::validate_signature_hex(signature_hex)?;
        Ok(())
    }

    /// VDF tick validation pattern
    pub fn validate_vdf_tick(
        tick_number: BlockHeight,
        input_hex: &str,
        output_hex: &str,
        proof_hex: &str,
        iterations: IterationNumber,
    ) -> KalaResult<()> {
        ValidationUtils::validate_block_height(tick_number)?;
        ValidationUtils::validate_hash_hex(input_hex)?;
        ValidationUtils::validate_hash_hex(output_hex)?;
        ValidationUtils::validate_iteration_number(iterations)?;

        // Validate proof (variable length, but should be reasonable)
        let proof_bytes = hex::decode(proof_hex)
            .map_err(|e| KalaError::validation(format!("Invalid proof hex: {}", e)))?;

        if proof_bytes.is_empty() || proof_bytes.len() > 10240 {
            return Err(KalaError::validation("Invalid proof length"));
        }

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hex_validation() {
        // Valid hex
        assert!(ValidationUtils::validate_hex_string("deadbeef", 4).is_ok());
        assert!(ValidationUtils::validate_hex_string("0123456789abcdef", 8).is_ok());

        // Invalid length
        assert!(ValidationUtils::validate_hex_string("abc", 4).is_err());

        // Invalid characters
        assert!(ValidationUtils::validate_hex_string("xyz", 2).is_err());

        // Empty string
        assert!(ValidationUtils::validate_hex_string("", 0).is_err());
    }

    #[test]
    fn test_hash_validation() {
        let valid_hash = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
        assert!(ValidationUtils::validate_hash_hex(valid_hash).is_ok());

        let invalid_hash = "invalid";
        assert!(ValidationUtils::validate_hash_hex(invalid_hash).is_err());
    }

    #[test]
    fn test_timestamp_validation() {
        // Valid timestamps
        assert!(ValidationUtils::validate_timestamp(1609459200).is_ok()); // 2021
        assert!(ValidationUtils::validate_timestamp(1640995200).is_ok()); // 2022

        // Too old
        assert!(ValidationUtils::validate_timestamp(1000000000).is_err());

        // Too far in future
        assert!(ValidationUtils::validate_timestamp(99999999999).is_err());
    }

    #[test]
    fn test_amount_validation() {
        // Valid amounts
        assert!(ValidationUtils::validate_amount(0).is_ok());
        assert!(ValidationUtils::validate_amount(1000000).is_ok());

        // Too large
        assert!(ValidationUtils::validate_amount(u64::MAX).is_err());
    }

    #[test]
    fn test_address_validation() {
        // Valid hex address
        assert!(ValidationUtils::validate_address("0x1234567890abcdef").is_ok());

        // Valid base58-like address
        assert!(ValidationUtils::validate_address("ABC123def456").is_ok());

        // Empty address
        assert!(ValidationUtils::validate_address("").is_err());

        // Too long
        let long_address = "x".repeat(200);
        assert!(ValidationUtils::validate_address(&long_address).is_err());
    }

    #[test]
    fn test_vdf_params_validation() {
        let discriminant = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";
        let iterations = 65536;
        let input = b"test_input";

        assert!(ValidationUtils::validate_vdf_params(discriminant, iterations, input).is_ok());

        // Invalid discriminant (positive)
        assert!(ValidationUtils::validate_vdf_params("12345", iterations, input).is_err());

        // Zero iterations
        assert!(ValidationUtils::validate_vdf_params(discriminant, 0, input).is_err());

        // Empty input
        assert!(ValidationUtils::validate_vdf_params(discriminant, iterations, &[]).is_err());
    }
}
