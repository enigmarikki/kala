// src/bin/perf_analysis.rs
use kala_tick::{CVDFConfig, CVDFStreamer, ClassGroup, Discriminant, QuadraticForm};
use std::time::Instant;

fn main() {
    println!("CVDF Performance Analysis\n");
    println!("==============================================");

    // Test different discriminant sizes
    analyze_discriminant_impact();

    // Test k-steps scaling
    analyze_k_steps_scaling();

    // Test proof generation overhead
    analyze_proof_overhead();
}

fn analyze_discriminant_impact() {
    println!("\n## Discriminant Size Impact Analysis");
    println!("---------------------------------------------");

    let test_sizes = vec![256, 512, 1024, 2048];
    let k_steps = 100;

    for disc_bits in test_sizes {
        let config = CVDFConfig {
            discriminant: Discriminant::generate(disc_bits).unwrap(),
            security_param: 128,
            tree_arity: 4,
            base_difficulty: 1,
        };

        let mut streamer = CVDFStreamer::new(config.clone());
        let form = QuadraticForm::identity(&config.discriminant);

        // Measure single step
        let start = Instant::now();
        let _ = streamer.compute_single_step(&form);
        let single_time = start.elapsed();

        // Measure k steps
        let start = Instant::now();
        let _ = streamer.compute_k_steps(&form, k_steps);
        let k_time = start.elapsed();

        println!("Discriminant {} bits:", disc_bits);
        println!("  Single step: {:?}", single_time);
        println!(
            "  {} steps: {:?} (avg: {:?}/step)",
            k_steps,
            k_time,
            k_time / k_steps as u32
        );
        println!(
            "  Throughput: {:.2} steps/sec",
            k_steps as f64 / k_time.as_secs_f64()
        );
    }
}

fn analyze_k_steps_scaling() {
    println!("\n## K-Steps Scaling Analysis");
    println!("------------------------------------------");

    let config = CVDFConfig {
        discriminant: Discriminant::generate(512).unwrap(),
        security_param: 128,
        tree_arity: 4,
        base_difficulty: 1,
    };

    let mut streamer = CVDFStreamer::new(config.clone());
    let form = QuadraticForm::identity(&config.discriminant);

    let k_values = vec![10, 50, 100, 500, 1000, 5000];

    println!("Steps | Time       | Avg/Step   | Throughput");
    println!("------|------------|------------|------------");

    for k in k_values {
        let start = Instant::now();
        let result = streamer.compute_k_steps(&form, k);
        let elapsed = start.elapsed();

        if result.is_ok() {
            let avg_per_step = elapsed.as_micros() as f64 / k as f64;
            let throughput = k as f64 / elapsed.as_secs_f64();

            println!(
                "{:5} | {:10.3?} | {:8.1}μs | {:8.1}/s",
                k, elapsed, avg_per_step, throughput
            );
        } else {
            println!("{:5} | ERROR", k);
        }
    }
}

fn analyze_proof_overhead() {
    println!("\n## Proof Generation Overhead Analysis");
    println!("------------------------------------------");
    let config = CVDFConfig {
        discriminant: Discriminant::generate(512).unwrap(),
        security_param: 128,
        tree_arity: 4,
        base_difficulty: 1,
    };

    let streamer = CVDFStreamer::new(config.clone());
    let class_group = ClassGroup::new(config.discriminant.clone());
    let form = QuadraticForm::identity(&config.discriminant);

    // Time raw squaring vs with proof
    let iterations = 1000;

    // Raw squaring
    let start = Instant::now();
    let mut current = form.clone();
    for _ in 0..iterations {
        current = class_group.square(&current).unwrap();
    }
    let raw_time = start.elapsed();

    // With proof generation
    let start = Instant::now();
    let mut current = form.clone();
    for _ in 0..iterations {
        let next = class_group.square(&current).unwrap();
        let _ = streamer.generate_single_step_proof(&current, &next);
        current = next;
    }
    let proof_time = start.elapsed();

    println!("Operations: {} iterations", iterations);
    println!("Raw squaring time: {:?}", raw_time);
    println!("With proof generation: {:?}", proof_time);
    println!(
        "Proof overhead: {:?} ({:.1}%)",
        proof_time - raw_time,
        ((proof_time.as_secs_f64() - raw_time.as_secs_f64()) / raw_time.as_secs_f64()) * 100.0
    );

    // Test proof aggregation scaling
    println!("\nProof Aggregation Scaling:");
    let chain_sizes = vec![10, 50, 100, 500];

    for size in chain_sizes {
        let mut proof_chain = Vec::new();
        let mut current = form.clone();

        // Build chain
        for _ in 0..size {
            let next = class_group.square(&current).unwrap();
            let proof = streamer
                .generate_single_step_proof(&current, &next)
                .unwrap();
            proof_chain.push(proof);
            current = next;
        }

        // Time aggregation
        let start = Instant::now();
        let _ = streamer.aggregate_proof_chain(proof_chain);
        let agg_time = start.elapsed();

        println!("  Chain size {}: {:?}", size, agg_time);
    }
}

// Additional helper for detailed timing
#[allow(dead_code)]
fn time_operation<F, R>(name: &str, op: F) -> R
where
    F: FnOnce() -> R,
{
    let start = Instant::now();
    let result = op();
    let elapsed = start.elapsed();
    println!("{}: {:?}", name, elapsed);
    result
}
