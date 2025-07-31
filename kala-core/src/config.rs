// config.rs - Configuration for kala-core
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NodeConfig {
    /// Path to the state database
    pub db_path: String,

    /// RPC server port
    pub rpc_port: u16,

    /// Number of VDF iterations per tick (k)
    pub iterations_per_tick: u64,

    /// Target duration for each tick in milliseconds
    pub tick_duration_ms: u64,

    /// Timelock hardness factor (0.0 to 1.0)
    /// Determines RSW puzzle difficulty as fraction of tick
    pub timelock_hardness_factor: f64,

    /// Enable GPU acceleration for RSW puzzle solving
    pub enable_gpu: bool,

    /// Maximum transactions per tick
    pub max_transactions_per_tick: usize,

    /// Network discriminant for VDF (must match across all nodes)
    pub discriminant: String,

    /// Log level (trace, debug, info, warn, error)
    pub log_level: String,

    /// Enable metrics collection
    pub enable_metrics: bool,

    /// Metrics port
    pub metrics_port: u16,
}

impl Default for NodeConfig {
    fn default() -> Self {
        Self {
            db_path: "./kala_db".to_string(),
            rpc_port: 8545,
            iterations_per_tick: 65536, // 2^16 as per paper
            tick_duration_ms: 497,       // ~497.7ms as measured in paper
            timelock_hardness_factor: 0.1,
            enable_gpu: true,
            max_transactions_per_tick: 10000,
            // Default discriminant from the paper - all nodes must use the same
            discriminant: "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679".to_string(),
            log_level: "info".to_string(),
            enable_metrics: false,
            metrics_port: 9090,
        }
    }
}

impl NodeConfig {
    /// Validate configuration
    pub fn validate(&self) -> Result<(), Box<dyn std::error::Error>> {
        if self.iterations_per_tick == 0 {
            return Err("iterations_per_tick must be greater than 0".into());
        }

        if self.tick_duration_ms == 0 {
            return Err("tick_duration_ms must be greater than 0".into());
        }

        if self.timelock_hardness_factor < 0.0 || self.timelock_hardness_factor > 1.0 {
            return Err("timelock_hardness_factor must be between 0.0 and 1.0".into());
        }

        if self.discriminant.is_empty() {
            return Err("discriminant cannot be empty".into());
        }

        Ok(())
    }

    /// Get the database path as PathBuf
    pub fn db_path(&self) -> PathBuf {
        PathBuf::from(&self.db_path)
    }

    /// Calculate timelock hardness for current tick position
    pub fn calculate_timelock_hardness(&self, remaining_iterations: u64) -> u32 {
        let max_hardness = (self.iterations_per_tick as f64 * self.timelock_hardness_factor) as u32;
        let safe_hardness = (remaining_iterations / 2) as u32;
        max_hardness.min(safe_hardness).max(1)
    }
}
