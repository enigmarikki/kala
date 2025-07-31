// lib.rs

pub mod decrypted;
pub mod encrypted;
pub mod types;

// Re-export the generated module
#[allow(non_snake_case)]
#[allow(unused)]
pub mod generated;

pub use decrypted::*;
pub use encrypted::*;
pub use types::*;

use sha2::{Digest, Sha256};

/// Compute transaction hash
pub fn hash_transaction(data: &[u8]) -> [u8; 32] {
    Sha256::digest(data).into()
}

pub mod prelude {
    pub use crate::decrypted::{flatbuffer_to_transaction, transaction_to_flatbuffer};
    pub use crate::encrypted::{decrypt_transaction, encrypt_transaction};
    pub use crate::types::*;
}
