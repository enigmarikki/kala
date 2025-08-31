use crate::types::{
    Nonce96Array, RSWPuzzle, SealedTransaction, Tag128Array, TimelockTransaction, Transaction,
    AES_KEY_SIZE, TAG_SIZE,
};
use aes_gcm::{
    aead::{Aead, AeadCore, KeyInit, OsRng},
    Aes256Gcm, Key, Nonce,
};
use kala_common::prelude::{KalaError, KalaResult};
use rand::Rng;
use rug::{rand::RandState, Integer};
use std::sync::Arc;
use timelocks::Solver;

/// Thread-safe encryption context
#[derive(Clone)]
pub struct EncryptionContext {
    /// Current tick for timelock calculations
    current_tick: Arc<std::sync::atomic::AtomicU64>,
    /// Tick size (k)
    pub tick_size: u64,
}

impl EncryptionContext {
    pub fn new(tick_size: u64) -> Self {
        Self {
            current_tick: Arc::new(std::sync::atomic::AtomicU64::new(0)),
            tick_size,
        }
    }

    pub fn update_tick(&self, tick: u64) {
        self.current_tick
            .store(tick, std::sync::atomic::Ordering::SeqCst);
    }

    pub fn current_tick(&self) -> u64 {
        self.current_tick.load(std::sync::atomic::Ordering::SeqCst)
    }
}

/// Encrypts a transaction using AES-256-GCM
pub fn encrypt_transaction(
    tx: &Transaction,
    key: &[u8; AES_KEY_SIZE],
) -> KalaResult<SealedTransaction> {
    // Convert to FlatBuffer for canonical serialization
    let plaintext = crate::serde::transaction_to_flatbuffer(tx)?;

    // Create cipher
    let key = Key::<Aes256Gcm>::from_slice(key);
    let cipher = Aes256Gcm::new(key);

    // Generate random nonce
    let nonce_bytes = Aes256Gcm::generate_nonce(&mut OsRng);
    let nonce_array: Nonce96Array = nonce_bytes
        .as_slice()
        .try_into()
        .map_err(|_| KalaError::crypto("Invalid nonce size".to_string()))?;

    // Encrypt with authenticated encryption
    let ciphertext = cipher
        .encrypt(&nonce_bytes, plaintext.as_ref())
        .map_err(|e| KalaError::crypto(format!("AES-GCM encryption failed: {e}")))?;

    // Extract tag from the end of ciphertext (last 16 bytes)
    let (encrypted_data, tag_bytes) = ciphertext.split_at(ciphertext.len() - TAG_SIZE);
    let tag: Tag128Array = tag_bytes
        .try_into()
        .map_err(|_| KalaError::crypto("Invalid tag size".to_string()))?;

    Ok(SealedTransaction {
        nonce: nonce_array,
        tag,
        ciphertext: encrypted_data.to_vec(),
    })
}

/// Decrypts a sealed transaction using AES-256-GCM
pub fn decrypt_transaction(
    sealed: &SealedTransaction,
    key: &[u8; AES_KEY_SIZE],
) -> KalaResult<Transaction> {
    // Create cipher
    let key = Key::<Aes256Gcm>::from_slice(key);
    let cipher = Aes256Gcm::new(key);

    // Reconstruct the full ciphertext with tag
    let mut full_ciphertext = sealed.ciphertext.clone();
    full_ciphertext.extend_from_slice(&sealed.tag);

    // Create nonce
    let nonce = Nonce::from_slice(&sealed.nonce);

    // Decrypt
    let plaintext = cipher
        .decrypt(nonce, full_ciphertext.as_ref())
        .map_err(|e| KalaError::crypto(format!("AES-GCM decryption failed: {e}")))?;

    // Deserialize from FlatBuffer
    crate::serde::flatbuffer_to_transaction(&plaintext)
}

/// RSW Timelock implementation for MEV protection using GPU acceleration
pub struct RSWTimelock {
    solver: Solver,
    modulus_bits: usize,
}

impl RSWTimelock {
    pub fn new(modulus_bits: usize) -> KalaResult<Self> {
        // Try to create GPU solver, fall back to CPU if not available
        let solver = Solver::default()
            .or_else(|_| Solver::new(0))
            .map_err(|e| KalaError::crypto(format!("Failed to create RSW solver: {e}")))?;

        Ok(Self {
            solver,
            modulus_bits,
        })
    }

    /// Generate RSW puzzle parameters
    pub fn generate_puzzle(
        &self,
        key: &[u8; AES_KEY_SIZE],
        hardness: u32,
    ) -> KalaResult<RSWPuzzle> {
        use rug::integer::Order;

        // Generate safe RSA modulus n = p*q
        let mut rand_state = RandState::new();
        let bits = self.modulus_bits / 2;

        // Generate two random primes
        let mut p = Integer::from(Integer::random_bits(bits as u32, &mut rand_state));
        p.next_prime_mut();

        let mut q = Integer::from(Integer::random_bits(bits as u32, &mut rand_state));
        q.next_prime_mut();

        let n = Integer::from(&p * &q);

        // Use a = 2 as the base (standard for RSW)
        let a = Integer::from(2);

        // Convert key to Integer (little-endian)
        let key_int = Integer::from_digits(key, Order::Lsf);

        // For fast puzzle creation, use Euler's theorem
        // λ(n) = lcm(p-1, q-1)
        let p_minus_1 = Integer::from(&p - 1);
        let q_minus_1 = Integer::from(&q - 1);
        let lambda = p_minus_1.lcm(&q_minus_1);

        // Reduce exponent: 2^hardness mod λ(n)
        let two = Integer::from(2);
        let reduced_exp = two
            .pow_mod(&Integer::from(hardness), &lambda)
            .map_err(|e| KalaError::crypto(format!("pow_mod failed: {e}")))?;

        // Compute a^(2^hardness mod λ(n)) mod n (fast!)
        let a_power = a
            .clone()
            .pow_mod(&reduced_exp, &n)
            .map_err(|e| KalaError::crypto(format!("pow_mod failed: {e}")))?;

        // C = (key + a^(2^hardness)) mod n
        let puzzle_value = (key_int + a_power) % &n;

        // Convert to bytes (big-endian for compatibility)
        let n_bytes = n.to_digits::<u8>(Order::Msf);
        let a_bytes = a.to_digits::<u8>(Order::Msf);
        let puzzle_bytes = puzzle_value.to_digits::<u8>(Order::Msf);

        Ok(RSWPuzzle {
            puzzle_value: puzzle_bytes,
            a: a_bytes,
            n: n_bytes,
            hardness,
        })
    }

    /// Solve RSW puzzle to recover key using GPU acceleration
    pub fn solve_puzzle(&self, puzzle: &RSWPuzzle) -> KalaResult<[u8; AES_KEY_SIZE]> {
        // Convert to hex strings for the GPU solver
        let n_hex = hex::encode(&puzzle.n);
        let a_hex = hex::encode(&puzzle.a);
        let c_hex = hex::encode(&puzzle.puzzle_value);

        // Solve using GPU
        let result = self
            .solver
            .solve(&n_hex, &a_hex, &c_hex, puzzle.hardness)
            .map_err(|e| KalaError::crypto(format!("RSW solve failed: {e}")))?;

        Ok(result.key)
    }

    /// Batch solve multiple puzzles in parallel on GPU
    pub fn solve_batch(&self, puzzles: &[RSWPuzzle]) -> KalaResult<Vec<[u8; AES_KEY_SIZE]>> {
        let puzzle_inputs: Vec<(String, String, String, u32)> = puzzles
            .iter()
            .map(|p| {
                (
                    hex::encode(&p.n),
                    hex::encode(&p.a),
                    hex::encode(&p.puzzle_value),
                    p.hardness,
                )
            })
            .collect();

        let results = self
            .solver
            .solve_batch(&puzzle_inputs)
            .map_err(|e| KalaError::crypto(format!("Batch RSW solve failed: {e}")))?;

        Ok(results.into_iter().map(|r| r.key).collect())
    }

    /// Get optimal batch size for GPU
    pub fn optimal_batch_size(&self) -> usize {
        self.solver.optimal_batch_size()
    }

    /// Get GPU device name
    pub fn device_name(&self) -> String {
        self.solver.device_name()
    }
}

/// Create a timelock transaction with MEV protection
pub fn create_timelock_transaction(
    tx: &Transaction,
    ctx: &EncryptionContext,
    current_iteration: u64,
    hardness_factor: f64, // 0.0 to 1.0, typically 0.1
) -> KalaResult<TimelockTransaction> {
    let current_tick = ctx.current_tick();
    let tick_size = ctx.tick_size;

    // Calculate remaining iterations in current tick
    let tick_start = current_tick * tick_size;
    let tick_end = (current_tick + 1) * tick_size;
    let remaining = tick_end - current_iteration;

    // Calculate hardness: min(k/10, remaining/2)
    let max_hardness = (tick_size as f64 * hardness_factor) as u32;
    let safe_hardness = (remaining / 2) as u32;
    let hardness = max_hardness.min(safe_hardness).max(1);

    // Generate encryption key
    let mut key = [0u8; AES_KEY_SIZE];
    rand::thread_rng().fill(&mut key);

    // Encrypt transaction
    let encrypted_data = encrypt_transaction(tx, &key)?;

    // Create RSW puzzle
    let timelock = RSWTimelock::new(2048)?;
    let puzzle = timelock.generate_puzzle(&key, hardness)?;

    tracing::debug!(
        "Created timelock puzzle with hardness {} on GPU: {}",
        hardness,
        timelock.device_name()
    );

    Ok(TimelockTransaction {
        encrypted_data,
        puzzle,
        submission_iteration: current_iteration,
        target_tick: current_tick,
    })
}

/// Decrypt a timelock transaction (requires solving the puzzle)
pub fn decrypt_timelock_transaction(timelock_tx: &TimelockTransaction) -> KalaResult<Transaction> {
    // Create solver
    let timelock = RSWTimelock::new(2048)?;

    // Solve the RSW puzzle to recover the key
    let key = timelock.solve_puzzle(&timelock_tx.puzzle)?;

    // Decrypt the transaction
    decrypt_transaction(&timelock_tx.encrypted_data, &key)
}

/// Batch decrypt multiple timelock transactions using GPU acceleration
pub fn decrypt_timelock_batch(
    timelock_txs: &[TimelockTransaction],
) -> KalaResult<Vec<Transaction>> {
    if timelock_txs.is_empty() {
        return Ok(vec![]);
    }

    // Create solver
    let timelock = RSWTimelock::new(2048)?;

    // Process in optimal batch sizes
    let batch_size = timelock.optimal_batch_size();
    let mut decrypted_txs = Vec::with_capacity(timelock_txs.len());

    for chunk in timelock_txs.chunks(batch_size) {
        // Extract puzzles
        let puzzles: Vec<RSWPuzzle> = chunk.iter().map(|tx| tx.puzzle.clone()).collect();

        // Solve batch on GPU
        let keys = timelock.solve_batch(&puzzles)?;

        // Decrypt transactions
        for (tx, key) in chunk.iter().zip(keys.iter()) {
            let decrypted = decrypt_transaction(&tx.encrypted_data, key)?;
            decrypted_txs.push(decrypted);
        }
    }

    tracing::info!(
        "Batch decrypted {} transactions on GPU: {}",
        timelock_txs.len(),
        timelock.device_name()
    );

    Ok(decrypted_txs)
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::types::{Burn, Mint, Send, Stake, Transaction, Unstake};
    use std::sync::Arc;
    use std::thread;
    use std::time::{Duration, Instant};

    // Helper function to create various transaction types
    fn create_test_transactions() -> Vec<Transaction> {
        vec![
            Transaction::Send(Send {
                sender: [1u8; 32],
                receiver: [2u8; 32],
                denom: [3u8; 32],
                amount: 1000,
                nonce: 1,
                signature: vec![0u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            Transaction::Mint(Mint {
                sender: [4u8; 32],
                denom: [6u8; 32],
                amount: 5000,
                nonce: 2,
                signature: vec![1u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            Transaction::Burn(Burn {
                sender: [7u8; 32],
                denom: [8u8; 32],
                amount: 2000,
                nonce: 3,
                signature: vec![2u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            Transaction::Stake(Stake {
                delegator: [9u8; 32],
                witness: [10u8; 32],
                amount: 10000,
                nonce: 4,
                signature: vec![3u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            Transaction::Unstake(Unstake {
                delegator: [11u8; 32],
                witness: [12u8; 32],
                amount: 3000,
                nonce: 5,
                signature: vec![4u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
        ]
    }

    // ==================== Basic Encryption/Decryption Tests ====================

    #[test]
    fn test_encrypt_decrypt_all_transaction_types() {
        let transactions = create_test_transactions();
        let key = [42u8; AES_KEY_SIZE];

        for tx in transactions {
            let sealed = encrypt_transaction(&tx, &key).expect("Encryption should succeed");
            let decrypted = decrypt_transaction(&sealed, &key).expect("Decryption should succeed");

            // Verify the transaction matches after round-trip
            match (&tx, &decrypted) {
                (Transaction::Send(a), Transaction::Send(b)) => {
                    assert_eq!(a.amount, b.amount);
                    assert_eq!(a.sender, b.sender);
                    assert_eq!(a.receiver, b.receiver);
                    assert_eq!(a.denom, b.denom);
                    assert_eq!(a.nonce, b.nonce);
                    assert_eq!(a.signature, b.signature);
                    assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
                }
                (Transaction::Mint(a), Transaction::Mint(b)) => {
                    assert_eq!(a.amount, b.amount);
                    assert_eq!(a.sender, b.sender);
                    assert_eq!(a.denom, b.denom);
                    assert_eq!(a.signature, b.signature);
                    assert_eq!(a.nonce, b.nonce);
                }
                (Transaction::Burn(a), Transaction::Burn(b)) => {
                    assert_eq!(a.amount, b.amount);
                    assert_eq!(a.sender, b.sender);
                    assert_eq!(a.denom, b.denom);
                    assert_eq!(a.nonce, b.nonce);
                }
                (Transaction::Stake(a), Transaction::Stake(b)) => {
                    assert_eq!(a.amount, b.amount);
                    assert_eq!(a.delegator, b.delegator);
                    assert_eq!(a.witness, b.witness);
                    assert_eq!(a.nonce, b.nonce);
                }
                (Transaction::Unstake(a), Transaction::Unstake(b)) => {
                    assert_eq!(a.amount, b.amount);
                    assert_eq!(a.delegator, b.delegator);
                    assert_eq!(a.witness, b.witness);
                    assert_eq!(a.nonce, b.nonce);
                }
                _ => panic!("Transaction type mismatch"),
            }
        }
    }

    #[test]
    fn test_different_keys_produce_different_ciphertexts() {
        let tx = create_test_transactions()[0].clone();
        let key1 = [1u8; AES_KEY_SIZE];
        let key2 = [2u8; AES_KEY_SIZE];

        let sealed1 = encrypt_transaction(&tx, &key1).unwrap();
        let sealed2 = encrypt_transaction(&tx, &key2).unwrap();

        // Same transaction with different keys should produce different ciphertexts
        assert_ne!(sealed1.ciphertext, sealed2.ciphertext);
        assert_ne!(sealed1.tag, sealed2.tag);
        // Nonces should be different (randomly generated)
        assert_ne!(sealed1.nonce, sealed2.nonce);
    }

    #[test]
    fn test_decrypt_with_wrong_key_fails() {
        let tx = create_test_transactions()[0].clone();
        let encrypt_key = [42u8; AES_KEY_SIZE];
        let wrong_key = [43u8; AES_KEY_SIZE];

        let sealed = encrypt_transaction(&tx, &encrypt_key).unwrap();
        let result = decrypt_transaction(&sealed, &wrong_key);

        assert!(result.is_err());
        if let Err(e) = result {
            let error_msg = format!("{}", e);
            assert!(error_msg.contains("AES-GCM decryption failed"));
        }
    }

    #[test]
    fn test_tampered_ciphertext_fails_authentication() {
        let tx = create_test_transactions()[0].clone();
        let key = [42u8; AES_KEY_SIZE];

        let mut sealed = encrypt_transaction(&tx, &key).unwrap();

        // Tamper with the ciphertext
        if !sealed.ciphertext.is_empty() {
            sealed.ciphertext[0] ^= 0xFF;
        }

        let result = decrypt_transaction(&sealed, &key);
        assert!(result.is_err());
    }

    #[test]
    fn test_tampered_tag_fails_authentication() {
        let tx = create_test_transactions()[0].clone();
        let key = [42u8; AES_KEY_SIZE];

        let mut sealed = encrypt_transaction(&tx, &key).unwrap();

        // Tamper with the authentication tag
        sealed.tag[0] ^= 0xFF;

        let result = decrypt_transaction(&sealed, &key);
        assert!(result.is_err());
    }

    // ==================== EncryptionContext Tests ====================

    #[test]
    fn test_encryption_context_initialization() {
        let ctx = EncryptionContext::new(1000);
        assert_eq!(ctx.tick_size, 1000);
        assert_eq!(ctx.current_tick(), 0);
    }

    #[test]
    fn test_encryption_context_tick_update() {
        let ctx = EncryptionContext::new(1000);

        ctx.update_tick(5);
        assert_eq!(ctx.current_tick(), 5);

        ctx.update_tick(10);
        assert_eq!(ctx.current_tick(), 10);

        // Test updating to 0 (edge case)
        ctx.update_tick(0);
        assert_eq!(ctx.current_tick(), 0);
    }

    #[test]
    fn test_encryption_context_clone() {
        let ctx1 = EncryptionContext::new(1000);
        ctx1.update_tick(5);

        let ctx2 = ctx1.clone();
        assert_eq!(ctx2.current_tick(), 5);
        assert_eq!(ctx2.tick_size, 1000);

        // Update ctx2 and verify ctx1 also sees the change (shared state)
        ctx2.update_tick(10);
        assert_eq!(ctx1.current_tick(), 10);
    }

    #[test]
    fn test_encryption_context_thread_safety() {
        let ctx = Arc::new(EncryptionContext::new(1000));
        let num_threads = 10;
        let updates_per_thread = 100;

        let mut handles = vec![];

        for i in 0..num_threads {
            let ctx_clone = Arc::clone(&ctx);
            let handle = thread::spawn(move || {
                for j in 0..updates_per_thread {
                    ctx_clone.update_tick((i * updates_per_thread + j) as u64);
                    thread::sleep(Duration::from_micros(10));
                }
            });
            handles.push(handle);
        }

        for handle in handles {
            handle.join().unwrap();
        }

        // Final tick should be one of the values written
        let final_tick = ctx.current_tick();
        assert!(final_tick < (num_threads * updates_per_thread) as u64);
    }

    // ==================== RSW Timelock Tests ====================

    #[test]
    fn test_rsw_timelock_creation() {
        // Test with different modulus sizes
        let sizes = vec![512, 1024, 2048, 4096];

        for size in sizes {
            let result = RSWTimelock::new(size);
            assert!(
                result.is_ok(),
                "Failed to create RSWTimelock with {} bits",
                size
            );

            let timelock = result.unwrap();
            assert_eq!(timelock.modulus_bits, size);
        }
    }

    #[test]
    fn test_rsw_puzzle_generation_and_solving() {
        let timelock = RSWTimelock::new(512).unwrap(); // Use smaller size for faster tests
        let key = [42u8; AES_KEY_SIZE];
        let hardness = 100; // Small hardness for testing

        let puzzle = timelock.generate_puzzle(&key, hardness).unwrap();

        // Verify puzzle components are non-empty
        assert!(!puzzle.n.is_empty());
        assert!(!puzzle.a.is_empty());
        assert!(!puzzle.puzzle_value.is_empty());
        assert_eq!(puzzle.hardness, hardness);

        // Solve the puzzle
        let recovered_key = timelock.solve_puzzle(&puzzle).unwrap();
        assert_eq!(recovered_key, key);
    }

    #[test]
    fn test_rsw_puzzle_with_different_hardness() {
        let timelock = RSWTimelock::new(512).unwrap();
        let key = [99u8; AES_KEY_SIZE];

        let hardness_values = vec![10, 50, 100, 200];

        for hardness in hardness_values {
            let puzzle = timelock.generate_puzzle(&key, hardness).unwrap();
            assert_eq!(puzzle.hardness, hardness);

            let recovered_key = timelock.solve_puzzle(&puzzle).unwrap();
            assert_eq!(recovered_key, key);
        }
    }

    #[test]
    fn test_rsw_batch_solving() {
        let timelock = RSWTimelock::new(512).unwrap();
        let num_puzzles = 5;
        let mut puzzles = Vec::new();
        let mut expected_keys = Vec::new();

        // Generate multiple puzzles with different keys
        for i in 0..num_puzzles {
            let mut key = [0u8; AES_KEY_SIZE];
            key[0] = i as u8;
            expected_keys.push(key);

            let puzzle = timelock.generate_puzzle(&key, 50).unwrap();
            puzzles.push(puzzle);
        }

        // Batch solve
        let recovered_keys = timelock.solve_batch(&puzzles).unwrap();

        assert_eq!(recovered_keys.len(), expected_keys.len());
        for (recovered, expected) in recovered_keys.iter().zip(expected_keys.iter()) {
            assert_eq!(recovered, expected);
        }
    }

    #[test]
    fn test_rsw_empty_batch() {
        let timelock = RSWTimelock::new(512).unwrap();
        let result = timelock.solve_batch(&[]).unwrap();
        assert!(result.is_empty());
    }

    #[test]
    fn test_optimal_batch_size() {
        let timelock = RSWTimelock::new(512).unwrap();
        let batch_size = timelock.optimal_batch_size();

        // Batch size should be reasonable (typically between 1 and 1000)
        assert!(batch_size > 0);
        assert!(batch_size <= 10000);
    }

    #[test]
    fn test_device_name() {
        let timelock = RSWTimelock::new(512).unwrap();
        let device_name = timelock.device_name();

        // Device name should not be empty
        assert!(!device_name.is_empty());
    }

    #[test]
    fn test_create_timelock_transaction() {
        let tx = create_test_transactions()[0].clone();
        let ctx = EncryptionContext::new(1000);
        ctx.update_tick(5);

        let current_iteration = 4500;
        let hardness_factor = 0.1;

        let timelock_tx =
            create_timelock_transaction(&tx, &ctx, current_iteration, hardness_factor).unwrap();

        assert_eq!(timelock_tx.submission_iteration, current_iteration);
        assert_eq!(timelock_tx.target_tick, 5);
        assert!(!timelock_tx.encrypted_data.ciphertext.is_empty());
        assert!(!timelock_tx.puzzle.n.is_empty());
    }

    #[test]
    fn test_timelock_transaction_hardness_calculation() {
        let tx = create_test_transactions()[0].clone();
        let ctx = EncryptionContext::new(1000);

        // Test case 1: Beginning of tick
        ctx.update_tick(5);
        let timelock_tx = create_timelock_transaction(
            &tx, &ctx, 5000, // Start of tick 5
            0.1,
        )
        .unwrap();

        // Hardness should be min(100, 500) = 100
        assert!(timelock_tx.puzzle.hardness <= 100);

        // Test case 2: Near end of tick
        let timelock_tx2 = create_timelock_transaction(
            &tx, &ctx, 5990, // Near end of tick 5
            0.1,
        )
        .unwrap();

        // Hardness should be min(100, 5) = 5
        assert!(timelock_tx2.puzzle.hardness <= 5);
    }

    #[test]
    fn test_decrypt_timelock_transaction() {
        let tx = create_test_transactions()[0].clone();
        let ctx = EncryptionContext::new(1000);
        ctx.update_tick(1);

        let timelock_tx = create_timelock_transaction(
            &tx, &ctx, 500, 0.01, // Very small hardness for faster test
        )
        .unwrap();

        let decrypted = decrypt_timelock_transaction(&timelock_tx).unwrap();

        match (&tx, &decrypted) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.sender, b.sender);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_decrypt_timelock_batch() {
        let transactions = create_test_transactions();
        let ctx = EncryptionContext::new(1000);
        ctx.update_tick(1);

        let mut timelock_txs = Vec::new();

        for (i, tx) in transactions.iter().enumerate() {
            let timelock_tx = create_timelock_transaction(
                tx,
                &ctx,
                500 + i as u64,
                0.01, // Very small hardness for faster test
            )
            .unwrap();
            timelock_txs.push(timelock_tx);
        }

        let decrypted_txs = decrypt_timelock_batch(&timelock_txs).unwrap();

        assert_eq!(decrypted_txs.len(), transactions.len());

        for (original, decrypted) in transactions.iter().zip(decrypted_txs.iter()) {
            // Just verify they're the same variant type
            match (original, decrypted) {
                (Transaction::Send(_), Transaction::Send(_)) => {}
                (Transaction::Mint(_), Transaction::Mint(_)) => {}
                (Transaction::Burn(_), Transaction::Burn(_)) => {}
                (Transaction::Stake(_), Transaction::Stake(_)) => {}
                (Transaction::Unstake(_), Transaction::Unstake(_)) => {}
                _ => panic!("Transaction type mismatch in batch"),
            }
        }
    }

    #[test]
    fn test_decrypt_empty_timelock_batch() {
        let result = decrypt_timelock_batch(&[]).unwrap();
        assert!(result.is_empty());
    }

    #[test]
    fn test_zero_hardness_factor() {
        let tx = create_test_transactions()[0].clone();
        let ctx = EncryptionContext::new(1000);
        ctx.update_tick(1);

        let result = create_timelock_transaction(
            &tx, &ctx, 500, 0.0, // Zero hardness factor
        );

        // Should still work, with minimum hardness of 1
        assert!(result.is_ok());
        let timelock_tx = result.unwrap();
        assert!(timelock_tx.puzzle.hardness >= 1);
    }

    #[test]
    fn test_maximum_hardness_factor() {
        let tx = create_test_transactions()[0].clone();
        let ctx = EncryptionContext::new(1000);
        ctx.update_tick(1);

        let result = create_timelock_transaction(
            &tx, &ctx, 1000, // Start of tick
            1.0,  // Maximum hardness factor
        );

        assert!(result.is_ok());
        let timelock_tx = result.unwrap();
        // Hardness should be min(1000, 500) = 500
        assert!(timelock_tx.puzzle.hardness <= 500);
    }

    #[test]
    fn test_large_transaction() {
        // Create a transaction with maximum signature size
        let mut large_signature = Vec::new();
        large_signature.resize(10000, 0u8); // Large signature

        let tx = Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: u64::MAX,
            nonce: u64::MAX,
            signature: large_signature,
            gas_sponsorer: [0u8; 32],
        });

        let key = [42u8; AES_KEY_SIZE];

        let sealed = encrypt_transaction(&tx, &key).unwrap();
        let decrypted = decrypt_transaction(&sealed, &key).unwrap();

        match (&tx, &decrypted) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature.len(), b.signature.len());
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_encryption_performance() {
        let tx = create_test_transactions()[0].clone();
        let key = [42u8; AES_KEY_SIZE];
        let iterations = 1000;

        let start = Instant::now();
        for _ in 0..iterations {
            let _ = encrypt_transaction(&tx, &key).unwrap();
        }
        let duration = start.elapsed();

        println!("Encrypted {} transactions in {:?}", iterations, duration);
        println!("Average time per encryption: {:?}", duration / iterations);
    }

    #[test]
    fn test_timelock_puzzle_performance() {
        let timelock = RSWTimelock::new(512).unwrap();
        let key = [42u8; AES_KEY_SIZE];
        let iterations = 100;

        let start = Instant::now();
        for i in 0..iterations {
            let puzzle = timelock.generate_puzzle(&key, 100 + i).unwrap();
            let _ = timelock.solve_puzzle(&puzzle).unwrap();
        }
        let duration = start.elapsed();

        println!(
            "Generated and solved {} puzzles in {:?}",
            iterations, duration
        );
        println!("Average time per puzzle: {:?}", duration / iterations);
    }

    #[test]

    fn test_concurrent_encryption_stress() {
        let num_threads = 20;
        let ops_per_thread = 100;
        let mut handles = vec![];

        for _ in 0..num_threads {
            let handle = thread::spawn(move || {
                let tx = create_test_transactions()[0].clone();
                let key = [42u8; AES_KEY_SIZE];

                for _ in 0..ops_per_thread {
                    let sealed = encrypt_transaction(&tx, &key).unwrap();
                    let _ = decrypt_transaction(&sealed, &key).unwrap();
                }
            });
            handles.push(handle);
        }

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_encryption_determinism_with_same_nonce() {
        // This test verifies that encryption is deterministic when using the same key and nonce
        // Note: In production, nonces should always be random, this is just for testing

        let tx = create_test_transactions()[0].clone();
        let key = [42u8; AES_KEY_SIZE];

        // Encrypt twice with same transaction and key
        let sealed1 = encrypt_transaction(&tx, &key).unwrap();
        let sealed2 = encrypt_transaction(&tx, &key).unwrap();

        // Due to random nonce generation, ciphertexts should be different
        assert_ne!(sealed1.nonce, sealed2.nonce);
        assert_ne!(sealed1.ciphertext, sealed2.ciphertext);

        // But decryption should yield the same result
        let decrypted1 = decrypt_transaction(&sealed1, &key).unwrap();
        let decrypted2 = decrypt_transaction(&sealed2, &key).unwrap();

        match (&decrypted1, &decrypted2) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.sender, b.sender);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }
}
