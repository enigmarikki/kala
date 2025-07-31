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

/// Configuration module
pub mod config;

/// Consensus implementation
pub mod consensus;

/// Node implementation
pub mod node;

/// Prelude with commonly used types
pub mod prelude {
    pub use crate::config::NodeConfig;
    pub use crate::consensus::TickProcessor;
    pub use crate::node::KalaNode;
}

// Re-export main types at crate root
pub use config::NodeConfig;
pub use consensus::TickProcessor;
pub use node::KalaNode;

/// Kala version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Default network discriminant (from the paper)
pub const DEFAULT_DISCRIMINANT: &str = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";

/// Default iterations per tick (k = 2^16)
pub const DEFAULT_ITERATIONS_PER_TICK: u64 = 65536;

/// Default tick duration in milliseconds (~497.7ms as measured) this field is redundant
pub const DEFAULT_TICK_DURATION_MS: u64 = 497;

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
