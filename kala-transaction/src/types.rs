use thiserror::Error;
use serde::{Serialize, Deserialize};

#[derive(Error, Debug)]
pub enum TransactionError {
    #[error("Invalid byte array size: expected {expected}, got {actual}")]
    InvalidSize { expected: usize, actual: usize },
    
    #[error("Serialization error: {0}")]
    SerializationError(String),
    
    #[error("Encryption error: {0}")]
    EncryptionError(String),
    
    #[error("Decryption error: {0}")]
    DecryptionError(String),
    
    #[error("Invalid transaction format: {0}")]
    InvalidFormat(String),
    
    #[error("Flatbuffer error: {0}")]
    FlatbufferError(String),
}

pub type Result<T> = std::result::Result<T, TransactionError>;

pub use crate::generated::tx::{Bytes32, Bytes128, Nonce96, Tag128};

// Helper type aliases
pub type Bytes32Array = [u8; 32];
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
    pub signature: Bytes64,  // Now a Vec<u8>
    pub gas_sponsorer: Bytes32Array,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Mint {
    pub sender: Bytes32Array,
    pub amount: u64,
    pub denom: Bytes32Array,
    pub nonce: u64,
    pub signature: Bytes64,  // As Vec<u8>
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

// Add validation methods
impl Send {
    pub fn validate(&self) -> Result<()> {
        if self.signature.len() != 64 {
            return Err(TransactionError::InvalidSize { expected: 64, actual: self.signature.len() });
        }
        Ok(())
    }
}

impl Solve {
    pub fn validate(&self) -> Result<()> {
        if self.signature.len() != 64 {
            return Err(TransactionError::InvalidSize { expected: 64, actual: self.signature.len() });
        }
        if self.proof.len() != 256 {
            return Err(TransactionError::InvalidSize { expected: 256, actual: self.proof.len() });
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

// Metadata for timestamping
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TransactionMetadata {
    pub timestamp: u64,
    pub tick: u64,
    pub iteration: u64,
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
    pub submission_iteration: u64,
    pub target_tick: u64,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RSWPuzzle {
    pub puzzle_value: Vec<u8>,
    pub a: Vec<u8>,
    pub n: Vec<u8>,
    pub hardness: u32,
}

// Constants
pub const AES_KEY_SIZE: usize = 32;
pub const TAG_SIZE: usize = 16;
pub const NONCE_SIZE: usize = 12;
pub const EMPTY64BYTES: [u8; 64] = [0u8; 64];