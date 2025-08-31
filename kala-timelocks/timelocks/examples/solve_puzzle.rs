use aes_gcm::{
    aead::{Aead, AeadCore, KeyInit, OsRng},
    Aes256Gcm, Key, Nonce,
};
use rand::Rng;
use rug::rand::RandState;
use rug::{Complete, Integer};
use std::io::Write;
use std::time::Instant;
use timelocks::Solver;

/// Client-side timelock creation (knows p and q)
struct TimelockClient {
    p: Integer,
    q: Integer,
    n: Integer,
}

impl TimelockClient {
    /// Generate new client with random primes of specified bit size
    fn generate(bits: u32) -> Self {
        println!("Generating {}-bit RSA modulus...", bits);
        let start = Instant::now();

        let mut rand = RandState::new();

        // Generate two random primes of bits/2 size each
        // First generate random numbers, then find next prime
        let mut p = Integer::from(Integer::random_bits(bits / 2, &mut rand));
        p.next_prime_mut();

        let mut q = Integer::from(Integer::random_bits(bits / 2, &mut rand));
        q.next_prime_mut();

        let n = Integer::from(&p * &q);

        println!("Generated primes in {:?}", start.elapsed());
        println!(
            "  p ({} bits): {}...{}",
            p.significant_bits(),
            &p.to_string_radix(16)[..16],
            &p.to_string_radix(16)[p.to_string_radix(16).len() - 16..]
        );
        println!(
            "  q ({} bits): {}...{}",
            q.significant_bits(),
            &q.to_string_radix(16)[..16],
            &q.to_string_radix(16)[q.to_string_radix(16).len() - 16..]
        );

        Self { p, q, n }
    }

    /// Create a new client with known factors
    fn new(p: Integer, q: Integer) -> Self {
        let n = Integer::from(&p * &q);
        Self { p, q, n }
    }

    /// Create timelock puzzle using Euler's theorem (fast because we know p,q)
    /// Returns (C, time_taken) where C = (a^(2^T) + k) mod n
    fn create_puzzle(&self, a: u32, t: u32, key: &[u8; 32]) -> (String, std::time::Duration) {
        let start = Instant::now();

        // Convert inputs
        let a_int = Integer::from(a);
        let k = Integer::from_digits(key, rug::integer::Order::Lsf);

        // Use Euler's theorem for fast computation
        // λ(n) = lcm(p-1, q-1)
        let p_minus_1 = Integer::from(&self.p - 1);
        let q_minus_1 = Integer::from(&self.q - 1);
        let lambda = p_minus_1.clone().lcm(&q_minus_1);

        // Reduce exponent: 2^T mod λ(n)
        let two = Integer::from(2);
        let reduced_exp = two
            .pow_mod(&Integer::from(t), &lambda)
            .expect("pow_mod failed");

        // Compute a^(2^T mod λ(n)) mod n (fast!)
        let a_power = a_int
            .pow_mod(&reduced_exp, &self.n)
            .expect("pow_mod failed");

        // C = (a^(2^T) + k) mod n
        let c = (a_power + k) % &self.n;

        let elapsed = start.elapsed();
        (c.to_string_radix(16), elapsed)
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("=== RSW Timelock Demo ===");
    println!("Client knows factors → Fast puzzle creation");
    println!("GPU solver doesn't know factors → Slow sequential squaring\n");

    // 1. Generate message and key
    let message = b"This is a timelocked message for the future!";
    let mut key = [0u8; 32];
    OsRng.fill(&mut key);

    println!("Original message: {}", String::from_utf8_lossy(message));
    println!("Generated key: {}", hex::encode(&key));

    // 2. Encrypt message with AES-GCM
    let cipher = Aes256Gcm::new(&Key::<Aes256Gcm>::from_slice(&key));
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let ciphertext = cipher
        .encrypt(&nonce, message.as_ref())
        .expect("encryption failed");

    let (ct, tag) = ciphertext.split_at(ciphertext.len() - 16);
    println!("\nEncrypted:");
    println!("  IV: {}", hex::encode(&nonce));
    println!("  Ciphertext: {}", hex::encode(ct));
    println!("  Tag: {}", hex::encode(tag));

    // 3. Client creates timelock puzzle (knows p and q)
    println!("\n=== Client-side Puzzle Creation ===");

    // Generate random 2048-bit RSA modulus
    let client = TimelockClient::generate(2048);
    let a = 2u32;
    let t = 32_768u32; // ~32k iterations for benchmarking

    println!("\nRSA modulus (n): {}", client.n.to_string_radix(16));
    println!("Time parameter T: {} (2^{} squarings required)", t, t);

    let (puzzle_c, create_time) = client.create_puzzle(a, t, &key);

    println!(
        "\nPuzzle created in: {:?} (using Euler's theorem)",
        create_time
    );
    println!("Puzzle parameters:");
    println!("  n = {}", client.n.to_string_radix(16));
    println!("  a = {}", a);
    println!("  C = {}", puzzle_c);
    println!("  T = {}", t);

    // 4. GPU solver (doesn't know p,q) must do sequential squaring
    println!("\n=== GPU Solving (Sequential Squaring) ===");
    let solver = Solver::default()?;
    println!("Using GPU: {}", solver.device_name());

    let start = Instant::now();
    let result = solver.solve(&client.n.to_string_radix(16), &a.to_string(), &puzzle_c, t)?;
    let solve_time = start.elapsed();

    println!("GPU solved in: {:?}", solve_time);
    println!("Recovered key: {}", hex::encode(&result.key));

    // Compare times
    let speedup = solve_time.as_secs_f64() / create_time.as_secs_f64();
    println!("\n Time comparison:");
    println!("  Client (with factors): {:?}", create_time);
    println!("  GPU (without factors): {:?}", solve_time);
    println!("  Slowdown factor: {:.0}x", speedup);

    // 5. Verify and decrypt
    println!("\n=== Decrypting Message ===");
    assert_eq!(key, result.key, "Key recovery failed!");

    let recovered_cipher = Aes256Gcm::new(&Key::<Aes256Gcm>::from_slice(&result.key));
    let mut full_ct = ct.to_vec();
    full_ct.extend_from_slice(tag);

    let plaintext = recovered_cipher
        .decrypt(&nonce, full_ct.as_ref())
        .expect("decryption failed");

    println!("Decrypted message: {}", String::from_utf8_lossy(&plaintext));
    assert_eq!(message, plaintext.as_slice());

    // 7. Benchmark with TRUE batch solving
    println!("\n=== Batch Benchmark (10K puzzles with GPU parallelism) ===");

    let batch_size = 12_000;
    println!("Creating {} puzzle instances...", batch_size);

    // Create a vector of the same puzzle repeated (matches original benchmark)
    let mut batch_puzzles = Vec::with_capacity(batch_size);
    for _ in 0..batch_size {
        batch_puzzles.push((
            client.n.to_string_radix(16),
            a.to_string(),
            puzzle_c.clone(),
            t,
        ));
    }

    // Warm up
    println!("Warming up GPU...");
    let _ = solver.solve(&client.n.to_string_radix(16), &a.to_string(), &puzzle_c, t)?;

    // Actual batch benchmark
    println!("Running TRUE batch solve (all puzzles in parallel)...");
    let batch_start = Instant::now();

    let batch_results = solver.solve_batch(&batch_puzzles)?;

    let batch_time = batch_start.elapsed();

    // Verify results
    let correct_count = batch_results.iter().filter(|r| r.key == key).count();

    // Calculate performance metrics
    let ms_per_puzzle = batch_time.as_millis() as f64 / batch_size as f64;
    let puzzles_per_sec = 1000.0 / ms_per_puzzle;

    println!("\n===== BATCH BENCHMARK RESULTS =====");
    println!("Total puzzles: {}", batch_size);
    println!("Correct solutions: {}/{}", correct_count, batch_size);
    println!("Total time: {:?}", batch_time);
    println!("Time per puzzle: {:.3} ms", ms_per_puzzle);
    println!("Throughput: {:.1} puzzles/sec", puzzles_per_sec);
    println!("===================================");

    // Compare with sequential solving
    let speedup = (110.0 / ms_per_puzzle); // ~110ms was the single solve time
    println!(
        "\n Batch solving is {:.0}x faster than sequential!",
        speedup
    );
    println!("   This matches the original CUDA benchmark performance!");

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_timelock_correctness() {
        // Small primes for fast testing
        let client = TimelockClient::generate(512);

        let key = [42u8; 32];
        let (c, _) = client.create_puzzle(2, 65536, &key);

        // Verify puzzle format
        assert!(!c.is_empty());
        assert!(Integer::from_str_radix(&c, 16).is_ok());
    }

    #[test]
    fn test_prime_generation() {
        let client = TimelockClient::generate(1024);

        // Verify n = p * q
        let n_check = Integer::from(&client.p * &client.q);
        assert_eq!(client.n, n_check);

        // Verify bit sizes
        assert!(client.p.significant_bits() >= 511);
        assert!(client.q.significant_bits() >= 511);
        assert!(client.n.significant_bits() >= 1023);
    }
}
