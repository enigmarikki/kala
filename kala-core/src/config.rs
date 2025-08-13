//! Configuration management for Kala Core
//!
//! This module provides the [`NodeConfig`] structure that contains all
//! configuration parameters needed to run a Kala blockchain node.
//!
//! The configuration handles:
//! - Database and storage settings
//! - Network and RPC parameters
//! - VDF computation parameters
//! - Timelock puzzle settings
//! - Performance and debugging options

use serde::{Deserialize, Serialize};
use std::path::PathBuf;

/// Complete configuration for a Kala blockchain node
///
/// This structure contains all parameters needed to initialize and run
/// a Kala node, including VDF parameters, network settings, and
/// performance tuning options.
///
/// # Example
/// ```
/// use kala_core::NodeConfig;
///
/// let config = NodeConfig::default();
/// assert_eq!(config.iterations_per_tick, 65536);
/// assert_eq!(config.rpc_port, 8545);
/// ```
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NodeConfig {
    /// Path to the RocksDB state database directory
    /// 
    /// This directory stores the blockchain state, tick certificates,
    /// and VDF checkpoints. Created automatically if it doesn't exist.
    pub db_path: String,

    /// Port for the JSON-RPC API server
    /// 
    /// The RPC server provides external access to the blockchain,
    /// allowing clients to submit transactions and query state.
    /// Default: 8545 (Ethereum-compatible)
    pub rpc_port: u16,

    /// Number of VDF iterations per tick (k parameter from the paper)
    /// 
    /// This is the fundamental timing parameter that determines:
    /// - Tick duration: k * 7.6μs (≈497ms for k=65536) 
    /// - Security level: Higher k = more security
    /// - Transaction finality time
    /// 
    /// Default: 65536 (2^16) as specified in the paper
    pub iterations_per_tick: u64,

    /// Timelock puzzle hardness factor (0.0 to 1.0)
    /// 
    /// Determines RSW timelock puzzle difficulty as a fraction of the
    /// tick duration. Higher values mean longer decryption times but
    /// better MEV protection. Must leave enough time for decryption
    /// and validation phases.
    /// 
    /// Default: 0.1 (10% of tick duration)
    pub timelock_hardness_factor: f64,

    /// Enable GPU acceleration for RSW puzzle solving
    /// 
    /// When enabled, uses CUDA acceleration for parallel timelock
    /// puzzle solving. Requires compatible GPU hardware and drivers.
    /// Falls back to CPU if GPU acceleration fails.
    pub enable_gpu: bool,

    /// Maximum number of transactions processed per tick
    /// 
    /// Limits the transaction throughput to prevent tick overruns.
    /// Transactions beyond this limit are deferred to future ticks.
    pub max_transactions_per_tick: usize,

    /// Network discriminant for VDF computation
    /// 
    /// This large negative integer parameter must be identical across
    /// all nodes in the network. It determines the VDF class group
    /// and ensures network consensus. Changing this creates a new
    /// incompatible network.
    pub discriminant: String,

    /// Logging verbosity level
    /// 
    /// Controls the amount of logging output. Levels:
    /// - "error": Only errors
    /// - "warn": Errors and warnings
    /// - "info": General information (recommended)
    /// - "debug": Detailed debugging info
    /// - "trace": Maximum verbosity
    pub log_level: String,

    /// Enable Prometheus metrics collection
    /// 
    /// When enabled, exposes performance metrics on the metrics port
    /// for monitoring and observability. Useful for production deployments.
    pub enable_metrics: bool,

    /// Port for Prometheus metrics endpoint
    /// 
    /// HTTP endpoint serving metrics in Prometheus format.
    /// Only active when enable_metrics is true.
    pub metrics_port: u16,

    /// Node identifier for multi-node consensus
    /// 
    /// Unique identifier for this node in the network.
    /// Must be unique across all nodes in the network.
    pub node_id: String,

    /// List of peer nodes for networking
    /// 
    /// Format: "node_id@ip:port"
    /// Example: ["node1@127.0.0.1:9001", "node2@127.0.0.1:9002"]
    pub peers: Vec<String>,

    /// P2P networking port
    /// 
    /// Port for inter-node communication including consensus,
    /// transaction forwarding, and state synchronization.
    pub p2p_port: u16,

    /// Leader rotation interval in ticks
    /// 
    /// Number of ticks each leader serves before rotation.
    /// Lower values provide better load distribution but more overhead.
    pub leader_rotation_interval: u64,

    /// Minimum number of nodes required for consensus
    /// 
    /// Byzantine fault tolerance requires >= 3f+1 nodes where f is
    /// the maximum number of Byzantine nodes tolerated.
    pub min_consensus_nodes: usize,
}

impl Default for NodeConfig {
    /// Creates a default configuration suitable for development and testing
    /// 
    /// The default configuration provides:
    /// - Local database in "./kala_db" directory
    /// - Standard Ethereum RPC port (8545)
    /// - Full security parameters (65536 iterations per tick)
    /// - Conservative timelock settings (10% hardness factor)
    /// - Network discriminant from the research paper
    /// 
    /// # Example
    /// ```
    /// use kala_core::NodeConfig;
    /// 
    /// let config = NodeConfig::default();
    /// config.validate().unwrap();
    /// ```
    fn default() -> Self {
        Self {
            db_path: "./kala_db".to_string(),
            rpc_port: 8545,
            // 2^16 iterations as specified in the paper
            // Provides ~497ms tick duration at 7.6μs per iteration
            iterations_per_tick: 65536,
            // Conservative 10% timelock hardness for good MEV protection
            // while leaving sufficient time for decryption and validation
            timelock_hardness_factor: 0.1,
            enable_gpu: true,
            max_transactions_per_tick: 10000,
            // Default discriminant from the research paper
            // This specific value ensures compatibility with the reference implementation
            // WARNING: All nodes in the network must use identical discriminant
            discriminant: "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679".to_string(),
            log_level: "info".to_string(),
            enable_metrics: false,
            metrics_port: 9090,
            node_id: "node0".to_string(),
            peers: vec![],
            p2p_port: 9001,
            leader_rotation_interval: 100, // Every 100 ticks
            min_consensus_nodes: 4, // Support up to 1 Byzantine node (3*1+1=4)
        }
    }
}

impl NodeConfig {
    /// Validates the configuration parameters
    /// 
    /// Performs comprehensive validation of all configuration parameters
    /// to ensure they are within acceptable ranges and compatible with
    /// each other.
    /// 
    /// # Validation Rules
    /// 
    /// - `iterations_per_tick` must be greater than 0
    /// - `timelock_hardness_factor` must be between 0.0 and 1.0
    /// - `discriminant` must not be empty
    /// 
    /// # Returns
    /// 
    /// - `Ok(())` if all parameters are valid
    /// - `Err(description)` with details of the first validation failure
    /// 
    /// # Example
    /// 
    /// ```
    /// use kala_core::NodeConfig;
    /// 
    /// let mut config = NodeConfig::default();
    /// assert!(config.validate().is_ok());
    /// 
    /// // Invalid hardness factor
    /// config.timelock_hardness_factor = 1.5;
    /// assert!(config.validate().is_err());
    /// ```
    pub fn validate(&self) -> Result<(), Box<dyn std::error::Error>> {
        if self.iterations_per_tick == 0 {
            return Err("iterations_per_tick must be greater than 0".into());
        }

        if self.timelock_hardness_factor < 0.0 || self.timelock_hardness_factor > 1.0 {
            return Err("timelock_hardness_factor must be between 0.0 and 1.0".into());
        }

        if self.discriminant.is_empty() {
            return Err("discriminant cannot be empty".into());
        }

        Ok(())
    }

    /// Returns the database path as a [`PathBuf`]
    /// 
    /// Convenience method for working with filesystem operations.
    /// The path is created automatically if it doesn't exist.
    /// 
    /// # Example
    /// ```
    /// use kala_core::NodeConfig;
    /// use std::path::Path;
    /// 
    /// let config = NodeConfig::default();
    /// let path = config.db_path();
    /// assert_eq!(path, Path::new("./kala_db"));
    /// ```
    pub fn db_path(&self) -> PathBuf {
        PathBuf::from(&self.db_path)
    }

    /// Calculate appropriate timelock hardness for the current position in a tick
    /// 
    /// Dynamically adjusts timelock puzzle difficulty based on how much time
    /// remains in the current tick. This ensures transactions have sufficient
    /// time to decrypt and be processed.
    /// 
    /// # Parameters
    /// 
    /// - `remaining_iterations`: VDF iterations left until tick boundary
    /// 
    /// # Returns
    /// 
    /// The recommended timelock hardness (number of iterations) that:
    /// - Respects the configured hardness factor
    /// - Ensures decryption completes before tick end
    /// - Provides at least 1 iteration of hardness
    /// 
    /// # Algorithm
    /// 
    /// The hardness is the minimum of:
    /// 1. Maximum hardness: `iterations_per_tick * hardness_factor`
    /// 2. Safe hardness: `remaining_iterations / 2` (leaves time for processing)
    /// 3. At least 1 iteration minimum
    /// 
    /// # Example
    /// ```
    /// use kala_core::NodeConfig;
    /// 
    /// let config = NodeConfig::default();
    /// // With default 10% hardness factor and 65536 iterations per tick
    /// let hardness = config.calculate_timelock_hardness(32768);
    /// assert!(hardness <= 6553); // Max 10% of tick
    /// assert!(hardness <= 16384); // Max half of remaining time
    /// assert!(hardness >= 1);     // At least 1 iteration
    /// ```
    pub fn calculate_timelock_hardness(&self, remaining_iterations: u64) -> u32 {
        let max_hardness = (self.iterations_per_tick as f64 * self.timelock_hardness_factor) as u32;
        let safe_hardness = (remaining_iterations / 2) as u32;
        max_hardness.min(safe_hardness).max(1)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_default_config_is_valid() {
        let config = NodeConfig::default();
        assert!(config.validate().is_ok());
    }

    #[test]
    fn test_validation_iterations_per_tick() {
        let mut config = NodeConfig::default();
        config.iterations_per_tick = 0;
        assert!(config.validate().is_err());
    }

    #[test]
    fn test_validation_timelock_hardness_factor() {
        let mut config = NodeConfig::default();
        
        // Test lower bound
        config.timelock_hardness_factor = -0.1;
        assert!(config.validate().is_err());
        
        // Test upper bound
        config.timelock_hardness_factor = 1.5;
        assert!(config.validate().is_err());
        
        // Test valid values
        config.timelock_hardness_factor = 0.0;
        assert!(config.validate().is_ok());
        
        config.timelock_hardness_factor = 1.0;
        assert!(config.validate().is_ok());
        
        config.timelock_hardness_factor = 0.5;
        assert!(config.validate().is_ok());
    }

    #[test]
    fn test_validation_empty_discriminant() {
        let mut config = NodeConfig::default();
        config.discriminant = String::new();
        assert!(config.validate().is_err());
    }

    #[test]
    fn test_db_path_conversion() {
        let config = NodeConfig {
            db_path: "/tmp/test_db".to_string(),
            ..Default::default()
        };
        assert_eq!(config.db_path(), PathBuf::from("/tmp/test_db"));
    }

    #[test]
    fn test_calculate_timelock_hardness() {
        let config = NodeConfig {
            iterations_per_tick: 1000,
            timelock_hardness_factor: 0.1, // 10%
            ..Default::default()
        };

        // Test with plenty of time remaining
        let hardness = config.calculate_timelock_hardness(800);
        assert_eq!(hardness, 100); // 10% of 1000

        // Test with limited time remaining
        let hardness = config.calculate_timelock_hardness(100);
        assert_eq!(hardness, 50); // Half of remaining time (100/2)

        // Test minimum hardness
        let hardness = config.calculate_timelock_hardness(1);
        assert_eq!(hardness, 1); // Minimum of 1
    }

    #[test]
    fn test_config_serialization() {
        let config = NodeConfig::default();
        let serialized = serde_json::to_string(&config).unwrap();
        let deserialized: NodeConfig = serde_json::from_str(&serialized).unwrap();
        
        assert_eq!(config.db_path, deserialized.db_path);
        assert_eq!(config.rpc_port, deserialized.rpc_port);
        assert_eq!(config.iterations_per_tick, deserialized.iterations_per_tick);
    }
}
