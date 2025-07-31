// lib.rs

pub mod types;
pub mod encrypted;
pub mod decrypted;

// Re-export the generated module
#[allow(non_snake_case)]
#[allow(unused)]
pub mod generated;

pub use types::*;
pub use encrypted::*;
pub use decrypted::*;

use sha2::{Sha256, Digest};

/// Compute transaction hash
pub fn hash_transaction(data: &[u8]) -> [u8; 32] {
    Sha256::digest(data).into()
}

pub mod prelude {
    pub use crate::types::*;
    pub use crate::encrypted::{encrypt_transaction, decrypt_transaction};
    pub use crate::decrypted::{transaction_to_flatbuffer, flatbuffer_to_transaction};
}