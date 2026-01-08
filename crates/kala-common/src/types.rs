//kala-common/src/types.rs
//! Common type definitions and constants used throughout Kala

use serde::{Deserialize, Serialize};

/// Node identifier - 32-byte public key hash
pub type NodeId = [u8; 32];

/// Timestamp in seconds since Unix epoch
pub type Timestamp = u128;

/// Tick number
pub type TickNumber = u128;

/// VDF iteration number
pub type IterationNumber = u128;

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
pub mod network_params {
    /// Number of VDF iterations per tick
    pub const K_ITERATIONS: u64 = 163840;
    /// Default class group discriminant for VDF
    pub const DEFAULT_DISCRIMINANT: &str = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";
    /// Iteration number when collection phase ends
    pub const COLLECTION_PHASE_END: u64 = 43690;
    /// Iteration number when consensus phase ends
    pub const CONSENSUS_PHASE_END: u64 = 65536;
    /// RSW timelock hardness constant
    pub const RSW_HARDNESS_CONSTANT: u64 = 65536;
    /// Byzantine fault tolerance threshold denominator (1/3)
    pub const BYZANTINE_THRESHOLD_DENOMINATOR: usize = 3;
}

/// Configuration defaults
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KalaDefaults {
    /// Number of VDF iterations per tick
    pub iterations_per_tick: u64,
    /// Maximum number of peer connections
    pub max_peers: usize,
    /// RPC server port
    pub rpc_port: u16,
    /// P2P network port
    pub network_port: u16,
}

/// Version information
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VersionInfo {
    /// Semantic version string
    pub version: String,
    /// Protocol version number
    pub protocol_version: u32,
    /// Build timestamp
    pub build_time: String,
    /// Git commit hash if available
    pub git_commit: Option<String>,
}

impl VersionInfo {
    /// Get current version information
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
macro_rules! impl_byte_array_ext {
    ($name:ident, $len:expr, $doc:expr) => {
        #[doc = $doc]
        pub trait $name {
            /// Create an array filled with zeros
            fn zero() -> Self;
            /// Check if every byte in the array is zero
            fn is_zero(&self) -> bool;
        }

        impl $name for [u8; $len] {
            fn zero() -> Self {
                [0u8; $len]
            }

            fn is_zero(&self) -> bool {
                self.iter().all(|&b| b == 0)
            }
        }
    };
}

impl_byte_array_ext!(HashExt, 32, "Extension trait for 32-byte hash arrays");
impl_byte_array_ext!(
    PublicKeyExt,
    32,
    "Extension trait for 32-byte public key arrays"
);
impl_byte_array_ext!(
    SignatureExt,
    64,
    "Extension trait for 64-byte signature arrays"
);
