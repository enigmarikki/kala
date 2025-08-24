//! Consensus Engine for Kala's Tick-Based Architecture
//!
//! This module implements the core consensus mechanism described in the Kala paper.
//! The [`TickProcessor`] orchestrates the four-phase tick processing:
//!
//! 1. **Collection Phase** (0 to k/3): Timestamp transactions as they arrive
//! 2. **Ordering Phase** (at k/3): Determine canonical transaction ordering  
//! 3. **Decryption Phase** (k/3 to 2k/3): Decrypt timelock puzzles in parallel
//! 4. **Validation Phase** (2k/3 to k): Validate and apply transactions
//!
//! # VDF Integration
//!
//! The consensus engine is tightly coupled with the VDF computation:
//! - Transaction data is timestamped directly into the VDF hash chain
//! - VDF iteration count determines phase boundaries
//! - Tick certificates combine VDF proofs with consensus results
//!
//! # MEV Resistance
//!
//! Transaction ordering is determined before decryption, preventing:
//! - Front-running attacks
//! - Sandwich attacks  
//! - MEV extraction through order manipulation
//!
//! # Example
//!
//! ```no_run
//! use kala_core::consensus::TickProcessor;
//! use std::sync::Arc;
//! use tokio::sync::RwLock;
//!
//! let processor = TickProcessor::new(65536);
//! // Process tick with VDF and state...
//! ```

use anyhow::Result;
use sha2::{Digest, Sha256};
use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};
use tokio::sync::RwLock;
use tracing::{debug, info, warn};

use kala_state::{ChainState, TickCertificate, TickType};
use kala_transaction::{
    decrypt_timelock_batch, decrypt_timelock_transaction, EncryptionContext, TimelockTransaction,
    Transaction,
};
use kala_vdf::EternalVDF;

/// Core consensus processor implementing Kala's tick-based architecture
///
/// The `TickProcessor` orchestrates the execution of blockchain ticks according
/// to the four-phase protocol described in the Kala research paper. Each tick
/// processes transactions in a deterministic, MEV-resistant manner.
///
/// # Architecture
///
/// - **Phase 1 (Collection)**: Timestamps encrypted transactions into VDF
/// - **Phase 2 (Ordering)**: Commits to canonical transaction ordering  
/// - **Phase 3 (Decryption)**: Decrypts timelock puzzles in parallel
/// - **Phase 4 (Validation)**: Validates and applies decrypted transactions
///
/// # Thread Safety
///
/// All methods are async and thread-safe, designed to work with shared
/// VDF and state instances across multiple tasks.
pub struct TickProcessor {
    /// Number of VDF iterations per tick (k parameter)
    iterations_per_tick: u64,
    /// Shared encryption context for timelock operations
    encryption_ctx: Arc<EncryptionContext>,
}

impl TickProcessor {
    /// Creates a new tick processor with the specified VDF parameters
    ///
    /// # Parameters
    ///
    /// - `iterations_per_tick`: Number of VDF iterations per tick (k parameter)
    ///
    /// # Returns
    ///
    /// A new `TickProcessor` configured for the given tick duration.
    /// The encryption context is initialized with the same parameters
    /// for timelock compatibility.
    ///
    /// # Example
    ///
    /// ```
    /// use kala_core::consensus::TickProcessor;
    ///
    /// // Standard configuration from the paper
    /// let processor = TickProcessor::new(65536);
    /// ```
    pub fn new(iterations_per_tick: u64) -> Self {
        let encryption_ctx = Arc::new(EncryptionContext::new(iterations_per_tick));

        Self {
            iterations_per_tick,
            encryption_ctx,
        }
    }

    /// Returns a shared reference to the encryption context
    ///
    /// The encryption context is used by clients to create timelock
    /// transactions that are compatible with this processor's timing
    /// parameters.
    ///
    /// # Returns
    ///
    /// A shared reference to the [`EncryptionContext`] used for timelock operations.
    pub fn encryption_context(&self) -> Arc<EncryptionContext> {
        self.encryption_ctx.clone()
    }

    /// Processes a complete blockchain tick using the four-phase protocol
    ///
    /// This is the main entry point for tick processing, implementing the complete
    /// four-phase algorithm described in the Kala research paper. The function
    /// orchestrates VDF computation, transaction ordering, decryption, and validation
    /// in a deterministic, MEV-resistant manner.
    ///
    /// # Four-Phase Algorithm
    ///
    /// 1. **Collection Phase (0 to k/3)**:
    ///    - Timestamps encrypted transactions into VDF hash chain
    ///    - Maintains canonical arrival order
    ///    - Creates unforgeable transaction history
    ///
    /// 2. **Ordering Phase (at k/3)**:
    ///    - Commits to final transaction ordering
    ///    - Based on VDF timestamped arrival order
    ///    - Prevents MEV through pre-commitment
    ///
    /// 3. **Decryption Phase (k/3 to 2k/3)**:
    ///    - Decrypts timelock puzzles in parallel
    ///    - Uses GPU acceleration when available
    ///    - Falls back to CPU if GPU fails
    ///    - Continues VDF computation during decryption
    ///
    /// 4. **Validation Phase (2k/3 to k)**:
    ///    - Validates decrypted transactions
    ///    - Applies state transitions
    ///    - Creates transaction merkle root
    ///    - Completes remaining VDF iterations
    ///
    /// # Parameters
    ///
    /// - `tick_num`: The tick number being processed
    /// - `vdf`: Shared reference to the eternal VDF computation
    /// - `state`: Shared reference to the blockchain state
    /// - `encrypted_txs`: List of timelock-encrypted transactions for this tick
    ///
    /// # Returns
    ///
    /// A [`TickCertificate`] containing:
    /// - VDF proof and state at tick completion
    /// - Transaction processing results
    /// - Cryptographic commitments to tick contents
    /// - Timestamp and linking information
    ///
    /// # Errors
    ///
    /// Returns an error if:
    /// - VDF computation fails or becomes inconsistent
    /// - Critical decryption failures occur
    /// - State validation fails
    /// - Database operations fail
    ///
    /// # Example
    ///
    /// ```no_run
    /// use kala_core::consensus::TickProcessor;
    /// use std::sync::Arc;
    /// use tokio::sync::RwLock;
    ///
    /// # async fn example() -> anyhow::Result<()> {
    /// let processor = TickProcessor::new(65536);
    /// // Assuming vdf, state, and transactions are initialized...
    /// # let vdf = Arc::new(RwLock::new(todo!()));
    /// # let state = Arc::new(RwLock::new(todo!()));
    /// # let encrypted_txs = vec![];
    ///
    /// let certificate = processor.process_tick(
    ///     42,  // tick number
    ///     vdf,
    ///     state,
    ///     encrypted_txs
    /// ).await?;
    ///
    /// println!(\"Processed tick {} with {} transactions\",
    ///          certificate.tick_number,
    ///          certificate.transaction_count);
    /// # Ok(())
    /// # }
    /// ```
    pub async fn process_tick(
        &self,
        tick_num: u64,
        vdf: Arc<RwLock<EternalVDF>>,
        state: Arc<RwLock<ChainState>>,
        encrypted_txs: Vec<TimelockTransaction>,
    ) -> Result<TickCertificate> {
        let k = self.iterations_per_tick;
        let tick_start_iter = tick_num * k;

        // Update encryption context with current tick
        self.encryption_ctx.update_tick(tick_num);

        // Phase boundaries as per the paper
        let collection_phase_end = k / 3;
        let consensus_phase_end = 2 * k / 3;

        info!(
            "Tick {}: Starting with {} encrypted transactions",
            tick_num,
            encrypted_txs.len()
        );

        // Phase 1: Collection (0 to k/3)
        // Leader timestamps transactions as they arrive (from the paper)
        info!("Tick {}: Phase 1 - Collection phase", tick_num);

        // Track which transactions we've timestamped
        let mut timestamped_indices = Vec::new();

        for i in 0..collection_phase_end {
            let mut vdf_write = vdf.write().await;

            // Check if we should timestamp a transaction at this iteration
            // Transactions are timestamped at their submission_iteration
            for (idx, tx) in encrypted_txs.iter().enumerate() {
                let current_iter = vdf_write.get_iteration() + 1; // Next iteration
                if tx.submission_iteration == current_iter && !timestamped_indices.contains(&idx) {
                    // Timestamp the encrypted transaction data
                    let tx_data = Self::serialize_timelock_tx(tx);
                    debug!(
                        "Timestamping transaction {} at iteration {}",
                        idx, current_iter
                    );
                    vdf_write.step(Some(tx_data));
                    timestamped_indices.push(idx);
                    break; // Only one transaction per iteration
                }
            }

            // If no transaction to timestamp, just advance VDF
            if !timestamped_indices.iter().any(|&idx| {
                encrypted_txs[idx].submission_iteration == vdf_write.get_iteration() + 1
            }) {
                vdf_write.step(None);
            }

            drop(vdf_write);
        }

        // Phase 2: Ordering (at k/3)
        // For single node, order by submission iteration (already timestamped in VDF)
        info!("Tick {}: Phase 2 - Ordering transactions", tick_num);
        let mut ordered_txs = encrypted_txs;
        ordered_txs.sort_by_key(|tx| tx.submission_iteration);

        // Timestamp the ordering decision
        let ordering_data = Self::create_ordering_commitment(&ordered_txs);
        let mut vdf_write = vdf.write().await;
        vdf_write.step(Some(ordering_data));
        drop(vdf_write);

        // Phase 3: Parallel Decryption (k/3 to 2k/3)
        info!("Tick {}: Phase 3 - Parallel decryption phase", tick_num);

        // Start parallel decryption using GPU batch processing
        let decrypt_handle = tokio::spawn({
            let txs = ordered_txs.clone();
            async move {
                match decrypt_timelock_batch(&txs) {
                    Ok(decrypted) => decrypted,
                    Err(e) => {
                        warn!("Batch decryption failed: {}, falling back to sequential", e);
                        // Fallback to sequential decryption
                        let mut results = Vec::new();
                        for tx in txs {
                            match decrypt_timelock_transaction(&tx) {
                                Ok(decrypted) => results.push(decrypted),
                                Err(e) => warn!("Failed to decrypt transaction: {}", e),
                            }
                        }
                        results
                    }
                }
            }
        });

        // Continue VDF during decryption (no data to timestamp during this phase)
        for i in collection_phase_end + 1..consensus_phase_end {
            let mut vdf_write = vdf.write().await;
            vdf_write.step(None);
            drop(vdf_write);
        }

        // Wait for decryption to complete
        let decrypted_txs = decrypt_handle.await?;
        info!(
            "Tick {}: Decrypted {} transactions",
            tick_num,
            decrypted_txs.len()
        );

        // Phase 4: Validation and State Updates (2k/3 to k)
        info!("Tick {}: Phase 4 - Validation and finalization", tick_num);

        let mut valid_txs = Vec::new();
        let mut state_write = state.write().await;

        for tx in decrypted_txs {
            if Self::validate_transaction(&tx, &state_write) {
                if let Err(e) = Self::apply_transaction(&tx, &mut state_write) {
                    warn!("Failed to apply transaction: {}", e);
                    continue;
                }
                valid_txs.push(tx);
            }
        }

        // Update state with VDF progress
        state_write.total_transactions += valid_txs.len() as u64;

        drop(state_write);

        info!(
            "Tick {}: {} valid transactions after validation",
            tick_num,
            valid_txs.len()
        );

        // Timestamp final transaction set merkle root
        let tx_merkle_root = Self::compute_transaction_merkle_root(&valid_txs);
        let mut vdf_write = vdf.write().await;
        vdf_write.step(Some(tx_merkle_root.to_vec()));
        drop(vdf_write);

        // Complete remaining VDF iterations
        let vdf_read = vdf.read().await;
        let current = vdf_read.get_iteration();
        drop(vdf_read);

        let target = (tick_num + 1) * k; // where we must end
        let remaining = target - current;

        for i in 0..remaining {
            let mut vdf_write = vdf.write().await;
            vdf_write.step(None);
            drop(vdf_write);
        }

        // Create unified tick certificate
        let certificate = self
            .create_unified_certificate(
                tick_num,
                valid_txs,
                tx_merkle_root,
                vdf.clone(),
                state.clone(),
            )
            .await?;

        // Update chain state
        let mut state_write = state.write().await;
        state_write.current_tick = tick_num + 1;
        state_write.last_tick_hash = certificate.tick_hash;

        // Get VDF checkpoint for state update
        let vdf_read = vdf.read().await;
        let vdf_checkpoint = vdf_read.checkpoint();
        state_write.update_from_vdf_checkpoint(vdf_checkpoint);
        drop(vdf_read);
        drop(state_write);

        info!(
            "Tick {}: Completed with certificate hash {:?}",
            tick_num,
            hex::encode(&certificate.tick_hash)
        );

        Ok(certificate)
    }

    fn serialize_timelock_tx(tx: &TimelockTransaction) -> Vec<u8> {
        // Serialize the encrypted transaction for timestamping
        let mut data = Vec::new();
        data.extend_from_slice(&tx.submission_iteration.to_le_bytes());
        data.extend_from_slice(&tx.target_tick.to_le_bytes());

        // Serialize SealedTransaction
        data.extend_from_slice(&tx.encrypted_data.nonce);
        data.extend_from_slice(&tx.encrypted_data.tag);
        data.extend_from_slice(&tx.encrypted_data.ciphertext);

        // Include puzzle hardness for ordering
        data.extend_from_slice(&tx.puzzle.hardness.to_le_bytes());

        data
    }

    fn create_ordering_commitment(txs: &[TimelockTransaction]) -> Vec<u8> {
        let mut hasher = Sha256::new();
        hasher.update(b"ordering");
        for tx in txs {
            hasher.update(&tx.submission_iteration.to_le_bytes());
            hasher.update(&tx.target_tick.to_le_bytes());
            // Include a hash of the encrypted data for commitment
            hasher.update(&tx.encrypted_data.nonce);
            hasher.update(&tx.encrypted_data.tag);
            let data_hash = Sha256::digest(&tx.encrypted_data.ciphertext);
            hasher.update(&data_hash);
        }
        hasher.finalize().to_vec()
    }

    fn compute_transaction_merkle_root(txs: &[Transaction]) -> [u8; 32] {
        let hashes: Vec<[u8; 32]> = txs.iter().map(|tx| Self::hash_transaction(tx)).collect();
        compute_merkle_root(&hashes)
    }

    fn validate_transaction(tx: &Transaction, state: &ChainState) -> bool {
        // Get sender address from transaction
        let sender = match tx {
            Transaction::Send(s) => &s.sender,
            Transaction::Mint(m) => &m.sender,
            Transaction::Stake(s) => &s.sender,
            Transaction::Solve(s) => &s.sender,
        };

        // Get nonce from transaction
        let tx_nonce = match tx {
            Transaction::Send(s) => s.nonce,
            Transaction::Mint(m) => m.nonce,
            Transaction::Stake(s) => s.nonce,
            Transaction::Solve(s) => s.nonce,
        };

        // Check nonce
        if let Some(account_nonce) = state.get_account_nonce(sender) {
            if tx_nonce <= account_nonce {
                warn!(
                    "Invalid nonce: tx {} <= account {}",
                    tx_nonce, account_nonce
                );
                return false;
            }
        }

        // Check balance for transfers
        match tx {
            Transaction::Send(send) => {
                if state.get_balance(&send.sender) < send.amount {
                    warn!("Insufficient balance for send");
                    return false;
                }
            }
            Transaction::Stake(stake) => {
                if state.get_balance(&stake.sender) < stake.amount {
                    warn!("Insufficient balance for stake");
                    return false;
                }
            }
            _ => {}
        }

        true
    }

    fn apply_transaction(tx: &Transaction, state: &mut ChainState) -> Result<()> {
        match tx {
            Transaction::Send(send) => {
                state.transfer(&send.sender, &send.receiver, send.amount)?;
                state.update_nonce(&send.sender, send.nonce);
            }
            Transaction::Mint(mint) => {
                state.mint(&mint.sender, mint.amount)?;
                state.update_nonce(&mint.sender, mint.nonce);
            }
            Transaction::Stake(stake) => {
                state.stake(&stake.sender, &stake.delegation_receiver, stake.amount)?;
                state.update_nonce(&stake.sender, stake.nonce);
            }
            Transaction::Solve(solve) => {
                state.record_puzzle_solution(&solve.sender, &solve.puzzle_id, &solve.proof)?;
                state.update_nonce(&solve.sender, solve.nonce);
            }
        }

        Ok(())
    }

    async fn create_unified_certificate(
        &self,
        tick_num: u64,
        transactions: Vec<Transaction>,
        tx_merkle_root: [u8; 32],
        vdf: Arc<RwLock<EternalVDF>>,
        state: Arc<RwLock<ChainState>>,
    ) -> Result<TickCertificate> {
        let vdf_read = vdf.read().await;
        let state_read = state.read().await;

        // Get VDF tick certificate if available
        let vdf_tick_cert = vdf_read.get_tick_certificate(tick_num);

        // Determine tick type based on paper's classification
        let tick_type = if transactions.is_empty() {
            TickType::Empty
        } else {
            TickType::Full
        };

        // Get VDF state from checkpoint
        let vdf_checkpoint = vdf_read.checkpoint();

        // Create unified certificate that combines VDF and consensus data
        let certificate = TickCertificate {
            tick_number: tick_num,
            tick_type,
            vdf_iteration: vdf_checkpoint.iteration,
            vdf_form: (
                vdf_checkpoint.form_a.clone(),
                vdf_checkpoint.form_b.clone(),
                vdf_checkpoint.form_c.clone(),
            ),
            hash_chain_value: vdf_checkpoint.hash_chain,
            tick_hash: [0; 32], // Will be computed below
            transaction_count: transactions.len() as u32,
            transaction_merkle_root: tx_merkle_root,
            timestamp: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs(),
            previous_tick_hash: state_read.last_tick_hash,
        };

        // Compute tick hash
        let mut cert_with_hash = certificate;
        cert_with_hash.tick_hash = cert_with_hash.compute_hash();

        Ok(cert_with_hash)
    }

    fn hash_transaction(tx: &Transaction) -> [u8; 32] {
        let mut hasher = Sha256::new();

        // Hash based on transaction type
        match tx {
            Transaction::Send(send) => {
                hasher.update(b"send");
                hasher.update(&send.sender);
                hasher.update(&send.receiver);
                hasher.update(&send.amount.to_le_bytes());
                hasher.update(&send.nonce.to_le_bytes());
                hasher.update(&send.signature);
            }
            Transaction::Mint(mint) => {
                hasher.update(b"mint");
                hasher.update(&mint.sender);
                hasher.update(&mint.amount.to_le_bytes());
                hasher.update(&mint.denom);
                hasher.update(&mint.nonce.to_le_bytes());
                hasher.update(&mint.signature);
            }
            Transaction::Stake(stake) => {
                hasher.update(b"stake");
                hasher.update(&stake.sender);
                hasher.update(&stake.delegation_receiver);
                hasher.update(&stake.amount.to_le_bytes());
                hasher.update(&stake.nonce.to_le_bytes());
                hasher.update(&stake.signature);
            }
            Transaction::Solve(solve) => {
                hasher.update(b"solve");
                hasher.update(&solve.sender);
                hasher.update(&solve.puzzle_id);
                hasher.update(&solve.proof);
                hasher.update(&solve.nonce.to_le_bytes());
                hasher.update(&solve.signature);
            }
        }

        hasher.finalize().into()
    }

    /// Handles tick processing failures with graceful degradation
    ///
    /// This function implements Algorithm 4 from the Kala paper for handling
    /// situations where tick processing cannot complete normally. It ensures
    /// the VDF computation continues uninterrupted while creating a checkpoint
    /// tick that maintains chain integrity.
    ///
    /// # Graceful Degradation Strategy
    ///
    /// 1. **Complete VDF iterations**: Finish remaining iterations for the tick
    /// 2. **Create checkpoint tick**: Generate a valid tick certificate without transactions
    /// 3. **Update state**: Maintain chain continuity and VDF checkpoints
    /// 4. **Preserve timing**: Ensure subsequent ticks remain synchronized
    ///
    /// # When to Use
    ///
    /// This method should be called when:
    /// - Transaction decryption fails catastrophically
    /// - State validation encounters unrecoverable errors
    /// - Network partitions prevent consensus
    /// - System resource exhaustion occurs
    ///
    /// # Parameters
    ///
    /// - `tick_num`: The tick number that failed to process normally
    /// - `vdf`: Shared reference to the eternal VDF computation
    /// - `state`: Shared reference to the blockchain state
    /// - `current_iteration`: Current VDF iteration when failure occurred
    ///
    /// # Returns
    ///
    /// A [`TickCertificate`] of type [`TickType::Checkpoint`] that:
    /// - Contains no transactions but maintains VDF proof
    /// - Preserves chain continuity and timing
    /// - Allows the network to continue operation
    pub async fn handle_tick_failure(
        &self,
        tick_num: u64,
        vdf: Arc<RwLock<EternalVDF>>,
        state: Arc<RwLock<ChainState>>,
        current_iteration: u64,
    ) -> Result<TickCertificate> {
        let k = self.iterations_per_tick;
        let tick_end = (tick_num + 1) * k;
        let remaining = tick_end - current_iteration;

        warn!(
            "Tick {}: Handling failure with {} iterations remaining",
            tick_num, remaining
        );

        // Complete remaining VDF iterations without timestamping
        for _ in 0..remaining {
            let mut vdf_write = vdf.write().await;
            vdf_write.step(None);
            drop(vdf_write);
        }

        // Create checkpoint tick (no transactions)
        let vdf_read = vdf.read().await;
        let state_read = state.read().await;

        // Get VDF state
        let vdf_checkpoint = vdf_read.checkpoint();

        let certificate = TickCertificate {
            tick_number: tick_num,
            tick_type: TickType::Checkpoint,
            vdf_iteration: vdf_checkpoint.iteration,
            vdf_form: (
                vdf_checkpoint.form_a.clone(),
                vdf_checkpoint.form_b.clone(),
                vdf_checkpoint.form_c.clone(),
            ),
            hash_chain_value: vdf_checkpoint.hash_chain,
            tick_hash: [0; 32],
            transaction_count: 0,
            transaction_merkle_root: [0; 32],
            timestamp: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs(),
            previous_tick_hash: state_read.last_tick_hash,
        };

        let mut cert_with_hash = certificate;
        cert_with_hash.tick_hash = cert_with_hash.compute_hash();

        // Update state even for checkpoint
        drop(state_read);
        let mut state_write = state.write().await;
        state_write.current_tick = tick_num + 1;
        state_write.last_tick_hash = cert_with_hash.tick_hash;

        let vdf_checkpoint = vdf_read.checkpoint();
        state_write.update_from_vdf_checkpoint(vdf_checkpoint);

        Ok(cert_with_hash)
    }
}

/// Computes the Merkle root of a list of transaction hashes
///
/// This function builds a complete binary Merkle tree from the given hashes
/// and returns the root hash. The implementation follows the standard approach:
/// - If the number of hashes is odd, the last hash is duplicated
/// - Pairs of hashes are concatenated and hashed together
/// - The process continues until only one hash remains
///
/// # Parameters
///
/// - `hashes`: Slice of 32-byte hashes to build the tree from
///
/// # Returns
///
/// The 32-byte Merkle root hash. Returns all zeros if the input is empty.
///
/// # Example
///
/// ```
/// use sha2::{Digest, Sha256};
///
/// let hash1 = Sha256::digest(b"transaction1").into();
/// let hash2 = Sha256::digest(b"transaction2").into();
/// let hashes = [hash1, hash2];
///
/// let root = compute_merkle_root(&hashes);
/// assert_ne!(root, [0u8; 32]); // Non-empty root
/// ```
fn compute_merkle_root(hashes: &[[u8; 32]]) -> [u8; 32] {
    if hashes.is_empty() {
        return [0; 32];
    }

    let mut current = hashes.to_vec();

    while current.len() > 1 {
        let mut next = Vec::new();

        for chunk in current.chunks(2) {
            let mut hasher = Sha256::new();
            hasher.update(&chunk[0]);
            if chunk.len() > 1 {
                hasher.update(&chunk[1]);
            } else {
                // For odd number of hashes, duplicate the last one
                hasher.update(&chunk[0]);
            }
            next.push(hasher.finalize().into());
        }

        current = next;
    }

    current[0]
}
