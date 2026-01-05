//! # Kala Common
//!
//! Common utilities, traits, and standardized patterns for the Kala blockchain.
//! This crate serves as the single source of truth for all shared functionality
//! across the Kala ecosystem, preventing code duplication and circular dependencies.
//!
//! ## Modules
//!
//! - **serialization**: Standardized data encoding/decoding patterns
//! - **network**: Network layer abstractions and messaging
//! - **crypto**: Cryptographic utilities and hash operations  
//! - **database**: Database operation patterns
//! - **validation**: Input validation utilities
//! - **types**: Common type definitions and constants
//!
//! ## Example Usage
//!
//! ```rust
//! use kala_common::prelude::*;
//!
//! #[derive(Serialize, Deserialize)]
//! struct MyData {
//!     id: u64,
//!     name: String,
//! }
//!
//! impl KalaSerialize for MyData {
//!     fn preferred_encoding() -> EncodingType {
//!         EncodingType::Bincode
//!     }
//! }
//!
//! // Use standardized serialization
//! let data = MyData { id: 1, name: "test".to_string() };
//! let encoded = data.encode()?;
//! let decoded = MyData::decode(&encoded)?;
//! ```

#![warn(missing_docs)]
#![warn(rustdoc::missing_crate_level_docs)]

pub mod crypto;
pub mod database;
pub mod error;
pub mod types;
pub mod validation;

/// Re-export commonly used types and traits
pub mod prelude {
    pub use crate::crypto::{CryptoUtils, HASH_SIZE, PUBKEY_SIZE, SIGNATURE_SIZE};
    pub use crate::database::{DatabaseOps, KalaDatabase};
    pub use crate::error::{KalaError, KalaResult};
    pub use crate::types::{
        HashExt, IterationNumber, NodeId, PublicKeyExt, SignatureExt, TickNumber, Timestamp,
    };
    pub use crate::validation::ValidationUtils;

    // Re-export essential external crates
    pub use anyhow::Result;
}

// Version and constants
/// Kala Common crate version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Protocol version for network compatibility
pub const PROTOCOL_VERSION: u32 = 1;
