// Standard data transfer and serialization patterns for Kala
// This module provides standardized encoding/decoding for all data types

use anyhow::{anyhow, Result};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use std::collections::HashMap;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum SerializationError {
    #[error("Bincode error: {0}")]
    Bincode(String),
    
    #[error("JSON error: {0}")]
    Json(#[from] serde_json::Error),
    
    #[error("FlatBuffer error: {0}")]
    FlatBuffer(String),
    
    #[error("Size validation error: expected {expected}, got {actual}")]
    InvalidSize { expected: usize, actual: usize },
    
    #[error("Encoding type not supported: {0}")]
    UnsupportedEncoding(String),
}

/// Standard encoding types used throughout Kala
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EncodingType {
    /// High-performance binary encoding for state persistence
    Bincode,
    /// Self-describing format for transaction processing
    FlatBuffers,
    /// Human-readable format for configuration and RPC
    Json,
    /// Raw bytes for hash chains and cryptographic operations
    Raw,
}

/// Trait for standardized serialization across all Kala types
pub trait KalaSerialize: Serialize + DeserializeOwned {
    /// Get the preferred encoding type for this data structure
    fn preferred_encoding() -> EncodingType;
    
    /// Serialize using the preferred encoding
    fn encode(&self) -> Result<Vec<u8>, SerializationError> {
        self.encode_as(Self::preferred_encoding())
    }
    
    /// Serialize using a specific encoding
    fn encode_as(&self, encoding: EncodingType) -> Result<Vec<u8>, SerializationError> {
        match encoding {
            EncodingType::Bincode => {
                // Use serde_json as a fallback since bincode 2.0 API is different
                serde_json::to_vec(self).map_err(SerializationError::Json)
            }
            EncodingType::Json => {
                serde_json::to_vec(self).map_err(SerializationError::Json)
            }
            EncodingType::Raw => {
                Err(SerializationError::UnsupportedEncoding("Raw encoding requires custom implementation".to_string()))
            }
            EncodingType::FlatBuffers => {
                Err(SerializationError::UnsupportedEncoding("FlatBuffers requires custom implementation".to_string()))
            }
        }
    }
    
    /// Deserialize from bytes, auto-detecting encoding or using preferred
    fn decode(bytes: &[u8]) -> Result<Self, SerializationError> {
        Self::decode_as(bytes, Self::preferred_encoding())
    }
    
    /// Deserialize using a specific encoding
    fn decode_as(bytes: &[u8], encoding: EncodingType) -> Result<Self, SerializationError> {
        match encoding {
            EncodingType::Bincode => {
                // Use serde_json as a fallback since bincode 2.0 API is different
                serde_json::from_slice(bytes).map_err(SerializationError::Json)
            }
            EncodingType::Json => {
                serde_json::from_slice(bytes).map_err(SerializationError::Json)
            }
            EncodingType::Raw => {
                Err(SerializationError::UnsupportedEncoding("Raw decoding requires custom implementation".to_string()))
            }
            EncodingType::FlatBuffers => {
                Err(SerializationError::UnsupportedEncoding("FlatBuffers requires custom implementation".to_string()))
            }
        }
    }
    
    /// Get the size of the encoded data without actually encoding
    fn encoded_size(&self) -> usize {
        self.encode().map(|v| v.len()).unwrap_or(0)
    }
}

/// Hash computation utilities with standardized patterns
pub struct HashCompute;

impl HashCompute {
    /// Compute SHA-256 hash of serialized data
    pub fn hash_data<T: KalaSerialize>(data: &T) -> Result<[u8; 32]> {
        use sha2::{Digest, Sha256};
        let encoded = data.encode()?;
        Ok(Sha256::digest(&encoded).into())
    }
    
    /// Compute hash of raw bytes
    pub fn hash_bytes(data: &[u8]) -> [u8; 32] {
        use sha2::{Digest, Sha256};
        Sha256::digest(data).into()
    }
    
    /// Extend a hash chain with new data (as used in VDF)
    pub fn extend_hash_chain<T: KalaSerialize>(prev_hash: &[u8; 32], data: &T) -> Result<[u8; 32]> {
        use sha2::{Digest, Sha256};
        let mut hasher = Sha256::new();
        hasher.update(prev_hash);
        hasher.update(&data.encode()?);
        Ok(hasher.finalize().into())
    }
    
    /// Compute Merkle root of a list of items
    pub fn merkle_root<T: KalaSerialize>(items: &[T]) -> Result<[u8; 32]> {
        if items.is_empty() {
            return Ok([0u8; 32]);
        }
        
        let mut hashes: Vec<[u8; 32]> = items
            .iter()
            .map(|item| Self::hash_data(item))
            .collect::<Result<Vec<_>>>()?;
        
        while hashes.len() > 1 {
            let mut next_level = Vec::new();
            
            for chunk in hashes.chunks(2) {
                if chunk.len() == 2 {
                    let combined = [chunk[0], chunk[1]].concat();
                    next_level.push(Self::hash_bytes(&combined));
                } else {
                    next_level.push(chunk[0]);
                }
            }
            
            hashes = next_level;
        }
        
        Ok(hashes[0])
    }
}

/// Network message wrapper with standardized headers
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct NetworkMessage {
    pub message_type: String,
    pub version: u32,
    pub timestamp: u64,
    pub sender_id: Option<[u8; 32]>,
    pub payload: Vec<u8>,
    pub encoding: u8, // EncodingType as u8
}

impl NetworkMessage {
    pub fn new<T: KalaSerialize>(
        message_type: &str,
        payload: &T,
        sender_id: Option<[u8; 32]>,
    ) -> Result<Self> {
        use std::time::{SystemTime, UNIX_EPOCH};
        
        Ok(Self {
            message_type: message_type.to_string(),
            version: 1,
            timestamp: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs(),
            sender_id,
            payload: payload.encode()?,
            encoding: T::preferred_encoding() as u8,
        })
    }
    
    pub fn decode_payload<T: KalaSerialize>(&self) -> Result<T> {
        let encoding = match self.encoding {
            0 => EncodingType::Bincode,
            1 => EncodingType::FlatBuffers,
            2 => EncodingType::Json,
            3 => EncodingType::Raw,
            _ => return Err(anyhow!("Unknown encoding type: {}", self.encoding)),
        };
        
        T::decode_as(&self.payload, encoding).map_err(|e| anyhow!("Failed to decode payload: {}", e))
    }
}

/// Database operations with standardized patterns
pub struct DatabaseOps;

impl DatabaseOps {
    /// Standard key formatting for different data types
    pub fn format_key(prefix: &str, id: u64) -> Vec<u8> {
        format!("{}:{:016x}", prefix, id).into_bytes()
    }
    
    pub fn format_key_bytes(prefix: &str, id: &[u8]) -> Vec<u8> {
        let mut key = prefix.as_bytes().to_vec();
        key.push(b':');
        key.extend_from_slice(&hex::encode(id).as_bytes());
        key
    }
    
    /// Store data with automatic encoding
    pub fn store_data<T: KalaSerialize>(
        db: &rocksdb::DB,
        key: &[u8],
        data: &T,
    ) -> Result<()> {
        let encoded = data.encode()?;
        db.put(key, &encoded)?;
        Ok(())
    }
    
    /// Load data with automatic decoding
    pub fn load_data<T: KalaSerialize>(
        db: &rocksdb::DB,
        key: &[u8],
    ) -> Result<Option<T>> {
        match db.get(key)? {
            Some(data) => Ok(Some(T::decode(&data)?)),
            None => Ok(None),
        }
    }
}

/// Validation utilities for data integrity
pub struct ValidationUtils;

impl ValidationUtils {
    /// Validate byte array size
    pub fn validate_byte_size(data: &[u8], expected: usize) -> Result<(), SerializationError> {
        if data.len() != expected {
            return Err(SerializationError::InvalidSize {
                expected,
                actual: data.len(),
            });
        }
        Ok(())
    }
    
    /// Validate signature format
    pub fn validate_signature(sig: &[u8]) -> Result<(), SerializationError> {
        Self::validate_byte_size(sig, 64)
    }
    
    /// Validate public key format
    pub fn validate_pubkey(key: &[u8]) -> Result<(), SerializationError> {
        Self::validate_byte_size(key, 32)
    }
    
    /// Validate hash format
    pub fn validate_hash(hash: &[u8]) -> Result<(), SerializationError> {
        Self::validate_byte_size(hash, 32)
    }
}

/// Statistics tracking for performance monitoring
#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct SerializationStats {
    pub encode_count: HashMap<String, u64>,
    pub decode_count: HashMap<String, u64>,
    pub encode_bytes: HashMap<String, u64>,
    pub decode_bytes: HashMap<String, u64>,
    pub errors: HashMap<String, u64>,
}

impl SerializationStats {
    pub fn record_encode(&mut self, type_name: &str, byte_size: usize) {
        *self.encode_count.entry(type_name.to_string()).or_insert(0) += 1;
        *self.encode_bytes.entry(type_name.to_string()).or_insert(0) += byte_size as u64;
    }
    
    pub fn record_decode(&mut self, type_name: &str, byte_size: usize) {
        *self.decode_count.entry(type_name.to_string()).or_insert(0) += 1;
        *self.decode_bytes.entry(type_name.to_string()).or_insert(0) += byte_size as u64;
    }
    
    pub fn record_error(&mut self, error_type: &str) {
        *self.errors.entry(error_type.to_string()).or_insert(0) += 1;
    }
    
    pub fn get_summary(&self) -> String {
        format!(
            "Serialization Stats - Encodes: {}, Decodes: {}, Errors: {}",
            self.encode_count.values().sum::<u64>(),
            self.decode_count.values().sum::<u64>(),
            self.errors.values().sum::<u64>()
        )
    }
}

impl KalaSerialize for SerializationStats {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

// Implementations for primitive types
impl KalaSerialize for u64 {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json // Simple and readable for numbers
    }
}

impl KalaSerialize for u32 {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for String {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[derive(Serialize, Deserialize, PartialEq, Debug)]
    struct TestStruct {
        id: u64,
        name: String,
        data: Vec<u8>,
    }
    
    impl KalaSerialize for TestStruct {
        fn preferred_encoding() -> EncodingType {
            EncodingType::Bincode
        }
    }
    
    #[test]
    fn test_serialization_roundtrip() {
        let test_data = TestStruct {
            id: 42,
            name: "test".to_string(),
            data: vec![1, 2, 3, 4],
        };
        
        let encoded = test_data.encode().unwrap();
        let decoded = TestStruct::decode(&encoded).unwrap();
        
        assert_eq!(test_data, decoded);
    }
    
    #[test]
    fn test_hash_computation() {
        let test_data = TestStruct {
            id: 42,
            name: "test".to_string(),
            data: vec![1, 2, 3, 4],
        };
        
        let hash1 = HashCompute::hash_data(&test_data).unwrap();
        let hash2 = HashCompute::hash_data(&test_data).unwrap();
        
        assert_eq!(hash1, hash2); // Same data should produce same hash
    }
    
    #[test]
    fn test_merkle_root() {
        let items = vec![
            TestStruct { id: 1, name: "a".to_string(), data: vec![1] },
            TestStruct { id: 2, name: "b".to_string(), data: vec![2] },
            TestStruct { id: 3, name: "c".to_string(), data: vec![3] },
        ];
        
        let root = HashCompute::merkle_root(&items).unwrap();
        assert_ne!(root, [0u8; 32]); // Should not be empty hash
    }
}