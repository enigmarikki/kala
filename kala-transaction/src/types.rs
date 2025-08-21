use kala_common::prelude::*;
use kala_common::types::{Hash, PublicKey, Signature};

// Use KalaError from kala-common instead of local TransactionError

pub use crate::generated::tx::{Bytes128, Bytes32, Nonce96, Tag128};

// Helper type aliases using kala-common types
pub type Bytes32Array = Hash; // Use Hash from kala-common
pub type PublicKeyArray = PublicKey; // Use PublicKey from kala-common
pub type SignatureArray = Signature; // Use Signature from kala-common
pub type Nonce96Array = [u8; 12];
pub type Tag128Array = [u8; 16];

// For large arrays, we'll use Vec<u8> with validation helpers
pub type Bytes64 = Vec<u8>;
pub type Bytes256 = Vec<u8>;

// Helper functions to create validated byte vectors
pub fn bytes64(arr: [u8; 64]) -> Bytes64 {
    arr.to_vec()
}

pub fn bytes256(arr: [u8; 256]) -> Bytes256 {
    arr.to_vec()
}

// Transaction structs
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Send {
    pub sender: Bytes32Array,
    pub receiver: Bytes32Array,
    pub denom: Bytes32Array,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Bytes64, // Now a Vec<u8>
    pub gas_sponsorer: Bytes32Array,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Mint {
    pub sender: Bytes32Array,
    pub amount: u64,
    pub denom: Bytes32Array,
    pub nonce: u64,
    pub signature: Bytes64, // As Vec<u8>
    pub gas_sponsorer: Bytes32Array,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Stake {
    pub sender: Bytes32Array,
    pub delegation_receiver: Bytes32Array,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32Array,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Solve {
    pub sender: Bytes32Array,
    pub proof: Bytes256,
    pub puzzle_id: Bytes32Array,
    pub nonce: u64,
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32Array,
}

// Add validation methods using kala-common
impl Send {
    pub fn validate(&self) -> KalaResult<()> {
        if self.signature.len() != 64 {
            return Err(KalaError::validation(format!(
                "Invalid signature size: expected 64, got {}",
                self.signature.len()
            )));
        }
        Ok(())
    }
}

impl Solve {
    pub fn validate(&self) -> KalaResult<()> {
        if self.signature.len() != 64 {
            return Err(KalaError::validation(format!(
                "Invalid signature size: expected 64, got {}",
                self.signature.len()
            )));
        }
        if self.proof.len() != 256 {
            return Err(KalaError::validation(format!(
                "Invalid proof size: expected 256, got {}",
                self.proof.len()
            )));
        }
        Ok(())
    }
}

// Transaction enum
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Transaction {
    Send(Send),
    Mint(Mint),
    Stake(Stake),
    Solve(Solve),
}

// Metadata for timestamping using kala-common types
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TransactionMetadata {
    pub timestamp: Timestamp,
    pub tick: BlockHeight,
    pub iteration: IterationNumber,
}

// Encrypted transaction wrapper
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SealedTransaction {
    pub nonce: Nonce96Array,
    pub tag: Tag128Array,
    pub ciphertext: Vec<u8>,
}

// Timelock transaction for MEV protection
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TimelockTransaction {
    pub encrypted_data: SealedTransaction,
    pub puzzle: RSWPuzzle,
    pub submission_iteration: IterationNumber,
    pub target_tick: BlockHeight,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RSWPuzzle {
    pub puzzle_value: Vec<u8>,
    pub a: Vec<u8>,
    pub n: Vec<u8>,
    pub hardness: u32,
}

// Use constants from kala-common instead of duplicating
pub use kala_common::types::sizes::{AES_KEY_SIZE, NONCE_SIZE, TAG_SIZE};
pub const EMPTY64BYTES: [u8; 64] = [0u8; 64];

// Implement KalaSerialize for all transaction types
impl KalaSerialize for Send {
    fn preferred_encoding() -> EncodingType {
        EncodingType::FlatBuffers // Efficient for frequent serialization
    }
}

impl KalaSerialize for Mint {
    fn preferred_encoding() -> EncodingType {
        EncodingType::FlatBuffers
    }
}

impl KalaSerialize for Stake {
    fn preferred_encoding() -> EncodingType {
        EncodingType::FlatBuffers
    }
}

impl KalaSerialize for Solve {
    fn preferred_encoding() -> EncodingType {
        EncodingType::FlatBuffers
    }
}

impl KalaSerialize for Transaction {
    fn preferred_encoding() -> EncodingType {
        EncodingType::FlatBuffers
    }
}

impl KalaSerialize for TransactionMetadata {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact for metadata
    }
}

impl KalaSerialize for SealedTransaction {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact for encrypted data
    }
}

impl KalaSerialize for TimelockTransaction {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact for network transmission
    }
}

impl KalaSerialize for RSWPuzzle {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact for puzzle data
    }
}
