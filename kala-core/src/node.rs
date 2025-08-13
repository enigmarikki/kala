use anyhow::Result;
use sha2::{Digest, Sha256};
use std::sync::Arc;
use tokio::sync::{mpsc, Mutex, RwLock};
use tracing::{debug, error, info, warn};

use crate::config::NodeConfig;
use crate::consensus::TickProcessor;
use crate::network::{NetworkManager, NetworkChannels, NetworkMessage, LeaderState};
use kala_rpc::{
    AccountInfo, ChainInfo, GetAccountRequest, GetTickRequest, KalaApiServer,
    SubmitTransactionRequest, SubmitTransactionResponse,
};
use kala_state::{ChainState, StateDB, TickCertificate};
use kala_transaction::{EncryptionContext, TimelockTransaction};
use kala_vdf::EternalVDF;
use serde_json;

// RPC handler that communicates with the node via channels
pub struct KalaRpcHandler {
    chain_info_tx: mpsc::Sender<mpsc::Sender<ChainInfo>>,
    submit_tx: mpsc::Sender<(
        TimelockTransaction,
        mpsc::Sender<Result<SubmitTransactionResponse, String>>,
    )>,
    state_db: Arc<StateDB>,
}

// Transaction acceptance window constants
const TX_ACCEPTANCE_WINDOW_START: f64 = 0.9; // Accept txs starting at 90% of previous tick
const TX_ACCEPTANCE_WINDOW_END: f64 = 0.3; // Accept txs until 30% of target tick

#[derive(Clone)]
pub struct KalaNode {
    config: NodeConfig,
    vdf: Arc<RwLock<EternalVDF>>,
    state: Arc<RwLock<ChainState>>,
    state_db: Arc<StateDB>,
    tick_processor: Arc<TickProcessor>,
    // Transaction pool for encrypted transactions
    tx_pool: Arc<Mutex<Vec<TimelockTransaction>>>,
    // Network manager for multi-node consensus
    network_manager: Option<Arc<NetworkManager>>,
    // Network message channels
    network_channels: Option<NetworkChannels>,
}

impl KalaNode {
    pub async fn new(config: NodeConfig) -> Result<Self> {
        // Open state database
        let state_db = Arc::new(StateDB::open(&config.db_path)?);

        // Load chain state
        let chain_state = state_db.load_chain_state().await?;

        // Initialize or restore VDF from checkpoint
        let vdf = match EternalVDF::from_checkpoint(&chain_state.vdf_checkpoint) {
            Ok(vdf) => Arc::new(RwLock::new(vdf)),
            Err(e) => return Err(anyhow::anyhow!("Failed to initialize VDF: {}", e)),
        };

        // Create tick processor with proper parameters
        let tick_processor = Arc::new(TickProcessor::new(config.iterations_per_tick));

        // Initialize network manager for multi-node setup
        let (network_manager, network_channels) = if !config.peers.is_empty() {
            let (network, channels) = NetworkManager::new(
                config.node_id.clone(),
                config.p2p_port,
                config.leader_rotation_interval,
                config.min_consensus_nodes,
            );
            (Some(Arc::new(network)), Some(channels))
        } else {
            info!("Running in single-node mode - no network manager initialized");
            (None, None)
        };

        info!("Initialized Kala node - The Eternal Timeline");
        info!(
            "  - Iterations per tick (k): {}",
            config.iterations_per_tick
        );
        info!("  - Current tick: {}", chain_state.current_tick);
        info!(
            "  - VDF iteration: {}",
            chain_state.vdf_checkpoint.iteration
        );
        info!(
            "  - Last tick hash: {}",
            hex::encode(chain_state.last_tick_hash)
        );

        Ok(Self {
            config,
            vdf,
            state: Arc::new(RwLock::new(chain_state)),
            state_db,
            tick_processor,
            tx_pool: Arc::new(Mutex::new(Vec::new())),
            network_manager,
            network_channels,
        })
    }

    /// Get the encryption context for creating timelock transactions
    pub fn encryption_context(&self) -> Arc<EncryptionContext> {
        self.tick_processor.encryption_context()
    }

    /// Run the eternal VDF computation
    pub async fn run(self: Arc<Self>) -> Result<()> {
        info!("Starting Kala node - the eternal timeline begins...");
        info!("\"kalo'smi loka-kshaya-krit pravriddho\" - I am Time, the destroyer of worlds");

        // Create channels for RPC communication
        let (chain_info_tx, mut chain_info_rx) = mpsc::channel::<mpsc::Sender<ChainInfo>>(100);
        let (submit_tx, mut submit_rx) = mpsc::channel::<(
            TimelockTransaction,
            mpsc::Sender<Result<SubmitTransactionResponse, String>>,
        )>(100);

        // Create RPC handler
        let rpc_handler = KalaRpcHandler {
            chain_info_tx,
            submit_tx,
            state_db: self.state_db.clone(),
        };

        // Start network manager if configured for multi-node
        if let Some(ref network) = self.network_manager {
            info!("Starting network manager for multi-node consensus");
            if let Err(e) = network.start(self.config.peers.clone()).await {
                error!("Failed to start network manager: {}", e);
                return Err(e);
            }
        }

        // Handle network messages if in multi-node mode
        let self_clone = Arc::new(self.clone());
        if let Some(channels) = self.network_channels.as_ref() {
            // TODO: Handle network messages in separate task
            // This would need to be restructured to avoid ownership issues
            info!("Network message handling will be implemented");
        }

        // Start RPC server in separate task
        let rpc_port = self.config.rpc_port;
        tokio::spawn(async move {
            let config = kala_rpc::RpcConfig {
                listen_addr: ([127, 0, 0, 1], rpc_port).into(),
            };

            info!("Starting RPC server on port {}", rpc_port);
            if let Err(e) = kala_rpc::start_server(config, rpc_handler).await {
                error!("RPC server error: {}", e);
            }
        });

        // Handle RPC requests in separate task
        let rpc_node = self.clone();
        tokio::spawn(async move {
            loop {
                tokio::select! {
                    // Handle chain info requests
                    Some(reply_tx) = chain_info_rx.recv() => {
                        let vdf = rpc_node.vdf.read().await;
                        let state = rpc_node.state.read().await;

                        let info = ChainInfo {
                            current_tick: state.current_tick,
                            current_iteration: vdf.get_iteration(),
                            vdf_output: {
                                let (a, b, c) = vdf.get_form_values();
                                format!("({}, {}, {})", a, b, c)
                            },
                            hash_chain: hex::encode(vdf.get_hash_chain()),
                            total_transactions: state.total_transactions,
                            accounts: state.get_account_count(),
                            iterations_per_tick: rpc_node.config.iterations_per_tick,
                        };

                        let _ = reply_tx.send(info).await;
                    }

                    // Handle transaction submissions
                    Some((mut tx, reply_tx)) = submit_rx.recv() => {
                        let current_tick = rpc_node.state.read().await.current_tick;
                        let current_iter = rpc_node.vdf.read().await.get_iteration();
                        let k = rpc_node.config.iterations_per_tick;

                        // Validate transaction target tick
                        if tx.target_tick < current_tick {
                            let _ = reply_tx.send(Err(format!(
                                "Transaction target tick {} is in the past (current: {})",
                                tx.target_tick, current_tick
                            ))).await;
                            continue;
                        }

                        // Calculate acceptance window for this tick
                        let target_tick_start = tx.target_tick * k;
                        let target_tick_end = (tx.target_tick + 1) * k;
                        let acceptance_start = if tx.target_tick == 0 {
                            0
                        } else {
                            ((tx.target_tick - 1) * k) + ((k as f64 * TX_ACCEPTANCE_WINDOW_START) as u64)
                        };
                        let acceptance_end = target_tick_start + ((k as f64 * TX_ACCEPTANCE_WINDOW_END) as u64);

                        // Accept transactions that are either:
                        // 1. In the acceptance window now
                        // 2. For future ticks (will be held in pool until their window)
                        let is_in_window = current_iter >= acceptance_start && current_iter <= acceptance_end;
                        let is_future = current_iter < acceptance_start;
                        
                        if !is_in_window && !is_future {
                            // Optimistic forwarding: send to next leader instead of rejecting
                            if let Some(ref network) = rpc_node.network_manager {
                                if !network.is_leader().await {
                                    // Forward to current leader for continuous processing
                                    info!("Forwarding transaction to leader for tick {}", tx.target_tick);
                                    if let Err(e) = network.forward_transactions(vec![tx.clone()], tx.target_tick).await {
                                        warn!("Failed to forward transaction: {}", e);
                                    }
                                    let _ = reply_tx.send(Ok(SubmitTransactionResponse {
                                        tx_hash: "forwarded".to_string(),
                                        submission_iteration: tx.submission_iteration,
                                        target_tick: tx.target_tick,
                                    })).await;
                                    continue;
                                }
                            }
                            
                            // Only reject if we're past the acceptance window and can't forward
                            let _ = reply_tx.send(Err(format!(
                                "Past acceptance window for tick {} (current iter: {}, window ended at: {})",
                                tx.target_tick, current_iter, acceptance_end
                            ))).await;
                            continue;
                        }

                        // Set submission iteration to current VDF iteration
                        tx.submission_iteration = current_iter;

                        // Validate timelock parameters
                        let decrypt_iter = tx.submission_iteration + tx.puzzle.hardness as u64;
                        if decrypt_iter >= target_tick_end {
                            let _ = reply_tx.send(Err(format!(
                                "Transaction would not decrypt in time (decrypt at {} > tick end {})",
                                decrypt_iter, target_tick_end
                            ))).await;
                            continue;
                        }

                        // Ensure decryption happens after consensus phase (k/3)
                        let consensus_end = target_tick_start + k / 3;
                        if decrypt_iter < consensus_end {
                            let _ = reply_tx.send(Err(format!(
                                "Transaction would decrypt too early (decrypt at {} < consensus end {})",
                                decrypt_iter, consensus_end
                            ))).await;
                            continue;
                        }

                        // Compute transaction hash using serde_json for now
                        let tx_json = serde_json::to_string(&tx).unwrap();
                        let mut hasher = Sha256::new();
                        hasher.update(tx_json.as_bytes());
                        let tx_hash = hex::encode(hasher.finalize());

                        // Add to pool
                        rpc_node.tx_pool.lock().await.push(tx.clone());

                        info!("Accepted transaction {} for tick {} (submission: {}, decrypt: {})",
                              tx_hash, tx.target_tick, tx.submission_iteration, decrypt_iter);

                        let _ = reply_tx.send(Ok(SubmitTransactionResponse {
                            tx_hash,
                            submission_iteration: tx.submission_iteration,
                            target_tick: tx.target_tick,
                        })).await;
                    }
                }
            }
        });

        // Main eternal loop
        loop {
            let current_tick = self.state.read().await.current_tick;

            info!("┌─────────────────────────────────────────┐");
            info!("│         Starting Tick {:08}          │", current_tick);
            info!("└─────────────────────────────────────────┘");

            // Get VDF state at tick start
            let vdf_start = {
                let vdf = self.vdf.read().await;
                let iter = vdf.get_iteration();
                let hash = hex::encode(&vdf.get_hash_chain()[..8]);
                info!("VDF State: iteration={}, hash={}...", iter, hash);
                iter
            };

            // Ensure we're aligned with tick boundaries
            let expected_start = current_tick * self.config.iterations_per_tick;
            if vdf_start != expected_start {
                warn!(
                    "VDF iteration {} doesn't match expected tick start {}",
                    vdf_start, expected_start
                );
            }

            // Process the eternal tick
            match self.process_eternal_tick(current_tick).await {
                Ok(certificate) => {
                    // Store certificate in database
                    self.state_db.store_tick(&certificate).await?;

                    // Update chain state
                    let mut state = self.state.write().await;
                    state.current_tick = certificate.tick_number + 1;
                    state.last_tick_hash = certificate.tick_hash;
                    state.total_transactions += certificate.transaction_count as u64;

                    // Update VDF checkpoint in state
                    let vdf = self.vdf.read().await;
                    state.vdf_checkpoint = vdf.checkpoint();
                    let vdf_end = vdf.get_iteration();
                    drop(vdf);

                    // Persist state to database
                    self.state_db.save_chain_state(&state).await?;
                    drop(state);

                    // Format all values first to get consistent widths
                    let tick_str = format!("Tick {} Complete!", current_tick);
                    let type_str = format!("Type: {:?}", certificate.tick_type);
                    let tx_str = format!("Transactions: {:04}", certificate.transaction_count);
                    let vdf_str = format!("VDF: {} → {}", vdf_start, vdf_end);
                    let hash_str = format!("Hash: {}...", hex::encode(&certificate.tick_hash[..8]));

                    // Calculate the box width based on the longest line
                    let box_width = [
                        tick_str.len(),
                        type_str.len(),
                        tx_str.len(),
                        vdf_str.len(),
                        hash_str.len(),
                    ]
                    .iter()
                    .max()
                    .unwrap()
                    .max(&40)
                        + 4; // Add padding and ensure minimum width

                    // Helper function to pad strings
                    let pad = |s: &str| format!("│  {:<width$}  │", s, width = box_width - 6);

                    // Create the box
                    let top_line = format!("┌{}┐", "─".repeat(box_width - 2));
                    let bottom_line = format!("└{}┘", "─".repeat(box_width - 2));

                    info!("{}", top_line);
                    info!("{}", pad(&tick_str));
                    info!("{}", pad(&type_str));
                    info!("{}", pad(&tx_str));
                    info!("{}", pad(&vdf_str));
                    info!("{}", pad(&hash_str));
                    info!("{}", bottom_line);
                    // Log VDF checkpoint periodically
                    if current_tick % 10 == 0 {
                        self.log_vdf_checkpoint().await;
                    }
                }
                Err(e) => {
                    error!("FATAL: Tick {} failed: {}", current_tick, e);
                    error!("The eternal timeline has been disrupted!");
                    return Err(e);
                }
            }

            // VDF runs at maximum speed - no artificial delays
        }
    }

    /// Process a single eternal tick
    async fn process_eternal_tick(&self, tick_num: u64) -> Result<TickCertificate> {
        let k = self.config.iterations_per_tick;
        let _tick_start_iter = tick_num * k;

        // Get transactions for this tick from the pool
        let encrypted_txs = self.extract_tick_transactions(tick_num).await;

        info!(
            "Processing tick {} with {} encrypted transactions",
            tick_num,
            encrypted_txs.len()
        );

        // For single node, we follow the paper but skip Byzantine consensus
        // The tick processor handles all the phases correctly
        let certificate = self
            .tick_processor
            .process_tick(
                tick_num,
                self.vdf.clone(),
                self.state.clone(),
                encrypted_txs,
            )
            .await?;

        Ok(certificate)
    }

    /// Extract transactions for the current tick from the pool
    async fn extract_tick_transactions(&self, tick_num: u64) -> Vec<TimelockTransaction> {
        let mut pool = self.tx_pool.lock().await;
        let mut tick_txs = Vec::new();
        let mut remaining_txs = Vec::new();

        // Separate transactions for this tick vs future ticks
        for tx in pool.drain(..) {
            if tx.target_tick == tick_num {
                tick_txs.push(tx);
            } else if tx.target_tick > tick_num {
                remaining_txs.push(tx);
            }
            // Drop any transactions for past ticks
        }

        // Sort transactions by submission iteration (as per paper's ordering)
        tick_txs.sort_by_key(|tx| tx.submission_iteration);

        // Put back future transactions
        *pool = remaining_txs;

        debug!(
            "Extracted {} transactions for tick {}, {} remaining in pool",
            tick_txs.len(),
            tick_num,
            pool.len()
        );

        tick_txs
    }

    /// Log VDF checkpoint information
    async fn log_vdf_checkpoint(&self) {
        let vdf = self.vdf.read().await;
        let checkpoint = vdf.checkpoint();

        // Format all values first
        let title = "VDF Checkpoint";
        let iteration_str = format!("Iteration: {}", checkpoint.iteration);
        let forms_str = format!(
            "Forms: ({}, {}, {})",
            preview(&checkpoint.form_a, 8),
            preview(&checkpoint.form_b, 8),
            preview(&checkpoint.form_c, 8)
        );
        let hash_str = format!("Hash: {}...", hex::encode(&checkpoint.hash_chain[..8]));
        let certs_str = format!("Tick Certs: {}", checkpoint.tick_certificates.len());

        // Calculate the box width based on the longest line
        let box_width = [
            title.len(),
            iteration_str.len(),
            forms_str.len(),
            hash_str.len(),
            certs_str.len(),
        ]
        .iter()
        .max()
        .unwrap()
        .max(&40)
            + 4; // Add padding and ensure minimum width

        // Helper function to pad strings (left-aligned)
        let pad = |s: &str| format!("│  {:<width$}  │", s, width = box_width - 6);

        // Helper function to center text
        let center = |s: &str| {
            let padding = (box_width - 4 - s.len()) / 2;
            let left_pad = " ".repeat(padding);
            let right_pad = " ".repeat(box_width - 4 - padding - s.len());
            format!("│  {}{}{}  │", left_pad, s, right_pad)
        };

        // Create the box
        let top_line = format!("┌{}┐", "─".repeat(box_width - 2));
        let bottom_line = format!("└{}┘", "─".repeat(box_width - 2));

        info!("{}", top_line);
        info!("{}", center(&title));
        info!("{}", pad(&iteration_str));
        info!("{}", pad(&forms_str));
        info!("{}", pad(&hash_str));
        info!("{}", pad(&certs_str));
        info!("{}", bottom_line);
    }
}
fn preview(s: &str, n: usize) -> &str {
    // str::get() returns Option<&str>; unwrap_or just gives back s
    s.get(..n).unwrap_or(s)
}

// Implement RPC API on the handler
#[async_trait::async_trait]
impl KalaApiServer for KalaRpcHandler {
    async fn chain_info(&self) -> jsonrpsee::core::RpcResult<ChainInfo> {
        let (reply_tx, mut reply_rx) = mpsc::channel(1);

        self.chain_info_tx.send(reply_tx).await.map_err(|_| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Internal communication error",
                None::<()>,
            )
        })?;

        reply_rx.recv().await.ok_or_else(|| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Failed to get chain info",
                None::<()>,
            )
            .into()
        })
    }

    async fn submit_transaction(
        &self,
        req: SubmitTransactionRequest,
    ) -> jsonrpsee::core::RpcResult<SubmitTransactionResponse> {
        // Decode timelock transaction
        let tx_bytes = hex::decode(&req.encrypted_tx).map_err(|e| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid hex: {}", e),
                None::<()>,
            )
        })?;

        let tx: TimelockTransaction = serde_json::from_slice(&tx_bytes).map_err(|e| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid transaction format: {}", e),
                None::<()>,
            )
        })?;

        let (reply_tx, mut reply_rx) = mpsc::channel(1);

        self.submit_tx.send((tx, reply_tx)).await.map_err(|_| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Internal communication error",
                None::<()>,
            )
        })?;

        match reply_rx.recv().await {
            Some(Ok(response)) => Ok(response),
            Some(Err(e)) => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e,
                None::<()>,
            )
            .into()),
            None => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Failed to submit transaction",
                None::<()>,
            )
            .into()),
        }
    }

    async fn get_tick(
        &self,
        req: GetTickRequest,
    ) -> jsonrpsee::core::RpcResult<Option<TickCertificate>> {
        match self.state_db.get_tick(req.tick_number).await {
            Ok(result) => Ok(result),
            Err(e) => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ).into())
        }
    }

    async fn get_recent_ticks(
        &self,
        count: usize,
    ) -> jsonrpsee::core::RpcResult<Vec<TickCertificate>> {
        match self.state_db.get_recent_ticks(count).await {
            Ok(result) => Ok(result),
            Err(e) => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ).into())
        }
    }

    async fn get_account(
        &self,
        req: GetAccountRequest,
    ) -> jsonrpsee::core::RpcResult<Option<AccountInfo>> {
        let address_bytes = hex::decode(&req.address).map_err(|e| {
            jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid address hex: {}", e),
                None::<()>,
            )
        })?;

        if address_bytes.len() != 32 {
            return Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                "Address must be 32 bytes",
                None::<()>,
            )
            .into());
        }

        let mut address = [0u8; 32];
        address.copy_from_slice(&address_bytes);

        // Load current state from DB
        let state = match self.state_db.load_chain_state().await {
            Ok(state) => state,
            Err(e) => return Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ).into())
        };

        Ok(state.get_account(&address).map(|account| AccountInfo {
            balance: account.balance,
            nonce: account.nonce,
            staked_amount: account.staked_amount,
            delegation: account.delegation.map(hex::encode),
        }))
    }
}
