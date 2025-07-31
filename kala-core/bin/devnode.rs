// bin/devnode.rs - Kala development node
use anyhow::Result;
use clap::Parser;
use kala_core::{KalaNode, NodeConfig};
use std::sync::Arc;

#[derive(Parser, Debug)]
#[command(name = "kala-devnode")]
#[command(about = "Kala development node - the eternal timeline", long_about = None)]
struct Args {
    /// Database path
    #[arg(short, long, default_value = "./kala_dev_db")]
    db_path: String,

    /// RPC port
    #[arg(short, long, default_value = "8545")]
    rpc_port: u16,

    /// Iterations per tick (also determines tick duration)
    #[arg(short, long, default_value = "65536")]
    iterations_per_tick: u64,

    /// Use fast mode (1 second ticks, 1024 iterations)
    #[arg(short, long)]
    fast: bool,

    /// Log level
    #[arg(short, long, default_value = "info")]
    log_level: String,
}

#[tokio::main]
async fn main() -> Result<()> {
    // Parse arguments
    let args = Args::parse();

    // Initialize logging
    let filter = tracing_subscriber::EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new(&args.log_level));

    tracing_subscriber::fmt()
        .with_env_filter(filter)
        .with_target(false)
        .with_thread_ids(true)
        .with_level(true)
        .init();

    // Print banner
    println!(
        r#"
╔═══════════════════════════════════════════════════════════════╗
║      _  __     _          ____                               ║
║     | |/ /    | |        |  _ \  _____   __                  ║
║     | ' / __ _| | __ _   | | | |/ _ \ \ / /                  ║
║     |  < / _` | |/ _` |  | |_| |  __/\ V /                   ║
║     | . \ (_| | | (_| |  |____/ \___| \_/                    ║
║     |_|\_\__,_|_|\__,_|                                       ║
║                                                               ║
║     The Immutability of Time - Development Node               ║
╚═══════════════════════════════════════════════════════════════╝
    "#
    );

    // Create config
    let config = if args.fast {
        tracing::info!("Running in FAST mode - 1 second ticks");
        NodeConfig {
            db_path: args.db_path,
            rpc_port: args.rpc_port,
            tick_duration_ms: 1000,
            iterations_per_tick: 1024,
            timelock_hardness_factor: 0.05,
            enable_gpu: false,
            max_transactions_per_tick: 100,
            log_level: args.log_level,
            ..Default::default()
        }
    } else {
        // Calculate tick duration based on iterations (7.6μs per iteration as per paper)
        let tick_duration_ms = (args.iterations_per_tick as f64 * 7.6 / 1000.0) as u64;

        NodeConfig {
            db_path: args.db_path,
            rpc_port: args.rpc_port,
            tick_duration_ms,
            iterations_per_tick: args.iterations_per_tick,
            timelock_hardness_factor: 0.1,
            enable_gpu: false,
            log_level: args.log_level,
            ..Default::default()
        }
    };

    // Validate config
    config
        .validate()
        .map_err(|e| anyhow::anyhow!("Config validation failed: {}", e))?;

    // Log configuration
    tracing::info!("Starting Kala development node");
    tracing::info!("Configuration:");
    tracing::info!("  Database: {}", config.db_path);
    tracing::info!("  RPC port: {}", config.rpc_port);
    tracing::info!("  Iterations per tick: {}", config.iterations_per_tick);
    tracing::info!("  Tick duration: {}ms", config.tick_duration_ms);
    tracing::info!(
        "  Timelock hardness: {}%",
        config.timelock_hardness_factor * 100.0
    );
    tracing::info!("");

    // Create and run node
    let node = Arc::new(KalaNode::new(config)?);

    // Set up shutdown handler
    let shutdown_node = node.clone();
    tokio::spawn(async move {
        match tokio::signal::ctrl_c().await {
            Ok(()) => {
                tracing::warn!("Received shutdown signal - stopping the eternal timeline...");
                std::process::exit(0);
            }
            Err(err) => {
                tracing::error!("Unable to listen for shutdown signal: {}", err);
            }
        }
    });

    // Run the eternal timeline
    tracing::info!("\"kalo'smi loka-kshaya-krit pravriddho\"");
    tracing::info!("I am Time, the destroyer of worlds");
    tracing::info!("");
    tracing::info!("The eternal timeline begins...");
    tracing::info!("");

    node.run().await
}
