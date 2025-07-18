use vdf_streamer::*;
use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};

fn bench_vdf_computation(c: &mut Criterion) {
    let mut group = c.benchmark_group("vdf_computation");

    // Test different iteration counts
    for iterations in [1000, 5000, 10000, 50000].iter() {
        group.bench_with_input(
            BenchmarkId::from_parameter(iterations),
            iterations,
            |b, &iterations| {
                b.iter(|| {
                    let config = VdfConfig::new().with_threads(4).with_fast_mode(true);

                    let mut ctx = VdfContext::new(&config).unwrap();
                    let challenge = [0x42u8; 32];

                    ctx.start_computation(&challenge, iterations, 512).unwrap();
                    ctx.wait_completion(None).unwrap();

                    black_box(ctx.get_result_form().unwrap());
                });
            },
        );
    }

    group.finish();
}

fn bench_proof_generation(c: &mut Criterion) {
    // Pre-compute a VDF result
    let config = VdfConfig::new()
        .with_threads(4)
        .with_fast_mode(true)
        .with_segment_size(1000);

    let mut ctx = VdfContext::new(&config).unwrap();
    let challenge = [0x42u8; 32];
    let iterations = 10000;

    ctx.start_computation(&challenge, iterations, 1024).unwrap();
    ctx.wait_completion(None).unwrap();

    c.bench_function("proof_generation", |b| {
        b.iter(|| {
            let proof = ctx.generate_proof(0).unwrap();
            black_box(proof);
        });
    });
}

fn bench_discriminant_creation(c: &mut Criterion) {
    let mut group = c.benchmark_group("discriminant_creation");

    for bits in [256, 512, 1024, 2048].iter() {
        group.bench_with_input(BenchmarkId::from_parameter(bits), bits, |b, &bits| {
            b.iter(|| {
                let challenge = [0x42u8; 32];
                let discriminant = create_discriminant(&challenge, bits).unwrap();
                black_box(discriminant);
            });
        });
    }

    group.finish();
}

fn bench_checkpoint_proofs(c: &mut Criterion) {
    // Pre-compute with checkpoints
    let config = VdfConfig::new()
        .with_threads(4)
        .with_fast_mode(true)
        .with_segment_size(1000);

    let mut ctx = VdfContext::new(&config).unwrap();
    let challenge = [0x42u8; 32];
    let iterations = 50000;

    ctx.start_computation(&challenge, iterations, 512).unwrap();
    ctx.wait_completion(None).unwrap();

    c.bench_function("get_checkpoint_proofs", |b| {
        b.iter(|| {
            let checkpoints = ctx.get_checkpoint_proofs(0, iterations, 10).unwrap();
            black_box(checkpoints);
        });
    });
}

criterion_group!(
    benches,
    bench_vdf_computation,
    bench_proof_generation,
    bench_discriminant_creation,
    bench_checkpoint_proofs
);
criterion_main!(benches);
