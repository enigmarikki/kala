//! Common type definitions and constants used throughout Kala

use serde::{Deserialize, Serialize};

/// Node identifier - 32-byte public key hash
pub type NodeId = [u8; 32];

/// Timestamp in seconds since Unix epoch
pub type Timestamp = u64;

/// Block height/tick number
pub type BlockHeight = u64;

/// VDF iteration number
pub type IterationNumber = u64;

/// Hash type - 32-byte SHA-256
pub type Hash = [u8; 32];

/// Public key - 32-byte
pub type PublicKey = [u8; 32];

/// Signature - 64-byte
pub type Signature = [u8; 64];

/// Cryptographic sizes
pub mod sizes {
    /// Hash size in bytes (SHA-256)
    pub const HASH_SIZE: usize = 32;

    /// Public key size in bytes
    pub const PUBKEY_SIZE: usize = 32;

    /// Signature size in bytes
    pub const SIGNATURE_SIZE: usize = 64;

    /// AES key size in bytes
    pub const AES_KEY_SIZE: usize = 32;

    /// AES nonce size in bytes
    pub const NONCE_SIZE: usize = 12;

    /// AES tag size in bytes  
    pub const TAG_SIZE: usize = 16;
}

/// Network protocol constants
pub mod network {
    use std::time::Duration;

    /// Maximum message size (16MB)
    pub const MAX_MESSAGE_SIZE: usize = 16 * 1024 * 1024;

    /// Default connection timeout
    pub const DEFAULT_CONNECTION_TIMEOUT: Duration = Duration::from_secs(30);

    /// Default keepalive interval
    pub const DEFAULT_KEEPALIVE_INTERVAL: Duration = Duration::from_secs(60);

    /// Default message buffer size
    pub const DEFAULT_MESSAGE_BUFFER_SIZE: usize = 1000;
}

/// VDF and consensus constants
pub mod consensus {
    /// Default iterations per tick (k = 2^16)
    pub const DEFAULT_ITERATIONS_PER_TICK: u64 = 65536;

    /// VDF discriminant from the paper
    pub const DEFAULT_DISCRIMINANT: &str = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";

    /// Tick phases
    /// TODO: Profile this properly
    pub const COLLECTION_PHASE_RATIO: f64 = 1.0 / 3.0; // k/3
    pub const CONSENSUS_PHASE_RATIO: f64 = 2.0 / 3.0; // 2k/3
    pub const FINALIZATION_PHASE_RATIO: f64 = 1.0; // k
}

/// Database constants
pub mod database {
    /// Key prefixes for different data types
    pub const CHAIN_STATE_KEY: &[u8] = b"chain_state";
    pub const TICK_PREFIX: &str = "tick";
    pub const VDF_TICK_PREFIX: &str = "vdf_tick";
    pub const ACCOUNT_PREFIX: &str = "account";
    pub const TRANSACTION_PREFIX: &str = "tx";
    pub const BLOCK_INDEX_KEY: &[u8] = b"tick_index";
}

/// Configuration defaults
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KalaDefaults {
    pub iterations_per_tick: u64,
    pub max_peers: usize,
    pub rpc_port: u16,
    pub network_port: u16,
}

impl Default for KalaDefaults {
    fn default() -> Self {
        Self {
            iterations_per_tick: consensus::DEFAULT_ITERATIONS_PER_TICK,
            max_peers: 100,
            rpc_port: 8545,
            network_port: 8080,
        }
    }
}

/// Version information
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VersionInfo {
    pub version: String,
    pub protocol_version: u32,
    pub build_time: String,
    pub git_commit: Option<String>,
}

impl VersionInfo {
    pub fn current() -> Self {
        Self {
            version: env!("CARGO_PKG_VERSION").to_string(),
            protocol_version: crate::PROTOCOL_VERSION,
            build_time: std::env::var("BUILD_TIME").unwrap_or_else(|_| "unknown".to_string()),
            git_commit: option_env!("GIT_COMMIT").map(|s| s.to_string()),
        }
    }
}

/// Utility functions for common operations using extension traits
pub trait HashExt {
    /// Create a zero hash
    fn zero() -> Self;
    /// Check if hash is zero
    fn is_zero(&self) -> bool;
}

impl HashExt for Hash {
    fn zero() -> Self {
        [0u8; 32]
    }

    fn is_zero(&self) -> bool {
        *self == [0u8; 32]
    }
}

pub trait PublicKeyExt {
    /// Create a zero public key
    fn zero() -> Self;
    /// Check if public key is zero
    fn is_zero(&self) -> bool;
}

impl PublicKeyExt for PublicKey {
    fn zero() -> Self {
        [0u8; 32]
    }

    fn is_zero(&self) -> bool {
        *self == [0u8; 32]
    }
}

pub trait SignatureExt {
    /// Create a zero signature
    fn zero() -> Self;
    /// Check if signature is zero
    fn is_zero(&self) -> bool;
}

impl SignatureExt for Signature {
    fn zero() -> Self {
        [0u8; 64]
    }

    fn is_zero(&self) -> bool {
        *self == [0u8; 64]
    }
}
