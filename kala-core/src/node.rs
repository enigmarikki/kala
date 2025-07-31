use anyhow::Result;
use std::sync::Arc;
use std::time::{Duration, Instant};
use tokio::sync::{RwLock, Mutex, mpsc};
use tracing::{info, warn, error, debug};
use sha2::{Sha256, Digest};

use kala_vdf::EternalVDF;
use kala_state::{ChainState, StateDB, TickCertificate};
use kala_transaction::{TimelockTransaction, EncryptionContext};
use kala_rpc::{
    KalaApiServer, ChainInfo, SubmitTransactionRequest, 
    SubmitTransactionResponse, GetTickRequest, GetAccountRequest, AccountInfo
};
use serde_json;
use crate::config::NodeConfig;
use crate::consensus::TickProcessor;

// RPC handler that communicates with the node via channels
pub struct KalaRpcHandler {
    chain_info_tx: mpsc::Sender<mpsc::Sender<ChainInfo>>,
    submit_tx: mpsc::Sender<(TimelockTransaction, mpsc::Sender<Result<SubmitTransactionResponse, String>>)>,
    state_db: Arc<StateDB>,
}

// Transaction acceptance window constants
const TX_ACCEPTANCE_WINDOW_START: f64 = 0.9;  // Accept txs starting at 90% of previous tick
const TX_ACCEPTANCE_WINDOW_END: f64 = 0.3;    // Accept txs until 30% of target tick

pub struct KalaNode {
    config: NodeConfig,
    vdf: Arc<RwLock<EternalVDF>>,
    state: Arc<RwLock<ChainState>>,
    state_db: Arc<StateDB>,
    tick_processor: Arc<TickProcessor>,
    // Transaction pool for encrypted transactions
    tx_pool: Arc<Mutex<Vec<TimelockTransaction>>>,
}

impl KalaNode {
    pub fn new(config: NodeConfig) -> Result<Self> {
        // Open state database
        let state_db = Arc::new(StateDB::open(&config.db_path)?);
        
        // Load chain state
        let chain_state = state_db.load_chain_state()?;
        
        // Initialize or restore VDF from checkpoint
        let vdf = match EternalVDF::from_checkpoint(&chain_state.vdf_checkpoint) {
            Ok(vdf) => Arc::new(RwLock::new(vdf)),
            Err(e) => return Err(anyhow::anyhow!("Failed to initialize VDF: {}", e)),
        };
        
        // Create tick processor with proper parameters
        let tick_processor = Arc::new(TickProcessor::new(
            config.iterations_per_tick,
            config.tick_duration_ms,
        ));
        
        info!("Initialized Kala node - The Eternal Timeline");
        info!("  - Iterations per tick (k): {}", config.iterations_per_tick);
        info!("  - Tick duration: {}ms", config.tick_duration_ms);
        info!("  - Current tick: {}", chain_state.current_tick);
        info!("  - VDF iteration: {}", chain_state.vdf_checkpoint.iteration);
        info!("  - Last tick hash: {}", hex::encode(chain_state.last_tick_hash));
        
        Ok(Self {
            config,
            vdf,
            state: Arc::new(RwLock::new(chain_state)),
            state_db,
            tick_processor,
            tx_pool: Arc::new(Mutex::new(Vec::new())),
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
        let (submit_tx, mut submit_rx) = mpsc::channel::<(TimelockTransaction, mpsc::Sender<Result<SubmitTransactionResponse, String>>)>(100);
        
        // Create RPC handler
        let rpc_handler = KalaRpcHandler {
            chain_info_tx,
            submit_tx,
            state_db: self.state_db.clone(),
        };
        
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
                        
                        // Check if we're in the acceptance window for this tick
                        let target_tick_start = tx.target_tick * k;
                        let target_tick_end = (tx.target_tick + 1) * k;
                        let acceptance_start = if tx.target_tick == 0 {
                            0
                        } else {
                            ((tx.target_tick - 1) * k) + ((k as f64 * TX_ACCEPTANCE_WINDOW_START) as u64)
                        };
                        let acceptance_end = target_tick_start + ((k as f64 * TX_ACCEPTANCE_WINDOW_END) as u64);
                        
                        if current_iter < acceptance_start || current_iter > acceptance_end {
                            let _ = reply_tx.send(Err(format!(
                                "Outside acceptance window for tick {} (current iter: {}, window: {}-{})",
                                tx.target_tick, current_iter, acceptance_start, acceptance_end
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
            let tick_start = Instant::now();
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
                warn!("VDF iteration {} doesn't match expected tick start {}", vdf_start, expected_start);
            }
            
            // Process the eternal tick
            match self.process_eternal_tick(current_tick).await {
                Ok(certificate) => {
                    // Store certificate in database
                    self.state_db.store_tick(&certificate)?;
                    
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
                    self.state_db.save_chain_state(&state)?;
                    drop(state);
                    
                    let elapsed = tick_start.elapsed();
                    info!("┌─────────────────────────────────────────┐");
                    info!("│      Tick {} Complete!               │", current_tick);
                    info!("│  Type: {:?}                          │", certificate.tick_type);
                    info!("│  Transactions: {:04}                  │", certificate.transaction_count);
                    info!("│  Duration: {:?}                      │", elapsed);
                    info!("│  VDF: {} → {}              │", vdf_start, vdf_end);
                    info!("│  Hash: {}...           │", hex::encode(&certificate.tick_hash[..8]));
                    info!("└─────────────────────────────────────────┘");
                    
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
            
            // Maintain tick timing
            let elapsed = tick_start.elapsed();
            if elapsed < Duration::from_millis(self.config.tick_duration_ms) {
                let sleep_duration = Duration::from_millis(self.config.tick_duration_ms) - elapsed;
                tokio::time::sleep(sleep_duration).await;
            } else {
                warn!("Tick {} overran by {:?}", current_tick, elapsed - Duration::from_millis(self.config.tick_duration_ms));
            }
        }
    }
    
    /// Process a single eternal tick
    async fn process_eternal_tick(&self, tick_num: u64) -> Result<TickCertificate> {
        let k = self.config.iterations_per_tick;
        let _tick_start_iter = tick_num * k;
        
        // Get transactions for this tick from the pool
        let encrypted_txs = self.extract_tick_transactions(tick_num).await;
        
        info!("Processing tick {} with {} encrypted transactions", tick_num, encrypted_txs.len());
        
        // For single node, we follow the paper but skip Byzantine consensus
        // The tick processor handles all the phases correctly
        let certificate = self.tick_processor.process_tick(
            tick_num,
            self.vdf.clone(),
            self.state.clone(),
            encrypted_txs,
        ).await?;
        
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
        
        debug!("Extracted {} transactions for tick {}, {} remaining in pool", 
               tick_txs.len(), tick_num, pool.len());
        
        tick_txs
    }
    
    /// Log VDF checkpoint information
    async fn log_vdf_checkpoint(&self) {
        let vdf = self.vdf.read().await;
        let checkpoint = vdf.checkpoint();
        info!("┌─────────────────────────────────────────┐");
        info!("│           VDF Checkpoint                │");
        info!("│  Iteration: {:012}                │", checkpoint.iteration);
        info!("│  Forms: ({}, {}, {})                   │", 
              &checkpoint.form_a[..8], &checkpoint.form_b[..8], &checkpoint.form_c[..8]);
        info!("│  Hash: {}...           │", hex::encode(&checkpoint.hash_chain[..8]));
        info!("│  Tick Certs: {}                      │", checkpoint.tick_certificates.len());
        info!("└─────────────────────────────────────────┘");
    }
}

// Implement RPC API on the handler
#[async_trait::async_trait]
impl KalaApiServer for KalaRpcHandler {
    async fn chain_info(&self) -> jsonrpsee::core::RpcResult<ChainInfo> {
        let (reply_tx, mut reply_rx) = mpsc::channel(1);
        
        self.chain_info_tx.send(reply_tx).await
            .map_err(|_| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Internal communication error",
                None::<()>,
            ))?;
        
        reply_rx.recv().await
            .ok_or_else(|| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Failed to get chain info",
                None::<()>,
            ).into())
    }
    
    async fn submit_transaction(&self, req: SubmitTransactionRequest) -> jsonrpsee::core::RpcResult<SubmitTransactionResponse> {
        // Decode timelock transaction
        let tx_bytes = hex::decode(&req.encrypted_tx)
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid hex: {}", e),
                None::<()>,
            ))?;
        
        let tx: TimelockTransaction = serde_json::from_slice(&tx_bytes)
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid transaction format: {}", e),
                None::<()>,
            ))?;
        
        let (reply_tx, mut reply_rx) = mpsc::channel(1);
        
        self.submit_tx.send((tx, reply_tx)).await
            .map_err(|_| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Internal communication error",
                None::<()>,
            ))?;
        
        match reply_rx.recv().await {
            Some(Ok(response)) => Ok(response),
            Some(Err(e)) => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e,
                None::<()>,
            ).into()),
            None => Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                "Failed to submit transaction",
                None::<()>,
            ).into()),
        }
    }
    
    async fn get_tick(&self, req: GetTickRequest) -> jsonrpsee::core::RpcResult<Option<TickCertificate>> {
        self.state_db.get_tick(req.tick_number)
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ).into())
    }
    
    async fn get_recent_ticks(&self, count: usize) -> jsonrpsee::core::RpcResult<Vec<TickCertificate>> {
        self.state_db.get_recent_ticks(count)
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ).into())
    }
    
    async fn get_account(&self, req: GetAccountRequest) -> jsonrpsee::core::RpcResult<Option<AccountInfo>> {
        let address_bytes = hex::decode(&req.address)
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                format!("Invalid address hex: {}", e),
                None::<()>,
            ))?;
        
        if address_bytes.len() != 32 {
            return Err(jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INVALID_PARAMS_CODE,
                "Address must be 32 bytes",
                None::<()>,
            ).into());
        }
        
        let mut address = [0u8; 32];
        address.copy_from_slice(&address_bytes);
        
        // Load current state from DB
        let state = self.state_db.load_chain_state()
            .map_err(|e| jsonrpsee::types::error::ErrorObject::owned(
                jsonrpsee::types::error::INTERNAL_ERROR_CODE,
                e.to_string(),
                None::<()>,
            ))?;
        
        Ok(state.get_account(&address).map(|account| AccountInfo {
            balance: account.balance,
            nonce: account.nonce,
            staked_amount: account.staked_amount,
            delegation: account.delegation.map(hex::encode),
        }))
    }
}