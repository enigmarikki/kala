// encrypted.rs - Encryption module for kala-transaction

use crate::types::{
    Nonce96Array, RSWPuzzle, SealedTransaction, Tag128Array, TimelockTransaction,
    Transaction, AES_KEY_SIZE, TAG_SIZE,
};
use kala_common::prelude::{KalaResult, KalaError};
use aes_gcm::{
    aead::{Aead, AeadCore, KeyInit, OsRng},
    Aes256Gcm, Key, Nonce,
};
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
    let plaintext = crate::decrypted::transaction_to_flatbuffer(tx)?;

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
        .map_err(|e| {
            KalaError::crypto(format!("AES-GCM encryption failed: {e}"))
        })?;

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
        .map_err(|e| {
            KalaError::crypto(format!("AES-GCM decryption failed: {e}"))
        })?;

    // Deserialize from FlatBuffer
    crate::decrypted::flatbuffer_to_transaction(&plaintext)
}

/// RSW Timelock implementation for MEV protection using GPU acceleration
pub struct RSWTimelock {
    solver: Solver,
    modulus_bits: usize,
}

impl RSWTimelock {
    pub fn new(modulus_bits: usize) -> KalaResult<Self> {
        // Try to create GPU solver, fall back to CPU if not available
        let solver = Solver::default().or_else(|_| Solver::new(0)).map_err(|e| {
            KalaError::crypto(format!("Failed to create RSW solver: {e}"))
        })?;

        Ok(Self {
            solver,
            modulus_bits,
        })
    }

    /// Generate RSW puzzle parameters
    pub fn generate_puzzle(&self, key: &[u8; AES_KEY_SIZE], hardness: u32) -> KalaResult<RSWPuzzle> {
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

        let results = self.solver.solve_batch(&puzzle_inputs).map_err(|e| {
            KalaError::crypto(format!("Batch RSW solve failed: {e}"))
        })?;

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
pub fn decrypt_timelock_batch(timelock_txs: &[TimelockTransaction]) -> KalaResult<Vec<Transaction>> {
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
    use crate::types::{Send, Transaction};

    #[test]
    fn test_encrypt_decrypt_transaction() {
        let tx = Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: 1000,
            nonce: 1,
            signature: [0u8; 64].to_vec(),
            gas_sponsorer: [0u8; 32],
        });

        let key = [42u8; AES_KEY_SIZE];

        let sealed = encrypt_transaction(&tx, &key).unwrap();
        let decrypted = decrypt_transaction(&sealed, &key).unwrap();

        match (&tx, &decrypted) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.sender, b.sender);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }
}
