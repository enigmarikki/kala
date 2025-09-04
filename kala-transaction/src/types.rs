//kala-transaction/src/types.rs
use kala_common::{
    error::{KalaError, KalaResult},
    types::{Hash, IterationNumber, PublicKey, Signature, TickNumber, Timestamp},
};
use serde::{Deserialize, Serialize};
use serde_with::{serde_as, Bytes};
pub type Bytes32 = [u8; 32];
pub type Bytes64 = [u8; 64];
pub type Bytes256 = [u8; 256];
pub type Tag128 = [u8; 16];
pub type Nonce96 = [u8; 12];
// Transaction structs
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Send {
    pub sender: Bytes32,
    pub receiver: Bytes32,
    pub denom: Bytes32,
    pub amount: u64,
    pub nonce: u64,
    #[serde_as(as = "Bytes")]
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32,
}
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Mint {
    pub sender: Bytes32,
    pub amount: u64,
    pub denom: Bytes32,
    pub nonce: u64,
    #[serde_as(as = "Bytes")]
    pub signature: Bytes64, // As Vec<u8>
    pub gas_sponsorer: Bytes32,
}
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Burn {
    pub sender: Bytes32,
    pub amount: u64,
    pub denom: Bytes32,
    pub nonce: u64,

    #[serde_as(as = "Bytes")]
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32,
}

#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Stake {
    pub delegator: Bytes32,
    pub witness: Bytes32,
    pub amount: u64,
    pub nonce: u64,
    #[serde_as(as = "Bytes")]
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32,
}
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Unstake {
    pub delegator: Bytes32,
    pub witness: Bytes32,
    pub amount: u64,
    pub nonce: u64,
    #[serde_as(as = "Bytes")]
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32,
}
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Solve {
    pub sender: Bytes32,
    #[serde_as(as = "Bytes")]
    pub proof: Bytes256,
    pub puzzle_id: Bytes32,
    pub nonce: u64,
    #[serde_as(as = "Bytes")]
    pub signature: Bytes64,
    pub gas_sponsorer: Bytes32,
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
    Burn(Burn),
    Stake(Stake),
    Unstake(Unstake),
    Solve(Solve),
}

// Metadata for timestamping using kala-common types
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TransactionMetadata {
    pub timestamp: Timestamp,
    pub tick: TickNumber,
    pub iteration: IterationNumber,
}

// Encrypted transaction wrapper
#[serde_as]
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SealedTransaction {
    #[serde_as(as = "Bytes")]
    pub nonce: Nonce96,
    #[serde_as(as = "Bytes")]
    pub tag: Tag128,
    pub ciphertext: Vec<u8>,
}

// Timelock transaction for MEV protection
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TimelockTransaction {
    pub encrypted_data: SealedTransaction,
    pub puzzle: RSWPuzzle,
    pub submission_iteration: IterationNumber,
    pub target_tick: TickNumber,
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
