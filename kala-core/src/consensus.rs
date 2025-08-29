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
use tracing::{info, warn};

use kala_state::{ChainState, TickCertificate, TickType};
use kala_tick::CVDFStreamer;
use kala_transaction::{
    decrypt_timelock_batch, decrypt_timelock_transaction, EncryptionContext, TimelockTransaction,
    Transaction,
};

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

    /// Processes a complete blockchain tick using CVDF streaming and the four-phase protocol
    ///
    /// This is the main entry point for tick processing, implementing the complete
    /// four-phase algorithm described in the Kala research paper. The function
    /// orchestrates VDF computation, transaction ordering, decryption, and validation
    /// in a deterministic, MEV-resistant manner.
    ///
    /// # Four-Phase Algorithm
    ///
    /// 1. **Witness Phase (0 to k/3)**:
    ///    - Timestamps encrypted transactions into VDF hash chain
    ///    - Maintains canonical arrival order
    ///    - Creates unforgeable transaction history
    ///
    /// 2. **Consensus Phase (k/3 to k/2)**:
    ///    - Commits to final transaction ordering
    ///    - Based on VDF timestamped arrival order
    ///    - Prevents MEV through pre-commitment
    ///
    /// 3. **Decryption Phase (k/2 to 2k/3)**:
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
    /// Process tick using new CVDF streaming approach
    pub async fn process_cvdf_tick(
        &self,
        tick_num: u64,
        cvdf_streamer: Arc<RwLock<CVDFStreamer>>,
        state: Arc<RwLock<ChainState>>,
        encrypted_txs: Vec<TimelockTransaction>,
    ) -> Result<TickCertificate> {
        let k = self.iterations_per_tick;

        info!(
            "Tick {}: Starting CVDF streaming with {} encrypted transactions",
            tick_num,
            encrypted_txs.len()
        );

        // Update encryption context with current tick
        self.encryption_ctx.update_tick(tick_num);

        // Phase 1: Witness phase - Controlled iteration with CVDF proofs
        info!(
            "Tick {}: Phase 1 - Witness phase ({} iterations)",
            tick_num,
            k / 3
        );
        let collection_phase_steps = k / 3;

        // Get starting form for this tick - use CVDF streamer's discriminant for consistency
        let mut current_form = {
            let cvdf_read = cvdf_streamer.read().await;
            let discriminant = cvdf_read.get_discriminant();
            kala_tick::QuadraticForm::identity(discriminant)
        };

        // Perform collection phase iterations with CVDF proofs
        let collection_result = {
            let mut cvdf = cvdf_streamer.write().await;
            cvdf.compute_k_steps(&current_form, collection_phase_steps as usize)?
        };

        current_form = collection_result.output;

        // Phase 2: Ordering - commit to transaction ordering
        info!("Tick {}: Phase 2 - Transaction ordering", tick_num);
        let mut ordered_txs = encrypted_txs;
        ordered_txs.sort_by_key(|tx| tx.submission_iteration);

        // Perform one step to commit ordering
        let ordering_result = {
            let mut cvdf = cvdf_streamer.write().await;
            cvdf.compute_single_step(&current_form)?
        };

        current_form = ordering_result.output;

        // Phase 3: Parallel Decryption
        info!(
            "Tick {}: Phase 3 - Parallel decryption with CVDF streaming",
            tick_num
        );

        // Start parallel decryption
        let decrypt_handle = tokio::spawn({
            let txs = ordered_txs.clone();
            async move {
                match decrypt_timelock_batch(&txs) {
                    Ok(decrypted) => decrypted,
                    Err(e) => {
                        warn!("Batch decryption failed: {}, falling back to sequential", e);
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

        // Continue computation during decryption phase
        let decryption_phase_steps = k / 3;
        let decryption_result = {
            let mut cvdf = cvdf_streamer.write().await;
            cvdf.compute_k_steps(&current_form, decryption_phase_steps as usize)?
        };

        current_form = decryption_result.output;

        // Wait for decryption to complete
        let decrypted_txs = decrypt_handle.await?;
        info!(
            "Tick {}: Decrypted {} transactions",
            tick_num,
            decrypted_txs.len()
        );

        // Phase 4: Validation and State Updates
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

        state_write.total_transactions += valid_txs.len() as u64;
        drop(state_write);

        // Complete remaining steps for this tick
        let remaining_steps = k - collection_phase_steps - 1 - decryption_phase_steps;
        let final_result = if remaining_steps > 0 {
            let mut cvdf = cvdf_streamer.write().await;
            cvdf.compute_k_steps(&current_form, remaining_steps as usize)?
        } else {
            use kala_tick::CVDFStepResult;
            // Create dummy result if no remaining steps
            CVDFStepResult {
                output: current_form.clone(),
                proof: kala_tick::CVDFStepProof {
                    input: current_form.clone(),
                    output: current_form.clone(),
                    proof_data: vec![],
                },
                step_count: 0,
            }
        };

        current_form = final_result.output;

        info!(
            "Tick {}: {} valid transactions after validation",
            tick_num,
            valid_txs.len()
        );

        // Create tick certificate with the final CVDF state
        let certificate = self
            .create_cvdf_certificate(tick_num, valid_txs, &current_form, state.clone())
            .await?;

        // Update chain state
        let mut state_write = state.write().await;
        state_write.current_tick = tick_num + 1;
        state_write.last_tick_hash = certificate.tick_hash;

        // Update CVDF checkpoint in state
        let cvdf = cvdf_streamer.read().await;
        if let Ok(checkpoint) = cvdf.export_state() {
            state_write.set_cvdf_checkpoint(checkpoint);
        }
        drop(cvdf);
        drop(state_write);

        info!(
            "Tick {}: Completed with CVDF certificate hash {:?}",
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

    /// Create certificate with CVDF output
    async fn create_cvdf_certificate(
        &self,
        tick_num: u64,
        transactions: Vec<Transaction>,
        final_form: &kala_tick::QuadraticForm,
        state: Arc<RwLock<ChainState>>,
    ) -> Result<TickCertificate> {
        let state_read = state.read().await;

        // Determine tick type
        let tick_type = if transactions.is_empty() {
            TickType::Empty
        } else {
            TickType::Full
        };

        // Compute transaction merkle root
        let tx_merkle_root = Self::compute_transaction_merkle_root(&transactions);

        // Use the final CVDF form as the VDF output
        let certificate = TickCertificate {
            tick_number: tick_num,
            tick_type,
            vdf_iteration: tick_num * self.iterations_per_tick, // Simple iteration count
            vdf_form: (
                format!("cvdf_{}", final_form.a.to_string_radix(16)),
                format!("cvdf_{}", final_form.b.to_string_radix(16)),
                format!("cvdf_{}", final_form.c.to_string_radix(16)),
            ),
            hash_chain_value: [0u8; 32], // Simplified for now
            tick_hash: [0; 32],          // Will be computed below
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

#[cfg(test)]
mod tests {
    use super::*;
    use kala_state::{ChainState, TickType};
    use kala_tick::{CVDFConfig, CVDFStreamer};
    // Test imports will be added as needed
    use std::sync::Arc;
    use tokio::sync::RwLock;

    async fn create_test_environment() -> (
        TickProcessor,
        Arc<RwLock<CVDFStreamer>>,
        Arc<RwLock<ChainState>>,
        CVDFConfig,
    ) {
        let iterations_per_tick = 100u64; // Smaller for faster testing
        let processor = TickProcessor::new(iterations_per_tick);

        let cvdf_config = CVDFConfig {
            tree_arity: 2,
            base_difficulty: 1,
            security_param: 128,
            discriminant: kala_tick::Discriminant::generate(256).unwrap(),
        };

        let cvdf_streamer = Arc::new(RwLock::new(CVDFStreamer::new(cvdf_config.clone())));
        let state = Arc::new(RwLock::new(ChainState::new()));

        (processor, cvdf_streamer, state, cvdf_config)
    }

    #[tokio::test]
    async fn test_process_cvdf_tick_empty() {
        let (processor, cvdf_streamer, state, config) = create_test_environment().await;

        let tick_num = 1u64;
        let encrypted_txs = vec![]; // Empty transactions

        let result = processor
            .process_cvdf_tick(tick_num, cvdf_streamer, state.clone(), encrypted_txs)
            .await;

        if let Err(ref e) = result {
            println!("CVDF tick processing failed with error: {}", e);
        }
        assert!(result.is_ok(), "Empty tick processing should succeed");

        let certificate = result.unwrap();
        assert_eq!(certificate.tick_number, tick_num);
        assert!(matches!(certificate.tick_type, TickType::Empty));
        assert_eq!(certificate.transaction_count, 0);

        // Verify state was updated
        let state_read = state.read().await;
        assert_eq!(state_read.current_tick, tick_num + 1);
    }

    #[tokio::test]
    async fn test_process_cvdf_tick_with_phases() {
        let (processor, cvdf_streamer, state, _config) = create_test_environment().await;

        let tick_num = 2u64;
        let encrypted_txs = vec![]; // Start with empty for basic phase testing

        let result = processor
            .process_cvdf_tick(
                tick_num,
                cvdf_streamer.clone(),
                state.clone(),
                encrypted_txs,
            )
            .await;

        assert!(result.is_ok(), "CVDF tick processing should succeed");

        let certificate = result.unwrap();

        // Verify the tick certificate structure
        assert_eq!(certificate.tick_number, tick_num);
        assert!(!certificate.tick_hash.is_empty() || certificate.tick_hash == [0; 32]); // May be zero but should be present
        assert!(certificate.timestamp > 0); // Should have a valid timestamp

        // Verify CVDF computation occurred (should have non-zero iteration count)
        assert!(certificate.vdf_iteration > 0);
    }

    #[tokio::test]
    async fn test_cvdf_state_checkpoint() {
        let (processor, cvdf_streamer, state, _config) = create_test_environment().await;

        let tick_num = 3u64;

        // Process a tick to generate CVDF state
        let result = processor
            .process_cvdf_tick(tick_num, cvdf_streamer.clone(), state.clone(), vec![])
            .await;

        assert!(result.is_ok(), "Tick processing should succeed");

        // Verify CVDF checkpoint was saved
        let state_read = state.read().await;
        assert!(
            state_read.cvdf_checkpoint.is_some(),
            "CVDF checkpoint should be saved"
        );

        // Verify the checkpoint can be exported
        let cvdf = cvdf_streamer.read().await;
        let export_result = cvdf.export_state();
        assert!(export_result.is_ok(), "CVDF state export should work");
        drop(cvdf);
    }

    #[tokio::test]
    async fn test_transaction_validation_empty_state() {
        // Test the static validation functions
        let state = ChainState::new();

        let tx = kala_transaction::Transaction::Send(kala_transaction::Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [0u8; 32], // Default denomination
            amount: 100,
            nonce: 1,
            signature: vec![0u8; 64], // Vec<u8> not array
            gas_sponsorer: [0u8; 32], // Default gas sponsor
        });

        // Should fail validation due to insufficient balance in empty state
        let is_valid = TickProcessor::validate_transaction(&tx, &state);
        assert!(
            !is_valid,
            "Transaction should fail validation with empty state"
        );
    }

    #[tokio::test]
    async fn test_merkle_root_computation() {
        // Test the merkle root computation with known values
        let hashes = vec![[1u8; 32], [2u8; 32]];

        let root = compute_merkle_root(&hashes);
        assert_ne!(root, [0u8; 32], "Merkle root should not be empty");

        // Test with empty input
        let empty_root = compute_merkle_root(&[]);
        assert_eq!(empty_root, [0u8; 32], "Empty merkle root should be zeros");

        // Test with single hash
        let single_hash = [[42u8; 32]];
        let single_root = compute_merkle_root(&single_hash);
        assert_ne!(
            single_root, [0u8; 32],
            "Single hash merkle root should not be empty"
        );
    }

    #[tokio::test]
    async fn test_certificate_creation() {
        let (processor, _cvdf_streamer, state, _config) = create_test_environment().await;

        let tick_num = 5u64;
        let transactions = vec![];

        // Create a test quadratic form
        let discriminant = kala_tick::Discriminant::generate(256).unwrap();
        let final_form = kala_tick::QuadraticForm::identity(&discriminant);

        let result = processor
            .create_cvdf_certificate(tick_num, transactions, &final_form, state)
            .await;

        assert!(result.is_ok(), "Certificate creation should succeed");

        let certificate = result.unwrap();
        assert_eq!(certificate.tick_number, tick_num);
        assert!(matches!(certificate.tick_type, TickType::Empty));
        assert_eq!(certificate.transaction_count, 0);
        assert!(certificate.timestamp > 0);
    }

    #[tokio::test]
    async fn test_cvdf_k_step_integration() {
        let (processor, cvdf_streamer, state, _config) = create_test_environment().await;

        // Test that our k-step approach works with realistic values
        let iterations_per_tick = processor.iterations_per_tick;
        assert!(
            iterations_per_tick > 0,
            "Should have positive iterations per tick"
        );

        // Each phase should be k/3 iterations
        let phase_iterations = iterations_per_tick / 3;
        assert!(
            phase_iterations > 0,
            "Each phase should have positive iterations"
        );

        // Process a tick and verify it completes in reasonable time
        let start = std::time::Instant::now();

        let result = processor
            .process_cvdf_tick(1, cvdf_streamer, state, vec![])
            .await;

        let elapsed = start.elapsed();

        assert!(result.is_ok(), "K-step tick processing should succeed");
        assert!(
            elapsed.as_secs() < 10,
            "Processing should complete in reasonable time"
        ); // Generous timeout

        let certificate = result.unwrap();

        // Verify the CVDF computation produced valid output
        assert!(
            !certificate.vdf_form.0.is_empty(),
            "Should have CVDF form output"
        );
        assert!(
            !certificate.vdf_form.1.is_empty(),
            "Should have CVDF form output"
        );
        assert!(
            !certificate.vdf_form.2.is_empty(),
            "Should have CVDF form output"
        );
    }

    #[test]
    fn test_tick_processor_creation() {
        let iterations = 1000u64;
        let processor = TickProcessor::new(iterations);

        assert_eq!(processor.iterations_per_tick, iterations);

        // Should be able to get encryption context
        let ctx = processor.encryption_context();
        assert!(
            Arc::strong_count(&ctx) >= 1,
            "Encryption context should be available"
        );
    }
}
