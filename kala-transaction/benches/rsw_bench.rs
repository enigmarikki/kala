use criterion::{
    black_box, criterion_group, criterion_main, BatchSize, BenchmarkId, Criterion, Throughput,
};
use kala_transaction::types::{Burn, Mint, Send, Stake, Transaction, Unstake, AES_KEY_SIZE};
use kala_transaction::*;
use std::sync::Arc;
use std::time::Duration;

const PROTOCOL_HARDNESS: u32 = 65536;
const PROTOCOL_MODULUS_BITS: usize = 2048;

// Helper to create test transactions
fn create_test_transaction() -> Transaction {
    Transaction::Send(Send {
        sender: [1u8; 32],
        receiver: [2u8; 32],
        denom: [3u8; 32],
        amount: 1000,
        nonce: 1,
        signature: vec![0u8; 64],
        gas_sponsorer: [0u8; 32],
    })
}

fn create_test_transactions(n: usize) -> Vec<Transaction> {
    (0..n)
        .map(|i| match i % 5 {
            0 => Transaction::Send(Send {
                sender: [(i % 256) as u8; 32],
                receiver: [((i + 1) % 256) as u8; 32],
                denom: [3u8; 32],
                amount: 1000 + i as u64,
                nonce: i as u64,
                signature: vec![0u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            1 => Transaction::Mint(Mint {
                sender: [(i % 256) as u8; 32],
                denom: [6u8; 32],
                amount: 5000 + i as u64,
                nonce: i as u64,
                signature: vec![1u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            2 => Transaction::Burn(Burn {
                sender: [(i % 256) as u8; 32],
                denom: [8u8; 32],
                amount: 2000 + i as u64,
                nonce: i as u64,
                signature: vec![2u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            3 => Transaction::Stake(Stake {
                delegator: [(i % 256) as u8; 32],
                witness: [10u8; 32],
                amount: 10000 + i as u64,
                nonce: i as u64,
                signature: vec![3u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
            _ => Transaction::Unstake(Unstake {
                delegator: [(i % 256) as u8; 32],
                witness: [12u8; 32],
                amount: 3000 + i as u64,
                nonce: i as u64,
                signature: vec![4u8; 64],
                gas_sponsorer: [0u8; 32],
            }),
        })
        .collect()
}

// ==================== Core AES-GCM Performance ====================

fn bench_aes_operations(c: &mut Criterion) {
    let mut group = c.benchmark_group("aes_gcm_core");

    let tx = create_test_transaction();
    let key = [42u8; AES_KEY_SIZE];
    let sealed = encrypt_transaction(&tx, &key).unwrap();

    group.bench_function("encrypt", |b| {
        b.iter(|| encrypt_transaction(black_box(&tx), black_box(&key)))
    });

    group.bench_function("decrypt", |b| {
        b.iter(|| decrypt_transaction(black_box(&sealed), black_box(&key)))
    });

    group.bench_function("roundtrip", |b| {
        b.iter(|| {
            let sealed = encrypt_transaction(black_box(&tx), black_box(&key)).unwrap();
            decrypt_transaction(black_box(&sealed), black_box(&key))
        })
    });

    group.finish();
}

// ==================== RSW Puzzle with Protocol Constants ====================

fn bench_rsw_with_protocol_constants(c: &mut Criterion) {
    let mut group = c.benchmark_group("rsw_protocol_operations");
    group.measurement_time(Duration::from_secs(120));

    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();
    println!("GPU Device: {}", timelock.device_name());
    println!("Protocol Hardness: {}", PROTOCOL_HARDNESS);
    println!("Protocol Modulus Bits: {}", PROTOCOL_MODULUS_BITS);

    let key = [42u8; AES_KEY_SIZE];

    // Puzzle generation with protocol hardness
    group.bench_function("puzzle_generation", |b| {
        b.iter(|| timelock.generate_puzzle(black_box(&key), black_box(PROTOCOL_HARDNESS)))
    });

    // Single puzzle solving
    group.sample_size(10);
    group.bench_function("single_puzzle_solve", |b| {
        b.iter_batched(
            || timelock.generate_puzzle(&key, PROTOCOL_HARDNESS).unwrap(),
            |puzzle| timelock.solve_puzzle(black_box(&puzzle)),
            BatchSize::SmallInput,
        )
    });

    group.finish();
}

// ==================== Dynamic Hardness Testing ====================

fn bench_dynamic_hardness(c: &mut Criterion) {
    let mut group = c.benchmark_group("dynamic_hardness");

    let tx = create_test_transaction();
    let hardness_values = vec![100, 500, 1000, 2000, 5000];

    for hardness in hardness_values {
        group.bench_with_input(
            BenchmarkId::new("create_timelock", hardness),
            &hardness,
            |b, &h| {
                let ctx = EncryptionContext::new(h);
                ctx.update_tick(1);

                b.iter(|| {
                    create_timelock_transaction(black_box(&tx), black_box(&ctx), black_box(500))
                })
            },
        );
    }

    group.finish();
}

// ==================== Batch Processing Performance ====================

fn bench_batch_processing(c: &mut Criterion) {
    let mut group = c.benchmark_group("batch_processing");
    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();
    let optimal_batch = timelock.optimal_batch_size();

    println!("Optimal GPU Batch Size: {}", optimal_batch);

    // Test various batch sizes to find actual optimal performance
    let batch_sizes = vec![
        1,
        optimal_batch / 4,
        optimal_batch / 2,
        optimal_batch,
        optimal_batch * 2,
        optimal_batch * 4,
    ]
    .into_iter()
    .filter(|&s| s > 0 && s <= 1000)
    .collect::<Vec<_>>();

    for batch_size in batch_sizes {
        group.throughput(Throughput::Elements(batch_size as u64));

        group.bench_with_input(
            BenchmarkId::new("batch_solve", batch_size),
            &batch_size,
            |b, &size| {
                b.iter_batched(
                    || {
                        (0..size)
                            .map(|i| {
                                let mut key = [0u8; AES_KEY_SIZE];
                                key[0] = (i % 256) as u8;
                                key[1] = ((i / 256) % 256) as u8;
                                timelock.generate_puzzle(&key, PROTOCOL_HARDNESS).unwrap()
                            })
                            .collect::<Vec<_>>()
                    },
                    |puzzles| timelock.solve_batch(black_box(&puzzles)),
                    BatchSize::SmallInput,
                )
            },
        );
    }

    group.finish();
}

// ==================== Timelock Transaction Pipeline ====================

fn bench_timelock_pipeline(c: &mut Criterion) {
    let mut group = c.benchmark_group("timelock_pipeline");

    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);

    // Test at different tick values
    let tick_values = vec![0, 10, 100, 1000];

    for tick in tick_values {
        let tx = create_test_transaction();
        ctx.update_tick(tick);

        group.bench_with_input(BenchmarkId::new("create_at_tick", tick), &tick, |b, _| {
            b.iter(|| create_timelock_transaction(black_box(&tx), black_box(&ctx), black_box(500)))
        });
    }

    // Decryption benchmark
    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    group.bench_function("decrypt_single", |b| {
        let tx = create_test_transaction();
        ctx.update_tick(1);

        b.iter_batched(
            || create_timelock_transaction(&tx, &ctx, 500).unwrap(),
            |timelock_tx| decrypt_timelock_transaction(black_box(&timelock_tx)),
            BatchSize::SmallInput,
        )
    });

    group.finish();
}

// ==================== Full Batch Pipeline ====================

fn bench_full_batch_pipeline(c: &mut Criterion) {
    let mut group = c.benchmark_group("full_batch_pipeline");
    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);
    ctx.update_tick(1);

    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();
    let optimal_batch = timelock.optimal_batch_size();

    // Test realistic batch sizes based on optimal GPU batch
    let batch_sizes = vec![optimal_batch / 2, optimal_batch, optimal_batch * 2]
        .into_iter()
        .filter(|&s| s > 0 && s <= 500)
        .collect::<Vec<_>>();

    for batch_size in batch_sizes {
        group.throughput(Throughput::Elements(batch_size as u64));

        group.bench_with_input(
            BenchmarkId::new("create_and_decrypt_batch", batch_size),
            &batch_size,
            |b, &size| {
                b.iter_batched(
                    || {
                        let transactions = create_test_transactions(size);
                        transactions
                            .iter()
                            .enumerate()
                            .map(|(i, tx)| {
                                create_timelock_transaction(tx, &ctx, 500 + i as u64).unwrap()
                            })
                            .collect::<Vec<_>>()
                    },
                    |timelock_txs| decrypt_timelock_batch(black_box(&timelock_txs)),
                    BatchSize::SmallInput,
                )
            },
        );
    }

    group.finish();
}

// ==================== Hardness Update Performance ====================

fn bench_hardness_updates(c: &mut Criterion) {
    let mut group = c.benchmark_group("hardness_updates");

    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);
    ctx.update_tick(1);

    // Benchmark hardness update overhead
    group.bench_function("update_hardness", |b| {
        let mut hardness = 1000;
        b.iter(|| {
            hardness = (hardness + 100) % 10000;
            ctx.update_hardness(black_box(hardness));
        })
    });

    // Benchmark concurrent hardness updates
    use std::sync::Arc;
    use std::thread;

    let ctx_arc = Arc::new(EncryptionContext::new(PROTOCOL_HARDNESS));

    for num_threads in [1, 2, 4, 8].iter() {
        group.bench_with_input(
            BenchmarkId::new("concurrent_hardness_updates", num_threads),
            num_threads,
            |b, &threads| {
                b.iter(|| {
                    let mut handles = vec![];

                    for i in 0..threads {
                        let ctx_clone: Arc<EncryptionContext> = Arc::clone(&ctx_arc);
                        let handle = thread::spawn(move || {
                            for j in 0..100 {
                                ctx_clone.update_hardness(1000 + (i * 100 + j) as u32);
                            }
                        });
                        handles.push(handle);
                    }

                    for handle in handles {
                        handle.join().unwrap();
                    }
                })
            },
        );
    }

    group.finish();
}

// ==================== Throughput Analysis ====================

fn bench_throughput_analysis(c: &mut Criterion) {
    let mut group = c.benchmark_group("throughput_analysis");
    group.measurement_time(Duration::from_secs(120));

    // Measure pure encryption throughput
    let key = [42u8; AES_KEY_SIZE];

    for tx_count in [100, 500, 1000, 5000].iter() {
        let transactions = create_test_transactions(*tx_count);
        group.throughput(Throughput::Elements(*tx_count as u64));

        group.bench_with_input(
            BenchmarkId::new("aes_encrypt_throughput", tx_count),
            &transactions,
            |b, txs| {
                b.iter(|| {
                    for tx in txs {
                        let _ = encrypt_transaction(black_box(tx), black_box(&key));
                    }
                })
            },
        );
    }

    // Measure timelock creation throughput with dynamic hardness
    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);
    ctx.update_tick(1);

    for tx_count in [10, 50, 100].iter() {
        let transactions = create_test_transactions(*tx_count);
        group.throughput(Throughput::Elements(*tx_count as u64));

        group.bench_with_input(
            BenchmarkId::new("timelock_create_throughput", tx_count),
            &transactions,
            |b, txs: &Vec<Transaction>| {
                b.iter(|| {
                    for (i, tx) in txs.iter().enumerate() {
                        let _ = create_timelock_transaction(
                            black_box(tx),
                            black_box(&ctx),
                            black_box(500 + i as u64),
                        );
                    }
                })
            },
        );
    }

    group.finish();
}

// ==================== GPU Utilization Analysis ====================

fn bench_gpu_utilization(c: &mut Criterion) {
    let mut group = c.benchmark_group("gpu_utilization");
    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();
    let optimal_batch = timelock.optimal_batch_size();

    println!("\n=== GPU Utilization Analysis ===");
    println!("Device: {}", timelock.device_name());
    println!("Optimal Batch Size: {}", optimal_batch);
    println!("Protocol Hardness: {}", PROTOCOL_HARDNESS);

    // Test GPU efficiency at different utilization levels
    let utilization_levels = vec![
        ("10%", optimal_batch / 10),
        ("25%", optimal_batch / 4),
        ("50%", optimal_batch / 2),
        ("75%", (optimal_batch * 3) / 4),
        ("100%", optimal_batch),
        ("150%", (optimal_batch * 3) / 2),
        ("200%", optimal_batch * 2),
    ];

    for (label, batch_size) in utilization_levels {
        if batch_size == 0 || batch_size > 1000 {
            continue;
        }

        group.throughput(Throughput::Elements(batch_size as u64));

        group.bench_with_input(
            BenchmarkId::new("gpu_utilization", label),
            &batch_size,
            |b, &size| {
                b.iter_batched(
                    || {
                        (0..size)
                            .map(|i| {
                                let mut key = [0u8; AES_KEY_SIZE];
                                key[0] = (i % 256) as u8;
                                key[1] = ((i / 256) % 256) as u8;
                                timelock.generate_puzzle(&key, PROTOCOL_HARDNESS).unwrap()
                            })
                            .collect::<Vec<_>>()
                    },
                    |puzzles| timelock.solve_batch(black_box(&puzzles)),
                    BatchSize::SmallInput,
                )
            },
        );
    }

    group.finish();
}

// ==================== Memory and Resource Usage ====================

fn bench_memory_usage(c: &mut Criterion) {
    let mut group = c.benchmark_group("memory_usage");

    let tx = create_test_transaction();
    let key = [42u8; AES_KEY_SIZE];
    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);
    ctx.update_tick(1);

    group.bench_function("sealed_transaction_bytes", |b| {
        b.iter(|| {
            let sealed = encrypt_transaction(black_box(&tx), black_box(&key)).unwrap();
            std::mem::size_of_val(&sealed) + sealed.ciphertext.len()
        })
    });

    group.bench_function("timelock_transaction_bytes", |b| {
        b.iter(|| {
            let timelock_tx =
                create_timelock_transaction(black_box(&tx), black_box(&ctx), 500).unwrap();

            std::mem::size_of_val(&timelock_tx)
                + timelock_tx.encrypted_data.ciphertext.len()
                + timelock_tx.puzzle.n.len()
                + timelock_tx.puzzle.a.len()
                + timelock_tx.puzzle.puzzle_value.len()
        })
    });

    // Memory usage for batch operations
    let batch_sizes = vec![10, 50, 100, 500];

    for size in batch_sizes {
        group.bench_with_input(
            BenchmarkId::new("batch_memory", size),
            &size,
            |b, &batch_size| {
                b.iter(|| {
                    let transactions = create_test_transactions(batch_size);
                    let mut total_size = 0;

                    for (i, tx) in transactions.iter().enumerate() {
                        let timelock_tx =
                            create_timelock_transaction(tx, &ctx, 500 + i as u64).unwrap();

                        total_size += std::mem::size_of_val(&timelock_tx)
                            + timelock_tx.encrypted_data.ciphertext.len()
                            + timelock_tx.puzzle.n.len()
                            + timelock_tx.puzzle.a.len()
                            + timelock_tx.puzzle.puzzle_value.len();
                    }

                    total_size
                })
            },
        );
    }

    group.finish();
}

// ==================== Parallel Processing ====================

fn bench_parallel_processing(c: &mut Criterion) {
    use std::sync::Arc;
    use std::thread;

    let mut group = c.benchmark_group("parallel_processing");
    group.measurement_time(Duration::from_secs(120));

    let transactions = Arc::new(create_test_transactions(1000));
    let ctx = Arc::new(EncryptionContext::new(PROTOCOL_HARDNESS));
    ctx.update_tick(1);

    for num_threads in [1, 2, 4, 8, 16].iter() {
        group.throughput(Throughput::Elements(1000));

        group.bench_with_input(
            BenchmarkId::new("parallel_timelock_creation", num_threads),
            num_threads,
            |b, &threads| {
                b.iter(|| {
                    let mut handles = vec![];
                    let chunk_size = 1000 / threads;

                    for i in 0..threads {
                        let txs = Arc::clone(&transactions);
                        let ctx_clone = Arc::clone(&ctx);

                        let handle = thread::spawn(move || {
                            let start = i * chunk_size;
                            let end = ((i + 1) * chunk_size).min(1000);

                            for j in start..end {
                                let _ = create_timelock_transaction(
                                    &txs[j],
                                    &ctx_clone,
                                    500 + j as u64,
                                );
                            }
                        });
                        handles.push(handle);
                    }

                    for handle in handles {
                        handle.join().unwrap();
                    }
                })
            },
        );
    }

    group.finish();
}

// ==================== Real World Scenarios ====================

fn bench_real_world_scenarios(c: &mut Criterion) {
    let mut group = c.benchmark_group("real_world_scenarios");
    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);

    // Scenario 1: MEV protection for a block of transactions
    group.bench_function("block_mev_protection", |b| {
        let block_size = 100; // Typical block size
        ctx.update_tick(5);

        b.iter_batched(
            || create_test_transactions(block_size),
            |transactions| {
                let mut timelock_txs = Vec::new();
                for (i, tx) in transactions.iter().enumerate() {
                    let timelock_tx =
                        create_timelock_transaction(tx, &ctx, 5000 + i as u64).unwrap();
                    timelock_txs.push(timelock_tx);
                }

                // Simulate block processing
                decrypt_timelock_batch(&timelock_txs)
            },
            BatchSize::SmallInput,
        )
    });

    // Scenario 2: Peak load handling
    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();
    let peak_load_size = timelock.optimal_batch_size();

    group.bench_function("peak_load_processing", |b| {
        ctx.update_tick(10);

        b.iter_batched(
            || {
                let transactions = create_test_transactions(peak_load_size);
                transactions
                    .iter()
                    .enumerate()
                    .map(|(i, tx)| create_timelock_transaction(tx, &ctx, 10000 + i as u64).unwrap())
                    .collect::<Vec<_>>()
            },
            |timelock_txs| decrypt_timelock_batch(black_box(&timelock_txs)),
            BatchSize::SmallInput,
        )
    });

    // Scenario 3: Dynamic hardness adjustment
    group.bench_function("dynamic_hardness_adjustment", |b| {
        let block_size = 50;
        let hardness_values = vec![500, 1000, 2000, 1000, 500]; // Simulate hardness changes

        b.iter_batched(
            || create_test_transactions(block_size),
            |transactions| {
                let mut all_results = Vec::new();

                for (idx, hardness) in hardness_values.iter().enumerate() {
                    ctx.update_hardness(*hardness);
                    ctx.update_tick(idx as u64);

                    let mut timelock_txs = Vec::new();
                    for (i, tx) in transactions.iter().take(10).enumerate() {
                        let timelock_tx =
                            create_timelock_transaction(tx, &ctx, (idx * 1000 + i) as u64).unwrap();
                        timelock_txs.push(timelock_tx);
                    }

                    let results = decrypt_timelock_batch(&timelock_txs).unwrap();
                    all_results.extend(results);
                }

                all_results
            },
            BatchSize::SmallInput,
        )
    });

    group.finish();
}

// ==================== Latency Analysis ====================

fn bench_latency_analysis(c: &mut Criterion) {
    let mut group = c.benchmark_group("latency_analysis");

    let tx = create_test_transaction();
    let key = [42u8; AES_KEY_SIZE];
    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);
    ctx.update_tick(1);
    let timelock = RSWTimelock::new(PROTOCOL_MODULUS_BITS).unwrap();

    // End-to-end latency for single transaction
    group.bench_function("single_tx_e2e_latency", |b| {
        b.iter(|| {
            // Create
            let timelock_tx =
                create_timelock_transaction(black_box(&tx), black_box(&ctx), black_box(500))
                    .unwrap();

            // Decrypt
            decrypt_timelock_transaction(black_box(&timelock_tx))
        })
    });

    // Component latencies
    group.bench_function("aes_latency", |b| {
        b.iter(|| {
            let sealed = encrypt_transaction(black_box(&tx), black_box(&key)).unwrap();
            decrypt_transaction(black_box(&sealed), black_box(&key))
        })
    });

    group.bench_function("puzzle_gen_latency", |b| {
        b.iter(|| timelock.generate_puzzle(black_box(&key), black_box(PROTOCOL_HARDNESS)))
    });

    group.measurement_time(Duration::from_secs(120));
    group.sample_size(10);

    group.bench_function("puzzle_solve_latency", |b| {
        b.iter_batched(
            || timelock.generate_puzzle(&key, PROTOCOL_HARDNESS).unwrap(),
            |puzzle| timelock.solve_puzzle(black_box(&puzzle)),
            BatchSize::SmallInput,
        )
    });

    group.finish();
}

// ==================== Context Operations ====================

fn bench_context_operations(c: &mut Criterion) {
    let mut group = c.benchmark_group("context_operations");

    let ctx = EncryptionContext::new(PROTOCOL_HARDNESS);

    group.bench_function("update_tick", |b| {
        let mut tick = 0u64;
        b.iter(|| {
            tick = tick.wrapping_add(1);
            ctx.update_tick(black_box(tick));
        })
    });

    group.bench_function("update_hardness", |b| {
        let mut hardness = 1000u32;
        b.iter(|| {
            hardness = (hardness + 100) % 10000;
            ctx.update_hardness(black_box(hardness));
        })
    });

    group.bench_function("read_tick", |b| {
        ctx.update_tick(12345);
        b.iter(|| black_box(ctx.current_tick()))
    });

    group.bench_function("read_hardness", |b| {
        ctx.update_hardness(5000);
        b.iter(|| black_box(ctx.current_hardness()))
    });

    // Concurrent reads and writes
    use std::sync::Arc;
    use std::thread;

    let ctx_arc = Arc::new(EncryptionContext::new(PROTOCOL_HARDNESS));

    group.bench_function("concurrent_tick_updates", |b| {
        b.iter(|| {
            let mut handles = vec![];

            for i in 0..4 {
                let ctx_clone: Arc<EncryptionContext> = Arc::clone(&ctx_arc);
                let handle = thread::spawn(move || {
                    for j in 0..25 {
                        ctx_clone.update_tick((i * 25 + j) as u64);
                    }
                });
                handles.push(handle);
            }

            for handle in handles {
                handle.join().unwrap();
            }
        })
    });

    group.finish();
}

criterion_group!(
    benches,
    bench_aes_operations,
    bench_rsw_with_protocol_constants,
    bench_dynamic_hardness,
    bench_batch_processing,
    bench_timelock_pipeline,
    bench_full_batch_pipeline,
    bench_hardness_updates,
    bench_throughput_analysis,
    bench_gpu_utilization,
    bench_memory_usage,
    bench_parallel_processing,
    bench_real_world_scenarios,
    bench_latency_analysis,
    bench_context_operations,
);

criterion_main!(benches);
