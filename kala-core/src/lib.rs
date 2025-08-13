// lib.rs - Kala Core Library
//! # Kala Core
//!
//! The core implementation of Kala: The Immutability of Time.
//!
//! This crate provides the fundamental components for running a Kala node,
//! including the eternal VDF computation, consensus mechanism, and timelock
//! transaction processing.
//!
//! ## Architecture
//!
//! - **Eternal VDF**: Continuous computation creating an unstoppable timeline
//! - **Tick-based Consensus**: Fixed epochs of 65,536 iterations
//! - **RSW Timelock**: MEV protection through temporal encryption
//! - **Single Node**: Simplified implementation for demonstration
//!
//! ## Example
//!
//! ```no_run
//! use kala_core::{NodeConfig, KalaNode};
//! use std::sync::Arc;
//!
//! #[tokio::main]
//! async fn main() -> Result<(), Box<dyn std::error::Error>> {
//!     // Create node with default config
//!     let config = NodeConfig::default();
//!     let node = Arc::new(KalaNode::new(config)?);
//!     
//!     // Run the eternal timeline
//!     node.run().await?;
//!     Ok(())
//! }
//! ```

#![warn(missing_docs)]
#![warn(rustdoc::missing_crate_level_docs)]

// Import kala-common for shared functionality
use kala_common;

/// Configuration module
pub mod config;

/// Consensus implementation
pub mod consensus;

/// Multi-node Byzantine consensus
pub mod consensus_multi;

/// P2P Networking
pub mod network;

/// Node implementation
pub mod node;

// Serialization and networking now provided by kala-common

/// Prelude with commonly used types
pub mod prelude {
    pub use crate::config::NodeConfig;
    pub use crate::consensus::TickProcessor;
    pub use crate::node::KalaNode;
    // Re-export kala-common prelude
    pub use kala_common::prelude::*;
}

// Re-export main types at crate root
pub use config::NodeConfig;
pub use consensus::TickProcessor;
pub use node::KalaNode;

/// Kala version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

// Constants now provided by kala-common
pub use kala_common::types::consensus::{DEFAULT_DISCRIMINANT, DEFAULT_ITERATIONS_PER_TICK, DEFAULT_TICK_DURATION_MS};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_constants() {
        assert_eq!(DEFAULT_ITERATIONS_PER_TICK, 65536);
        assert_eq!(DEFAULT_TICK_DURATION_MS, 497);
        assert!(!DEFAULT_DISCRIMINANT.is_empty());
    }
}
