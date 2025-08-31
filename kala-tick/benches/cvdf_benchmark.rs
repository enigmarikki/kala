use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion, Throughput};
use kala_tick::{
    streamer::PietrzakProof, CVDFConfig, CVDFStepProof, CVDFStreamer, ClassGroup, Discriminant,
    QuadraticForm,
};

/// Helper to create a test configuration with specified discriminant size
fn create_test_config(discriminant_bits: u32) -> CVDFConfig {
    CVDFConfig {
        discriminant: Discriminant::generate(discriminant_bits)
            .expect("Should generate discriminant"),
        security_param: 128,
        tree_arity: 1024,
        base_difficulty: 1, // Keep low for benchmarking
    }
}

/// Benchmark single step computation with different discriminant sizes
fn bench_single_step(c: &mut Criterion) {
    let mut group = c.benchmark_group("cvdf_single_step");

    for disc_bits in [256, 512, 1024].iter() {
        group.bench_with_input(
            BenchmarkId::new("discriminant_bits", disc_bits),
            disc_bits,
            |b, &disc_bits| {
                let config = create_test_config(disc_bits);
                let mut streamer = CVDFStreamer::new(config.clone());
                let starting_form = QuadraticForm::identity(&config.discriminant);

                b.iter(|| streamer.compute_single_step(black_box(&starting_form)));
            },
        );
    }
    group.finish();
}

/// Benchmark k-steps computation with varying k values
fn bench_k_steps(c: &mut Criterion) {
    let mut group = c.benchmark_group("cvdf_k_steps");
    group.sample_size(10); // Reduce sample size for longer operations

    let config = create_test_config(512);

    for k in [10, 100, 1000].iter() {
        group.throughput(Throughput::Elements(*k as u64));
        group.bench_with_input(BenchmarkId::new("steps", k), k, |b, &k| {
            let mut streamer = CVDFStreamer::new(config.clone());
            let starting_form = QuadraticForm::identity(&config.discriminant);

            b.iter(|| streamer.compute_k_steps(black_box(&starting_form), black_box(k)));
        });
    }
    group.finish();
}

/// Benchmark proof generation for single steps
fn bench_single_step_proof_generation(c: &mut Criterion) {
    let mut group = c.benchmark_group("proof_generation_single");

    for disc_bits in [256, 512].iter() {
        group.bench_with_input(
            BenchmarkId::new("discriminant_bits", disc_bits),
            disc_bits,
            |b, &disc_bits| {
                let config = create_test_config(disc_bits);
                let streamer = CVDFStreamer::new(config.clone());
                let class_group = ClassGroup::new(config.discriminant.clone());
                let input = QuadraticForm::identity(&config.discriminant);
                let output = class_group.square(&input).unwrap();

                b.iter(|| {
                    streamer.generate_single_step_proof(black_box(&input), black_box(&output))
                });
            },
        );
    }
    group.finish();
}

/// Benchmark proof chain aggregation
fn bench_proof_aggregation(c: &mut Criterion) {
    let mut group = c.benchmark_group("proof_aggregation");

    let config = create_test_config(512);
    let streamer = CVDFStreamer::new(config.clone());
    let class_group = ClassGroup::new(config.discriminant.clone());

    for chain_length in [10, 50, 100].iter() {
        group.bench_with_input(
            BenchmarkId::new("chain_length", chain_length),
            chain_length,
            |b, &chain_length| {
                // Pre-generate proof chain
                let mut proof_chain = Vec::new();
                let mut current = QuadraticForm::identity(&config.discriminant);

                for _ in 0..chain_length {
                    let next = class_group.square(&current).unwrap();
                    let proof = streamer
                        .generate_single_step_proof(&current, &next)
                        .unwrap();
                    proof_chain.push(proof);
                    current = next;
                }

                b.iter(|| streamer.aggregate_proof_chain(black_box(proof_chain.clone())));
            },
        );
    }
    group.finish();
}

/// Benchmark the core class group operations
fn bench_class_group_operations(c: &mut Criterion) {
    let mut group = c.benchmark_group("class_group_ops");

    let disc = Discriminant::generate(512).unwrap();
    let class_group = ClassGroup::new(disc.clone());
    let form = QuadraticForm::identity(&disc);

    // Benchmark squaring
    group.bench_function("square", |b| {
        b.iter(|| class_group.square(black_box(&form)));
    });

    // Benchmark composition
    let form2 = class_group.square(&form).unwrap();
    group.bench_function("compose", |b| {
        b.iter(|| class_group.compose(black_box(&form), black_box(&form2)));
    });

    // Benchmark repeated squaring with different exponents
    for exp in [8, 16, 32].iter() {
        group.bench_with_input(
            BenchmarkId::new("repeated_squaring", exp),
            exp,
            |b, &exp| {
                b.iter(|| class_group.repeated_squaring(black_box(&form), black_box(exp)));
            },
        );
    }

    group.finish();
}

/// Benchmark Pietrzak proof generation and verification
fn bench_pietrzak_proof(c: &mut Criterion) {
    let mut group = c.benchmark_group("pietrzak_proof");
    group.sample_size(10); // These are expensive operations

    let disc = Discriminant::generate(512).unwrap();
    let class_group = ClassGroup::new(disc.clone());
    let g = QuadraticForm::identity(&disc);

    for t in [4, 8, 16].iter() {
        // Pre-compute y = g^(2^t)
        let y = class_group.repeated_squaring(&g, *t).unwrap();

        // Benchmark proof generation
        group.bench_with_input(BenchmarkId::new("generate", t), t, |b, &t| {
            b.iter(|| {
                PietrzakProof::generate(
                    black_box(&class_group),
                    black_box(&disc),
                    black_box(&g),
                    black_box(&y),
                    black_box(t),
                )
            });
        });

        // Generate proof for verification benchmark
        let proof = PietrzakProof::generate(&class_group, &disc, &g, &y, *t).unwrap();

        // Benchmark proof verification
        group.bench_with_input(BenchmarkId::new("verify", t), t, |b, &t| {
            b.iter(|| {
                proof.verify(
                    black_box(&class_group),
                    black_box(&disc),
                    black_box(&g),
                    black_box(&y),
                    black_box(t),
                )
            });
        });
    }

    group.finish();
}

/// Benchmark state serialization/deserialization
fn bench_state_management(c: &mut Criterion) {
    let mut group = c.benchmark_group("state_management");

    let config = create_test_config(512);
    let mut streamer = CVDFStreamer::new(config.clone());
    let starting_form = QuadraticForm::identity(&config.discriminant);
    streamer.initialize(starting_form).unwrap();

    // Add some computation to have non-trivial state
    streamer.stream_computation(10).unwrap();

    // Benchmark export
    group.bench_function("export_state", |b| {
        b.iter(|| streamer.export_state());
    });

    // Get exported data for import benchmark
    let exported_data = streamer.export_state().unwrap();

    // Benchmark import
    group.bench_function("import_state", |b| {
        b.iter(|| {
            let mut new_streamer = CVDFStreamer::new(config.clone());
            new_streamer.import_state(black_box(&exported_data))
        });
    });

    group.finish();
}

/// Benchmark the complete streaming computation workflow
fn bench_stream_computation(c: &mut Criterion) {
    let mut group = c.benchmark_group("stream_computation");
    group.sample_size(10);

    for steps in [10, 50, 100].iter() {
        group.bench_with_input(BenchmarkId::new("steps", steps), steps, |b, &steps| {
            let config = create_test_config(512);
            let mut streamer = CVDFStreamer::new(config.clone());
            let starting_form = QuadraticForm::identity(&config.discriminant);
            streamer.initialize(starting_form).unwrap();

            b.iter(|| streamer.stream_computation(black_box(steps)));
        });
    }

    group.finish();
}

/// Benchmark memory-intensive operations with different frontier sizes
fn bench_frontier_operations(c: &mut Criterion) {
    let mut group = c.benchmark_group("frontier_operations");

    let config = CVDFConfig {
        discriminant: Discriminant::generate(512).unwrap(),
        security_param: 128,
        tree_arity: 4,
        base_difficulty: 1,
    };

    // Benchmark proof generation with different frontier sizes
    for num_nodes in [10, 100, 500].iter() {
        group.bench_with_input(
            BenchmarkId::new("generate_proof_nodes", num_nodes),
            num_nodes,
            |b, &num_nodes| {
                let mut streamer = CVDFStreamer::new(config.clone());
                let starting_form = QuadraticForm::identity(&config.discriminant);
                streamer.initialize(starting_form).unwrap();

                // Build up frontier with nodes
                for _ in 0..num_nodes {
                    streamer.stream_computation(1).unwrap();
                }

                b.iter(|| streamer.generate_proof());
            },
        );
    }

    group.finish();
}

/// Profile hotspots - combine multiple operations
fn bench_realistic_workflow(c: &mut Criterion) {
    c.bench_function("realistic_workflow", |b| {
        b.iter(|| {
            let config = create_test_config(1024);
            let mut streamer = CVDFStreamer::new(config.clone());
            let starting_form = QuadraticForm::identity(&config.discriminant);

            // Initialize
            streamer.initialize(starting_form.clone()).unwrap();

            // Perform some single steps
            for _ in 0..65536 {
                streamer.compute_single_step(&starting_form).unwrap();
            }

            // Perform k-steps
            streamer.compute_k_steps(&starting_form, 20).unwrap();

            // Stream computation
            streamer.stream_computation(10).unwrap();

            // Generate proof
            streamer.generate_proof().unwrap();

            // Export state
            let state = streamer.export_state().unwrap();

            // Import to new streamer
            let mut new_streamer = CVDFStreamer::new(config);
            new_streamer.import_state(&state).unwrap();
        });
    });
}

criterion_group!(
    benches,
    //bench_single_step,
    //bench_k_steps,
    //bench_single_step_proof_generation,
    //bench_proof_aggregation,
    //bench_class_group_operations,
    //bench_pietrzak_proof,
    //bench_state_management,
    //bench_stream_computation,
    //bench_frontier_operations,
    bench_realistic_workflow
);

criterion_main!(benches);
