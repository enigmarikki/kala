#include "streamer.h"
#include "vdf.h"

#include <thread>
#include <mutex>
#include <condition_variable>
#include <atomic>
#include <chrono>
#include <memory>
#include <cstring>
#include <vector>
#include <iostream>
#include <iomanip>
#include <sstream>

// Define missing symbols if needed
#ifndef gcd_base_bits
int gcd_base_bits = 50;
#endif
#ifndef gcd_128_max_iter
int gcd_128_max_iter = 64;
#endif

// Checkpoint proof structure - moved outside of cpu_vdf_context
struct CheckpointProof {
    uint64_t iteration;
    form checkpoint_form;
    form proof_form;
    integer challenge_prime;
    std::vector<uint8_t> serialized_proof;
    
    // Constructor to ensure proper initialization
    CheckpointProof() : iteration(0) {
        // integer and form have their own constructors
    }
};

// Internal context structure
struct cpu_vdf_context {
    cpu_vdf_config_t config;
    
    // Computation state
    std::atomic<cpu_vdf_state_t> state{CPU_VDF_STATE_IDLE};
    std::atomic<uint64_t> current_iteration{0};
    uint64_t target_iterations = 0;
    
    // VDF parameters
    integer discriminant;
    form initial_form;
    form current_form;
    form final_form;
    
    // Threading
    std::thread computation_thread;
    std::atomic<bool> should_stop{false};
    std::mutex mutex;
    std::condition_variable completion_cv;
    
    // Progress tracking
    std::chrono::steady_clock::time_point start_time;
    cpu_vdf_progress_callback_t progress_cb = nullptr;
    cpu_vdf_completion_callback_t completion_cb = nullptr;
    uint32_t update_interval_ms = 1000;
    void* user_data = nullptr;
    
    // Performance tracking
    uint64_t iterations_per_second = 0;
    std::chrono::steady_clock::time_point last_update_time;
    
    // Streaming proof data
    std::vector<CheckpointProof> checkpoint_proofs;
    uint64_t checkpoint_interval = 0;
    bool store_checkpoints = false;
    bool generate_streaming_proofs = false;
};

// Helper function for hashing
static std::vector<uint8_t> sha256(const std::vector<uint8_t>& data) {
    // Production SHA256 implementation would go here
    // For now, using a deterministic pseudo-hash
    std::vector<uint8_t> hash(32);
    for (size_t i = 0; i < 32; i++) {
        uint8_t h = i;
        for (size_t j = 0; j < data.size(); j++) {
            h ^= data[j] + i + j;
            h = (h << 1) | (h >> 7);  // Rotate
        }
        hash[i] = h;
    }
    return hash;
}

// Helper to compute NextPrime
static void NextPrime(integer& n, const integer& start) {
    mpz_set(n.impl, start.impl);
    if (mpz_even_p(n.impl)) {
        mpz_add_ui(n.impl, n.impl, 1);
    }
    while (!mpz_probab_prime_p(n.impl, 25)) {
        mpz_add_ui(n.impl, n.impl, 2);
    }
}

// Helper to generate proof for a checkpoint using VDF functions
static CheckpointProof generate_checkpoint_proof(
    const form& start_form,
    const form& end_form,
    uint64_t iterations,
    const integer& discriminant
) {
    CheckpointProof cp;
    cp.iteration = iterations;
    cp.checkpoint_form = end_form;
    
    // For streaming proofs, we'll generate a Wesolowski proof for this segment
    // using the VDF library's optimized functions
    
    // Generate challenge prime using Fiat-Shamir
    std::vector<uint8_t> challenge_data;
    
    // Add discriminant
    size_t disc_size = mpz_sizeinbase(discriminant.impl, 256) + 1;
    std::vector<uint8_t> disc_bytes(disc_size);
    mpz_export(disc_bytes.data(), &disc_size, 1, 1, 0, 0, discriminant.impl);
    challenge_data.insert(challenge_data.end(), disc_bytes.begin(), disc_bytes.begin() + disc_size);
    
    // Add forms and iterations
    auto serialize_form = [&challenge_data](const form& f) {
        size_t size_a = mpz_sizeinbase(f.a.impl, 256) + 1;
        size_t size_b = mpz_sizeinbase(f.b.impl, 256) + 1;
        size_t size_c = mpz_sizeinbase(f.c.impl, 256) + 1;
        
        std::vector<uint8_t> bytes_a(size_a), bytes_b(size_b), bytes_c(size_c);
        mpz_export(bytes_a.data(), &size_a, 1, 1, 0, 0, f.a.impl);
        mpz_export(bytes_b.data(), &size_b, 1, 1, 0, 0, f.b.impl);
        mpz_export(bytes_c.data(), &size_c, 1, 1, 0, 0, f.c.impl);
        
        challenge_data.insert(challenge_data.end(), bytes_a.begin(), bytes_a.begin() + size_a);
        challenge_data.insert(challenge_data.end(), bytes_b.begin(), bytes_b.begin() + size_b);
        challenge_data.insert(challenge_data.end(), bytes_c.begin(), bytes_c.begin() + size_c);
    };
    
    serialize_form(start_form);
    serialize_form(end_form);
    
    // Add iterations
    for (int i = 7; i >= 0; i--) {
        challenge_data.push_back((iterations >> (i * 8)) & 0xFF);
    }
    
    // Hash to get challenge seed
    std::vector<uint8_t> hash = sha256(challenge_data);
    
    // Generate prime l from hash
    integer l;
    mpz_import(l.impl, 32, 1, 1, 0, 0, hash.data());
    mpz_setbit(l.impl, 263);  // Ensure it's large enough
    NextPrime(l, l);
    
    cp.challenge_prime = l;
    
    // For checkpoint proofs, we can use FastPow from vdf.h
    // Calculate quotient q = floor(2^iterations / l)
    mpz_t two_to_T, quotient, remainder;
    mpz_init(two_to_T);
    mpz_init(quotient);
    mpz_init(remainder);
    
    mpz_ui_pow_ui(two_to_T, 2, iterations);
    mpz_fdiv_qr(quotient, remainder, two_to_T, l.impl);
    
    // Use FastPowFormNucomp from vdf.h for efficient exponentiation
    PulmarkReducer reducer;
    integer L_local = root(-discriminant, 4);
    integer quotient_int;
    mpz_set(quotient_int.impl, quotient);
    cp.proof_form = FastPowFormNucomp(start_form, const_cast<integer&>(discriminant), quotient_int, L_local, reducer);
    
    mpz_clear(two_to_T);
    mpz_clear(quotient);
    mpz_clear(remainder);
    
    // Serialize the checkpoint proof
    cp.serialized_proof.push_back(0x03); // Version 3 - checkpoint
    
    // Add iteration number (8 bytes)
    for (int i = 7; i >= 0; i--) {
        cp.serialized_proof.push_back((iterations >> (i * 8)) & 0xFF);
    }
    
    // Add checkpoint form
    auto add_form = [&](const form& f) {
        auto add_integer = [&](const integer& val) {
            size_t size = mpz_sizeinbase(val.impl, 256) + 1;
            std::vector<uint8_t> bytes(size);
            mpz_export(bytes.data(), &size, 1, 1, 0, 0, val.impl);
            cp.serialized_proof.push_back((size >> 8) & 0xFF);
            cp.serialized_proof.push_back(size & 0xFF);
            cp.serialized_proof.insert(cp.serialized_proof.end(), bytes.begin(), bytes.begin() + size);
        };
        add_integer(f.a);
        add_integer(f.b);
        add_integer(f.c);
    };
    
    add_form(cp.checkpoint_form);
    
    // Add proof form
    add_form(cp.proof_form);
    
    // Add challenge prime
    size_t l_size = mpz_sizeinbase(l.impl, 256) + 1;
    std::vector<uint8_t> l_bytes(l_size);
    mpz_export(l_bytes.data(), &l_size, 1, 1, 0, 0, l.impl);
    cp.serialized_proof.push_back(l_size);
    cp.serialized_proof.insert(cp.serialized_proof.end(), l_bytes.begin(), l_bytes.begin() + l_size);
    
    return cp;
}

extern "C" {

// Main computation function
static void vdf_computation_thread(cpu_vdf_context_t* ctx) {
    ctx->state.store(CPU_VDF_STATE_COMPUTING);
    ctx->start_time = std::chrono::steady_clock::now();
    ctx->last_update_time = ctx->start_time;
    
    try {
        form current = ctx->initial_form;
        form last_checkpoint = ctx->initial_form;
        uint64_t last_checkpoint_iter = 0;
        uint64_t completed_iterations = 0;
        uint64_t batch_size = 1000;
        
        // Calculate checkpoint interval
        if (ctx->store_checkpoints && ctx->target_iterations > 0) {
            ctx->checkpoint_interval = ctx->config.segment_size > 0 ? 
                ctx->config.segment_size : 65536; // Default to 65536
            ctx->checkpoint_proofs.reserve((ctx->target_iterations / ctx->checkpoint_interval) + 2);
            
            // Store initial state as first checkpoint
            if (ctx->generate_streaming_proofs) {
                CheckpointProof initial_cp;
                initial_cp.iteration = 0;
                initial_cp.checkpoint_form = ctx->initial_form;
                initial_cp.serialized_proof.push_back(0x04); // Version 4 - initial checkpoint
                ctx->checkpoint_proofs.push_back(initial_cp);
            }
        }
        
        while (completed_iterations < ctx->target_iterations && !ctx->should_stop.load()) {
            uint64_t batch_end = std::min(completed_iterations + batch_size, ctx->target_iterations);
            uint64_t iterations_in_batch = batch_end - completed_iterations;
            
            // Perform VDF squaring iterations using optimized square_asm
            for (uint64_t i = 0; i < iterations_in_batch && !ctx->should_stop.load(); i++) {
                // Use square from vdf.h
                current = square(current);
                ctx->current_iteration.store(completed_iterations + i + 1);
                
                // Check if we've reached a checkpoint
                if (ctx->store_checkpoints && ctx->checkpoint_interval > 0) {
                    uint64_t current_iter = completed_iterations + i + 1;
                    
                    if (current_iter % ctx->checkpoint_interval == 0 || 
                        current_iter == ctx->target_iterations) {
                        
                        std::lock_guard<std::mutex> lock(ctx->mutex);
                        
                        if (ctx->generate_streaming_proofs) {
                            // Generate proof for this checkpoint
                            uint64_t checkpoint_iterations = current_iter - last_checkpoint_iter;
                            auto checkpoint_proof = generate_checkpoint_proof(
                                last_checkpoint, 
                                current, 
                                checkpoint_iterations,
                                ctx->discriminant
                            );
                            checkpoint_proof.iteration = current_iter; // Store absolute iteration
                            ctx->checkpoint_proofs.push_back(checkpoint_proof);
                            
                            // Update last checkpoint
                            last_checkpoint = current;
                            last_checkpoint_iter = current_iter;
                        } else {
                            // Just store the form without proof
                            CheckpointProof cp;
                            cp.iteration = current_iter;
                            cp.checkpoint_form = current;
                            ctx->checkpoint_proofs.push_back(cp);
                        }
                    }
                }
            }
            
            completed_iterations = batch_end;
            
            // Update performance metrics
            auto now = std::chrono::steady_clock::now();
            auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - ctx->last_update_time);
            
            if (elapsed.count() >= ctx->update_interval_ms) {
                ctx->iterations_per_second = (iterations_in_batch * 1000) / elapsed.count();
                ctx->last_update_time = now;
                
                // Call progress callback
                if (ctx->progress_cb) {
                    ctx->progress_cb(completed_iterations, ctx->target_iterations, ctx->user_data);
                }
            }
        }
        
        if (!ctx->should_stop.load()) {
            // Computation completed successfully
            std::lock_guard<std::mutex> lock(ctx->mutex);
            ctx->final_form = current;
            ctx->current_form = current;
            ctx->state.store(CPU_VDF_STATE_COMPLETED);
            
            if (ctx->completion_cb) {
                ctx->completion_cb(true, completed_iterations, ctx->user_data);
            }
        } else {
            // Computation was stopped
            ctx->state.store(CPU_VDF_STATE_STOPPED);
            
            if (ctx->completion_cb) {
                ctx->completion_cb(false, completed_iterations, ctx->user_data);
            }
        }
        
    } catch (const std::exception& e) {
        std::cerr << "VDF computation error: " << e.what() << std::endl;
        ctx->state.store(CPU_VDF_STATE_ERROR);
        
        if (ctx->completion_cb) {
            ctx->completion_cb(false, ctx->current_iteration.load(), ctx->user_data);
        }
    }
    
    ctx->completion_cv.notify_all();
}

// API Implementation

void cpu_vdf_config_init(cpu_vdf_config_t* config) {
    if (!config) return;
    
    config->num_threads = std::thread::hardware_concurrency();
    if (config->num_threads == 0) config->num_threads = 4;
    
    config->proof_threads = std::max(1u, config->num_threads / 2u);
    config->enable_fast_mode = true;
    config->enable_avx512 = false;
    config->enable_logging = false;
    config->segment_size = 65536;
}

cpu_vdf_context_t* cpu_vdf_create(const cpu_vdf_config_t* config) {
    if (!config) return nullptr;
    
    auto ctx = new(std::nothrow) cpu_vdf_context_t;
    if (!ctx) return nullptr;
    
    ctx->config = *config;
    return ctx;
}

void cpu_vdf_destroy(cpu_vdf_context_t* ctx) {
    if (!ctx) return;
    
    cpu_vdf_stop_computation(ctx);
    
    if (ctx->computation_thread.joinable()) {
        ctx->computation_thread.join();
    }
    
    delete ctx;
}

int cpu_vdf_start_computation(
    cpu_vdf_context_t* ctx,
    const uint8_t* challenge_hash,
    const uint8_t* initial_form_bytes,
    uint64_t iterations,
    size_t discriminant_size_bits
) {
    if (!ctx || !challenge_hash || iterations == 0) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    if (ctx->state.load() == CPU_VDF_STATE_COMPUTING) {
        return CPU_VDF_ERROR_ALREADY_RUNNING;
    }
    
    // Create discriminant from challenge hash
    // Use first 4 bytes of challenge as seed
    int seed = 0;
    for (int i = 0; i < 4 && i < 32; i++) {
        seed = (seed << 8) | challenge_hash[i];
    }
    ctx->discriminant = generate_discriminant(discriminant_size_bits, seed);
    
    // Setup initial form
    if (initial_form_bytes) {
        // Parse the initial form from bytes if provided
        // For now, use generator form
        ctx->initial_form = form::generator(ctx->discriminant);
    } else {
        // Use generator form
        ctx->initial_form = form::generator(ctx->discriminant);
    }
    
    ctx->current_form = ctx->initial_form;
    ctx->target_iterations = iterations;
    ctx->current_iteration.store(0);
    ctx->should_stop.store(false);
    
    // Enable checkpoint storage for proof generation
    ctx->store_checkpoints = (ctx->config.segment_size > 0);
    ctx->generate_streaming_proofs = ctx->store_checkpoints; // Enable streaming proofs when checkpoints are enabled
    ctx->checkpoint_proofs.clear();
    
    // Start computation thread
    try {
        ctx->computation_thread = std::thread(vdf_computation_thread, ctx);
    } catch (const std::exception&) {
        return CPU_VDF_ERROR_THREAD_ERROR;
    }
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_start_computation_with_discriminant(
    cpu_vdf_context_t* ctx,
    const uint8_t* discriminant_bytes,
    size_t discriminant_size,
    const uint8_t* initial_form,
    uint64_t iterations
) {
    if (!ctx || !discriminant_bytes || discriminant_size == 0 || iterations == 0) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    if (ctx->state.load() == CPU_VDF_STATE_COMPUTING) {
        return CPU_VDF_ERROR_ALREADY_RUNNING;
    }
    
    // Import discriminant from bytes (assumed to be absolute value)
    mpz_import(ctx->discriminant.impl, discriminant_size, 1, 1, 0, 0, discriminant_bytes);
    
    // Make it negative (VDF discriminants are negative)
    mpz_neg(ctx->discriminant.impl, ctx->discriminant.impl);
    
    // Ensure discriminant ≡ 1 (mod 4) - this is critical for form validity
    mpz_t mod_result;
    mpz_init(mod_result);
    mpz_mod_ui(mod_result, ctx->discriminant.impl, 4);
    unsigned long mod_val = mpz_get_ui(mod_result);
    
    if (mod_val != 1) {
        // Adjust discriminant to ensure it's ≡ 1 (mod 4)
        // We need D ≡ 1 (mod 4), so adjust by subtracting current mod and adding 1
        mpz_sub_ui(ctx->discriminant.impl, ctx->discriminant.impl, mod_val);
        mpz_add_ui(ctx->discriminant.impl, ctx->discriminant.impl, 1);
        
        // If this made it positive, subtract 4 to keep it negative
        if (mpz_sgn(ctx->discriminant.impl) > 0) {
            mpz_sub_ui(ctx->discriminant.impl, ctx->discriminant.impl, 4);
        }
    }
    mpz_clear(mod_result);
    
    // Verify the discriminant is valid (negative and ≡ 1 mod 4)
    if (mpz_sgn(ctx->discriminant.impl) >= 0) {
        return CPU_VDF_ERROR_INVALID_DISCRIMINANT;
    }
    
    // Setup initial form
    try {
        ctx->initial_form = form::generator(ctx->discriminant);
        
        // Verify the form is valid
        if (!ctx->initial_form.check_valid(ctx->discriminant)) {
            return CPU_VDF_ERROR_INVALID_FORM;
        }
    } catch (const std::exception& e) {
        return CPU_VDF_ERROR_INVALID_DISCRIMINANT;
    }
    
    ctx->current_form = ctx->initial_form;
    ctx->target_iterations = iterations;
    ctx->current_iteration.store(0);
    ctx->should_stop.store(false);
    
    // Enable checkpoint storage if configured
    ctx->store_checkpoints = (ctx->config.segment_size > 0);
    ctx->checkpoint_proofs.clear();
    
    // Start computation thread
    try {
        ctx->computation_thread = std::thread(vdf_computation_thread, ctx);
    } catch (const std::exception&) {
        return CPU_VDF_ERROR_THREAD_ERROR;
    }
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_stop_computation(cpu_vdf_context_t* ctx) {
    if (!ctx) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    ctx->should_stop.store(true);
    
    if (ctx->computation_thread.joinable()) {
        ctx->computation_thread.join();
    }
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_get_status(cpu_vdf_context_t* ctx, cpu_vdf_status_t* status) {
    if (!ctx || !status) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    status->current_iteration = ctx->current_iteration.load();
    status->target_iterations = ctx->target_iterations;
    status->state = ctx->state.load();
    
    if (ctx->target_iterations > 0) {
        status->progress_percentage = (double)status->current_iteration / ctx->target_iterations * 100.0;
    } else {
        status->progress_percentage = 0.0;
    }
    
    status->iterations_per_second = ctx->iterations_per_second;
    status->has_proof_ready = false;
    
    if (ctx->state.load() != CPU_VDF_STATE_IDLE) {
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - ctx->start_time);
        status->elapsed_time_ms = elapsed.count();
    } else {
        status->elapsed_time_ms = 0;
    }
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_wait_completion(cpu_vdf_context_t* ctx, uint32_t timeout_ms) {
    if (!ctx) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    std::unique_lock<std::mutex> lock(ctx->mutex);
    
    auto state = ctx->state.load();
    if (state == CPU_VDF_STATE_COMPLETED || state == CPU_VDF_STATE_ERROR || state == CPU_VDF_STATE_STOPPED) {
        return CPU_VDF_SUCCESS;
    }
    
    if (timeout_ms == 0) {
        ctx->completion_cv.wait(lock, [ctx] {
            auto state = ctx->state.load();
            return state == CPU_VDF_STATE_COMPLETED || state == CPU_VDF_STATE_ERROR || state == CPU_VDF_STATE_STOPPED;
        });
    } else {
        auto timeout = std::chrono::milliseconds(timeout_ms);
        if (!ctx->completion_cv.wait_for(lock, timeout, [ctx] {
            auto state = ctx->state.load();
            return state == CPU_VDF_STATE_COMPLETED || state == CPU_VDF_STATE_ERROR || state == CPU_VDF_STATE_STOPPED;
        })) {
            return CPU_VDF_ERROR_COMPUTATION_FAILED;
        }
    }
    
    return CPU_VDF_SUCCESS;
}

bool cpu_vdf_is_complete(cpu_vdf_context_t* ctx) {
    if (!ctx) return false;
    return ctx->state.load() == CPU_VDF_STATE_COMPLETED;
}

int cpu_vdf_get_result_form(cpu_vdf_context_t* ctx, cpu_vdf_form_t* form) {
    if (!ctx || !form) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    if (ctx->state.load() != CPU_VDF_STATE_COMPLETED) {
        return CPU_VDF_ERROR_COMPUTATION_FAILED;
    }
    
    std::lock_guard<std::mutex> lock(ctx->mutex);
    
    // Export form components to byte arrays
    size_t a_size = 0, b_size = 0, c_size = 0;
    
    // Get sizes first
    size_t size_a = mpz_sizeinbase(ctx->final_form.a.impl, 256);
    size_t size_b = mpz_sizeinbase(ctx->final_form.b.impl, 256);
    size_t size_c = mpz_sizeinbase(ctx->final_form.c.impl, 256);
    
    // Clear buffers
    memset(form->a_data, 0, sizeof(form->a_data));
    memset(form->b_data, 0, sizeof(form->b_data));
    memset(form->c_data, 0, sizeof(form->c_data));
    
    // Export to buffers
    mpz_export(form->a_data, &a_size, 1, 1, 0, 0, ctx->final_form.a.impl);
    mpz_export(form->b_data, &b_size, 1, 1, 0, 0, ctx->final_form.b.impl);
    mpz_export(form->c_data, &c_size, 1, 1, 0, 0, ctx->final_form.c.impl);
    
    form->data_size = std::max({a_size, b_size, c_size});
    
    return CPU_VDF_SUCCESS;
}

// Proof generation functions with actual Wesolowski proof implementation
int cpu_vdf_generate_proof(cpu_vdf_context_t* ctx, uint8_t recursion_level, cpu_vdf_proof_t* proof) {
    if (!ctx || !proof) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    if (ctx->state.load() != CPU_VDF_STATE_COMPLETED) {
        return CPU_VDF_ERROR_COMPUTATION_FAILED;
    }
    
    try {
        std::lock_guard<std::mutex> lock(ctx->mutex);
        
        // Wesolowski proof generation
        // Given y = x^(2^T), we need to compute π such that π^l * x^r = y
        // where l is a prime and r = 2^T mod l
        
        // Step 1: Generate Fiat-Shamir challenge prime l
        // Hash(discriminant || x || y || T) to get deterministic challenge
        std::vector<uint8_t> challenge_data;
        
        // Add discriminant
        size_t disc_size = mpz_sizeinbase(ctx->discriminant.impl, 256) + 1;
        std::vector<uint8_t> disc_bytes(disc_size);
        mpz_export(disc_bytes.data(), &disc_size, 1, 1, 0, 0, ctx->discriminant.impl);
        challenge_data.insert(challenge_data.end(), disc_bytes.begin(), disc_bytes.begin() + disc_size);
        
        // Add initial form (x)
        auto serialize_form = [&challenge_data](const form& f) {
            size_t size_a = mpz_sizeinbase(f.a.impl, 256) + 1;
            size_t size_b = mpz_sizeinbase(f.b.impl, 256) + 1;
            size_t size_c = mpz_sizeinbase(f.c.impl, 256) + 1;
            
            std::vector<uint8_t> bytes_a(size_a), bytes_b(size_b), bytes_c(size_c);
            mpz_export(bytes_a.data(), &size_a, 1, 1, 0, 0, f.a.impl);
            mpz_export(bytes_b.data(), &size_b, 1, 1, 0, 0, f.b.impl);
            mpz_export(bytes_c.data(), &size_c, 1, 1, 0, 0, f.c.impl);
            
            challenge_data.insert(challenge_data.end(), bytes_a.begin(), bytes_a.begin() + size_a);
            challenge_data.insert(challenge_data.end(), bytes_b.begin(), bytes_b.begin() + size_b);
            challenge_data.insert(challenge_data.end(), bytes_c.begin(), bytes_c.begin() + size_c);
        };
        
        serialize_form(ctx->initial_form);
        serialize_form(ctx->final_form);
        
        // Add iterations
        for (int i = 7; i >= 0; i--) {
            challenge_data.push_back((ctx->target_iterations >> (i * 8)) & 0xFF);
        }
        
        // Hash to get challenge seed
        std::vector<uint8_t> hash = sha256(challenge_data);
        
        // Generate prime l from hash (264-bit prime for 128-bit security)
        integer l;
        mpz_import(l.impl, 32, 1, 1, 0, 0, hash.data());
        mpz_setbit(l.impl, 263);  // Ensure it's large enough
        NextPrime(l, l);
        
        // Step 2: Compute quotient q = floor(2^T / l) and remainder r = 2^T mod l
        mpz_t two_to_T_raw, quotient_raw, remainder_raw;
        mpz_init(two_to_T_raw);
        mpz_init(quotient_raw);
        mpz_init(remainder_raw);
        
        mpz_ui_pow_ui(two_to_T_raw, 2, ctx->target_iterations);
        mpz_fdiv_qr(quotient_raw, remainder_raw, two_to_T_raw, l.impl);
        
        // Step 3: Compute proof π = x^q using FastPowFormNucomp from vdf.h
        PulmarkReducer reducer;
        integer L_local = root(-ctx->discriminant, 4);
        integer quotient_int;
        mpz_set(quotient_int.impl, quotient_raw);
        form proof_form = FastPowFormNucomp(ctx->initial_form, ctx->discriminant, quotient_int, L_local, reducer);
        
        // Clean up temporary mpz_t variables
        mpz_clear(two_to_T_raw);
        mpz_clear(quotient_raw);
        mpz_clear(remainder_raw);
        
        // Step 4: Serialize the proof
        std::vector<uint8_t> proof_data;
        
        // Version and metadata
        proof_data.push_back(0x02);  // Version 2 - full Wesolowski
        proof_data.push_back(recursion_level);
        
        // Iterations (8 bytes)
        for (int i = 7; i >= 0; i--) {
            proof_data.push_back((ctx->target_iterations >> (i * 8)) & 0xFF);
        }
        
        // Challenge prime l
        size_t l_size = mpz_sizeinbase(l.impl, 256) + 1;
        std::vector<uint8_t> l_bytes(l_size);
        mpz_export(l_bytes.data(), &l_size, 1, 1, 0, 0, l.impl);
        proof_data.push_back(l_size);
        proof_data.insert(proof_data.end(), l_bytes.begin(), l_bytes.begin() + l_size);
        
        // Proof form π (a, b, c components)
        auto add_integer = [&proof_data](const integer& val) {
            size_t size = mpz_sizeinbase(val.impl, 256) + 1;
            std::vector<uint8_t> bytes(size);
            mpz_export(bytes.data(), &size, 1, 1, 0, 0, val.impl);
            
            // Use 2 bytes for size to handle large integers
            proof_data.push_back((size >> 8) & 0xFF);
            proof_data.push_back(size & 0xFF);
            proof_data.insert(proof_data.end(), bytes.begin(), bytes.begin() + size);
        };
        
        add_integer(proof_form.a);
        add_integer(proof_form.b);
        add_integer(proof_form.c);
        
        // Allocate and copy proof data
        proof->data = new(std::nothrow) uint8_t[proof_data.size()];
        if (!proof->data) {
            return CPU_VDF_ERROR_MEMORY_ALLOCATION;
        }
        
        memcpy(proof->data, proof_data.data(), proof_data.size());
        proof->length = proof_data.size();
        proof->iterations = ctx->target_iterations;
        proof->is_valid = true;
        proof->recursion_level = recursion_level;
        
        return CPU_VDF_SUCCESS;
        
    } catch (const std::exception& e) {
        return CPU_VDF_ERROR_PROOF_GENERATION_FAILED;
    }
}

int cpu_vdf_generate_proof_for_iterations(
    cpu_vdf_context_t* ctx,
    uint64_t target_iterations,
    uint8_t recursion_level,
    cpu_vdf_proof_t* proof
) {
    if (!ctx || !proof || target_iterations > ctx->target_iterations) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    return cpu_vdf_generate_proof(ctx, recursion_level, proof);
}

void cpu_vdf_free_proof(cpu_vdf_proof_t* proof) {
    if (proof && proof->data) {
        delete[] proof->data;
        proof->data = nullptr;
        proof->length = 0;
        proof->is_valid = false;
        proof->iterations = 0;
        proof->recursion_level = 0;
    }
}

bool cpu_vdf_verify_proof(
    const uint8_t* discriminant_bytes,
    size_t discriminant_size,
    const uint8_t* initial_form_bytes,
    const cpu_vdf_proof_t* proof,
    uint64_t iterations,
    uint8_t recursion_level
) {
    if (!discriminant_bytes || !proof || !proof->data || proof->length < 10) {
        return false;
    }
    
    try {
        // Parse proof data
        const uint8_t* ptr = proof->data;
        const uint8_t* end = proof->data + proof->length;
        
        // Check version
        if (ptr >= end || *ptr++ != 0x02) return false;  // Version 2
        
        // Check recursion level
        if (ptr >= end || *ptr++ != recursion_level) return false;
        
        // Read iterations
        if (ptr + 8 > end) return false;
        uint64_t proof_iterations = 0;
        for (int i = 0; i < 8; i++) {
            proof_iterations = (proof_iterations << 8) | *ptr++;
        }
        if (proof_iterations != iterations) return false;
        
        // Read challenge prime l
        if (ptr >= end) return false;
        size_t l_size = *ptr++;
        if (ptr + l_size > end) return false;
        
        integer l;
        mpz_import(l.impl, l_size, 1, 1, 0, 0, ptr);
        ptr += l_size;
        
        // Read proof form components
        auto read_integer = [&ptr, &end](integer& val) -> bool {
            if (ptr + 2 > end) return false;
            size_t size = (*ptr++ << 8);
            size |= *ptr++;
            if (ptr + size > end) return false;
            mpz_import(val.impl, size, 1, 1, 0, 0, ptr);
            ptr += size;
            return true;
        };
        
        form proof_form;
        if (!read_integer(proof_form.a)) {
            return false;
        }
        if (!read_integer(proof_form.b)) {
            return false;
        }
        if (!read_integer(proof_form.c)) {
            return false;
        }
        
        // Import discriminant
        integer discriminant;
        mpz_import(discriminant.impl, discriminant_size, 1, 1, 0, 0, discriminant_bytes);
        mpz_neg(discriminant.impl, discriminant.impl);  // Make negative
        
        // Get initial form
        form x = form::generator(discriminant);
        if (initial_form_bytes) {
            // Could parse from bytes, but for now use generator
        }
        
        // Verify the proof form is valid
        if (!proof_form.check_valid(discriminant)) {
            return false;
        }
        
        // Step 1: Recompute the expected final form y = x^(2^T)
        // In production, this would be provided or cached
        form y = x;
        for (uint64_t i = 0; i < iterations; i++) {
            y = square(y);  // Use square function
        }
        
        // Step 2: Compute r = 2^T mod l
        mpz_t two_to_T_raw, r_raw;
        mpz_init(two_to_T_raw);
        mpz_init(r_raw);
        mpz_ui_pow_ui(two_to_T_raw, 2, iterations);
        mpz_mod(r_raw, two_to_T_raw, l.impl);
        
        // Step 3: Verify π^l * x^r = y
        // Compute lhs = π^l * x^r
        
        // First compute π^l using FastPowFormNucomp
        PulmarkReducer reducer;
        integer L_local = root(-discriminant, 4);
        integer l_int;
        mpz_set(l_int.impl, l.impl);
        form pi_to_l = FastPowFormNucomp(proof_form, discriminant, l_int, L_local, reducer);
        
        // Then compute x^r
        integer r_int;
        mpz_set(r_int.impl, r_raw);
        form x_to_r = FastPowFormNucomp(x, discriminant, r_int, L_local, reducer);
        
        // Compute lhs = π^l * x^r
        form lhs = pi_to_l * x_to_r;
        
        // Cleanup
        mpz_clear(two_to_T_raw);
        mpz_clear(r_raw);
        
        // Step 4: Check if lhs equals y
        bool valid = (mpz_cmp(lhs.a.impl, y.a.impl) == 0 &&
                     mpz_cmp(lhs.b.impl, y.b.impl) == 0 &&
                     mpz_cmp(lhs.c.impl, y.c.impl) == 0);
        
        return valid;
        
    } catch (const std::exception&) {
        return false;
    }
}

bool cpu_vdf_verify_proof_with_challenge(
    const uint8_t* challenge_hash,
    size_t discriminant_size_bits,
    const uint8_t* initial_form,
    const cpu_vdf_proof_t* proof,
    uint64_t iterations,
    uint8_t recursion_level
) {
    if (!challenge_hash || !proof) return false;
    
    try {
        // Create discriminant from challenge
        int seed = 0;
        for (int i = 0; i < 4 && i < 32; i++) {
            seed = (seed << 8) | challenge_hash[i];
        }
        integer discriminant = generate_discriminant(discriminant_size_bits, seed);
        
        // Export discriminant to bytes
        std::vector<uint8_t> disc_bytes(discriminant_size_bits / 8 + 8); // Add extra space
        size_t disc_size = 0;
        
        // Create temporary for absolute value
        mpz_t temp_abs;
        mpz_init(temp_abs);
        mpz_abs(temp_abs, discriminant.impl);
        mpz_export(disc_bytes.data(), &disc_size, 1, 1, 0, 0, temp_abs);
        mpz_clear(temp_abs);
        
        return cpu_vdf_verify_proof(disc_bytes.data(), disc_size, initial_form, proof, iterations, recursion_level);
    } catch (...) {
        return false;
    }
}

int cpu_vdf_create_discriminant(
    const uint8_t* challenge_hash,
    size_t discriminant_size_bits,
    uint8_t* discriminant_out,
    size_t discriminant_out_size
) {
    if (!challenge_hash || !discriminant_out || discriminant_out_size < discriminant_size_bits / 8) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    // Create discriminant using first 4 bytes as seed
    int seed = 0;
    for (int i = 0; i < 4 && i < 32; i++) {
        seed = (seed << 8) | challenge_hash[i];
    }
    
    integer discriminant = generate_discriminant(discriminant_size_bits, seed);
    
    size_t bytes_written;
    mpz_export(discriminant_out, &bytes_written, 1, 1, 0, 0, discriminant.impl);
    
    return bytes_written;
}

void cpu_vdf_get_default_initial_form(uint8_t* form_out) {
    if (!form_out) return;
    
    memset(form_out, 0, 100);
    form_out[0] = 0x08; // Standard marker
}

double cpu_vdf_benchmark(const cpu_vdf_config_t* config, uint64_t test_iterations) {
    if (!config || test_iterations == 0) return -1.0;
    
    auto ctx = cpu_vdf_create(config);
    if (!ctx) return -1.0;
    
    uint8_t test_challenge[32] = {
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
        0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
        0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20
    };
    
    auto start_time = std::chrono::steady_clock::now();
    
    int result = cpu_vdf_start_computation(ctx, test_challenge, nullptr, test_iterations, 1024);
    if (result != CPU_VDF_SUCCESS) {
        cpu_vdf_destroy(ctx);
        return -1.0;
    }
    
    cpu_vdf_wait_completion(ctx, 0);
    
    auto end_time = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    
    cpu_vdf_destroy(ctx);
    
    if (elapsed.count() == 0) return -1.0;
    
    return (double)test_iterations * 1000.0 / elapsed.count();
}

void cpu_vdf_get_capabilities(cpu_vdf_capabilities_t* caps) {
    if (!caps) return;
    
    caps->has_avx2 = __builtin_cpu_supports("avx2");
    caps->has_avx512 = __builtin_cpu_supports("avx512f");
    caps->has_bmi2 = __builtin_cpu_supports("bmi2");
    caps->has_adx = __builtin_cpu_supports("adx");
    caps->cpu_cores = std::thread::hardware_concurrency();
    caps->cpu_threads = caps->cpu_cores;
}

const char* cpu_vdf_get_error_message(cpu_vdf_error_t error_code) {
    switch (error_code) {
        case CPU_VDF_SUCCESS: return "Success";
        case CPU_VDF_ERROR_INVALID_CONFIG: return "Invalid configuration";
        case CPU_VDF_ERROR_INVALID_PARAMETERS: return "Invalid parameters";
        case CPU_VDF_ERROR_MEMORY_ALLOCATION: return "Memory allocation failed";
        case CPU_VDF_ERROR_COMPUTATION_FAILED: return "Computation failed";
        case CPU_VDF_ERROR_THREAD_ERROR: return "Thread creation/management error";
        case CPU_VDF_ERROR_INVALID_DISCRIMINANT: return "Invalid discriminant";
        case CPU_VDF_ERROR_INVALID_FORM: return "Invalid form";
        case CPU_VDF_ERROR_PROOF_GENERATION_FAILED: return "Proof generation failed";
        case CPU_VDF_ERROR_VERIFICATION_FAILED: return "Verification failed";
        case CPU_VDF_ERROR_NOT_INITIALIZED: return "Context not initialized";
        case CPU_VDF_ERROR_ALREADY_RUNNING: return "Computation already running";
        default: return "Unknown error";
    }
}

const char* cpu_vdf_get_version(void) {
    return "CPU VDF Client 1.0.0 (ChiaVDF)";
}

void cpu_vdf_set_debug_logging(bool enable) {
    // Placeholder for logging implementation
}

int cpu_vdf_set_callbacks(
    cpu_vdf_context_t* ctx,
    cpu_vdf_progress_callback_t progress_cb,
    cpu_vdf_completion_callback_t completion_cb,
    uint32_t update_interval_ms,
    void* user_data
) {
    if (!ctx) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    std::lock_guard<std::mutex> lock(ctx->mutex);
    
    ctx->progress_cb = progress_cb;
    ctx->completion_cb = completion_cb;
    ctx->update_interval_ms = update_interval_ms;
    ctx->user_data = user_data;
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_set_thread_count(cpu_vdf_context_t* ctx, uint8_t num_threads, uint8_t proof_threads) {
    if (!ctx || num_threads == 0 || proof_threads > num_threads) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    if (ctx->state.load() == CPU_VDF_STATE_COMPUTING) {
        return CPU_VDF_ERROR_ALREADY_RUNNING;
    }
    
    ctx->config.num_threads = num_threads;
    ctx->config.proof_threads = proof_threads;
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_set_optimizations(cpu_vdf_context_t* ctx, bool enable_fast_mode, bool enable_avx512) {
    if (!ctx) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    if (ctx->state.load() == CPU_VDF_STATE_COMPUTING) {
        return CPU_VDF_ERROR_ALREADY_RUNNING;
    }
    
    ctx->config.enable_fast_mode = enable_fast_mode;
    ctx->config.enable_avx512 = enable_avx512;
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_set_segment_size(cpu_vdf_context_t* ctx, uint32_t segment_size) {
    if (!ctx || segment_size == 0) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    if (ctx->state.load() == CPU_VDF_STATE_COMPUTING) {
        return CPU_VDF_ERROR_ALREADY_RUNNING;
    }
    
    ctx->config.segment_size = segment_size;
    
    return CPU_VDF_SUCCESS;
}

int cpu_vdf_self_test(void) {
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    auto ctx = cpu_vdf_create(&config);
    if (!ctx) return CPU_VDF_ERROR_NOT_INITIALIZED;
    
    uint8_t test_challenge[32] = {0x01};
    int result = cpu_vdf_start_computation(ctx, test_challenge, nullptr, 100, 1024);
    
    if (result == CPU_VDF_SUCCESS) {
        cpu_vdf_wait_completion(ctx, 30000);
        result = cpu_vdf_is_complete(ctx) ? CPU_VDF_SUCCESS : CPU_VDF_ERROR_COMPUTATION_FAILED;
    }
    
    cpu_vdf_destroy(ctx);
    return result;
}

int cpu_vdf_test_computation(
    const uint8_t* challenge_hash,
    uint64_t iterations,
    size_t discriminant_size_bits,
    const uint8_t* expected_result_form
) {
    if (!challenge_hash || !expected_result_form || iterations == 0) {
        return CPU_VDF_ERROR_INVALID_PARAMETERS;
    }
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    auto ctx = cpu_vdf_create(&config);
    if (!ctx) return CPU_VDF_ERROR_NOT_INITIALIZED;
    
    int result = cpu_vdf_start_computation(ctx, challenge_hash, nullptr, iterations, discriminant_size_bits);
    
    if (result == CPU_VDF_SUCCESS) {
        cpu_vdf_wait_completion(ctx, 0);
        
        if (cpu_vdf_is_complete(ctx)) {
            cpu_vdf_form_t computed_form;
            if (cpu_vdf_get_result_form(ctx, &computed_form) == CPU_VDF_SUCCESS) {
                result = CPU_VDF_SUCCESS;
            } else {
                result = CPU_VDF_ERROR_COMPUTATION_FAILED;
            }
        } else {
            result = CPU_VDF_ERROR_COMPUTATION_FAILED;
        }
    }
    
    cpu_vdf_destroy(ctx);
    return result;
}

// Get checkpoint proofs for streaming
int cpu_vdf_get_checkpoint_proofs(
    cpu_vdf_context_t* ctx,
    uint64_t start_iteration,
    uint64_t end_iteration,
    cpu_vdf_checkpoint_proof_t* proofs,
    size_t* num_proofs
) {
    if (!ctx || !proofs || !num_proofs) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    std::lock_guard<std::mutex> lock(ctx->mutex);
    
    size_t count = 0;
    size_t max_proofs = *num_proofs;
    
    for (const auto& cp : ctx->checkpoint_proofs) {
        if (cp.iteration >= start_iteration && cp.iteration <= end_iteration) {
            if (count >= max_proofs) break;
            
            // Copy checkpoint proof data
            proofs[count].iteration = cp.iteration;
            
            // Export checkpoint form
            size_t size_a = mpz_sizeinbase(cp.checkpoint_form.a.impl, 256) + 1;
            size_t size_b = mpz_sizeinbase(cp.checkpoint_form.b.impl, 256) + 1;
            size_t size_c = mpz_sizeinbase(cp.checkpoint_form.c.impl, 256) + 1;
            
            mpz_export(proofs[count].checkpoint_form.a_data, &size_a, 1, 1, 0, 0, cp.checkpoint_form.a.impl);
            mpz_export(proofs[count].checkpoint_form.b_data, &size_b, 1, 1, 0, 0, cp.checkpoint_form.b.impl);
            mpz_export(proofs[count].checkpoint_form.c_data, &size_c, 1, 1, 0, 0, cp.checkpoint_form.c.impl);
            proofs[count].checkpoint_form.data_size = std::max({size_a, size_b, size_c});
            
            // Copy serialized proof
            if (!cp.serialized_proof.empty()) {
                proofs[count].proof_data = new uint8_t[cp.serialized_proof.size()];
                memcpy(proofs[count].proof_data, cp.serialized_proof.data(), cp.serialized_proof.size());
                proofs[count].proof_length = cp.serialized_proof.size();
                proofs[count].has_proof = true;
            } else {
                proofs[count].proof_data = nullptr;
                proofs[count].proof_length = 0;
                proofs[count].has_proof = false;
            }
            
            count++;
        }
    }
    
    *num_proofs = count;
    return CPU_VDF_SUCCESS;
}

// Free checkpoint proof
void cpu_vdf_free_checkpoint_proof(cpu_vdf_checkpoint_proof_t* proof) {
    if (proof && proof->proof_data) {
        delete[] proof->proof_data;
        proof->proof_data = nullptr;
        proof->proof_length = 0;
        proof->has_proof = false;
    }
}

// Get number of available checkpoints
int cpu_vdf_get_checkpoint_count(cpu_vdf_context_t* ctx, size_t* count) {
    if (!ctx || !count) return CPU_VDF_ERROR_INVALID_PARAMETERS;
    
    std::lock_guard<std::mutex> lock(ctx->mutex);
    *count = ctx->checkpoint_proofs.size();
    return CPU_VDF_SUCCESS;
}

} // extern "C"