#ifndef CPU_VDF_STREAMER_H
#define CPU_VDF_STREAMER_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Export macros
#ifdef _WIN32
    #ifdef CPU_VDF_EXPORTS
        #define CPU_VDF_API __declspec(dllexport)
    #else
        #define CPU_VDF_API __declspec(dllimport)
    #endif
#else
    #define CPU_VDF_API __attribute__((visibility("default")))
#endif

// Forward declarations
typedef struct cpu_vdf_context cpu_vdf_context_t;

// Error codes
typedef enum {
    CPU_VDF_SUCCESS = 0,
    CPU_VDF_ERROR_INVALID_CONFIG = -1,
    CPU_VDF_ERROR_INVALID_PARAMETERS = -2,
    CPU_VDF_ERROR_MEMORY_ALLOCATION = -3,
    CPU_VDF_ERROR_COMPUTATION_FAILED = -4,
    CPU_VDF_ERROR_THREAD_ERROR = -5,
    CPU_VDF_ERROR_INVALID_DISCRIMINANT = -6,
    CPU_VDF_ERROR_INVALID_FORM = -7,
    CPU_VDF_ERROR_PROOF_GENERATION_FAILED = -8,
    CPU_VDF_ERROR_VERIFICATION_FAILED = -9,
    CPU_VDF_ERROR_NOT_INITIALIZED = -10,
    CPU_VDF_ERROR_ALREADY_RUNNING = -11
} cpu_vdf_error_t;

// VDF computation state
typedef enum {
    CPU_VDF_STATE_IDLE = 0,
    CPU_VDF_STATE_COMPUTING = 1,
    CPU_VDF_STATE_COMPLETED = 2,
    CPU_VDF_STATE_ERROR = 3,
    CPU_VDF_STATE_STOPPED = 4
} cpu_vdf_state_t;

// Configuration structure
typedef struct {
    uint8_t num_threads;        // Number of computation threads
    uint8_t proof_threads;      // Number of threads for proof generation
    bool enable_fast_mode;      // Enable fast computation mode
    bool enable_avx512;         // Enable AVX-512 optimizations
    bool enable_logging;        // Enable debug logging
    uint32_t segment_size;      // Checkpoint interval for streaming proofs (0 = disabled)
} cpu_vdf_config_t;

// Form structure (quadratic form representation)
typedef struct {
    uint8_t a_data[256];        // Coefficient a
    uint8_t b_data[256];        // Coefficient b
    uint8_t c_data[256];        // Coefficient c
    size_t data_size;           // Actual size of coefficients
} cpu_vdf_form_t;

// Status structure
typedef struct {
    uint64_t current_iteration;     // Current iteration count
    uint64_t target_iterations;     // Target iteration count
    cpu_vdf_state_t state;          // Current computation state
    double progress_percentage;     // Progress percentage (0-100)
    uint64_t iterations_per_second; // Current computation speed
    uint64_t elapsed_time_ms;       // Elapsed time in milliseconds
    bool has_proof_ready;           // Whether proof is ready
} cpu_vdf_status_t;

// Proof structure
typedef struct {
    uint8_t* data;          // Proof data
    size_t length;          // Proof length in bytes
    uint64_t iterations;    // Number of iterations proven
    bool is_valid;          // Whether proof is valid
    uint8_t recursion_level; // Recursion level for proof
} cpu_vdf_proof_t;

// Checkpoint proof structure for streaming
typedef struct {
    uint64_t iteration;              // Iteration number for this checkpoint
    cpu_vdf_form_t checkpoint_form;  // The form at this checkpoint
    uint8_t* proof_data;            // Serialized proof data
    size_t proof_length;            // Length of proof data
    bool has_proof;                 // Whether proof is included
} cpu_vdf_checkpoint_proof_t;

// Capabilities structure
typedef struct {
    bool has_avx2;      // AVX2 support
    bool has_avx512;    // AVX-512 support
    bool has_bmi2;      // BMI2 support
    bool has_adx;       // ADX support
    uint32_t cpu_cores; // Number of CPU cores
    uint32_t cpu_threads; // Number of CPU threads
} cpu_vdf_capabilities_t;

// Callback function types
typedef void (*cpu_vdf_progress_callback_t)(uint64_t current_iteration, uint64_t total_iterations, void* user_data);
typedef void (*cpu_vdf_completion_callback_t)(bool success, uint64_t iterations_completed, void* user_data);

// Core API functions

// Configuration and context management
CPU_VDF_API void cpu_vdf_config_init(cpu_vdf_config_t* config);
CPU_VDF_API cpu_vdf_context_t* cpu_vdf_create(const cpu_vdf_config_t* config);
CPU_VDF_API void cpu_vdf_destroy(cpu_vdf_context_t* ctx);

// Computation control
CPU_VDF_API int cpu_vdf_start_computation(
    cpu_vdf_context_t* ctx,
    const uint8_t* challenge_hash,      // 32-byte challenge
    const uint8_t* initial_form,        // Optional initial form (NULL for default)
    uint64_t iterations,                // Number of iterations
    size_t discriminant_size_bits       // Discriminant size in bits
);

CPU_VDF_API int cpu_vdf_start_computation_with_discriminant(
    cpu_vdf_context_t* ctx,
    const uint8_t* discriminant_bytes,  // Pre-computed discriminant
    size_t discriminant_size,           // Size in bytes
    const uint8_t* initial_form,        // Optional initial form
    uint64_t iterations                 // Number of iterations
);

CPU_VDF_API int cpu_vdf_stop_computation(cpu_vdf_context_t* ctx);

// Status and results
CPU_VDF_API int cpu_vdf_get_status(cpu_vdf_context_t* ctx, cpu_vdf_status_t* status);
CPU_VDF_API int cpu_vdf_wait_completion(cpu_vdf_context_t* ctx, uint32_t timeout_ms);
CPU_VDF_API bool cpu_vdf_is_complete(cpu_vdf_context_t* ctx);
CPU_VDF_API int cpu_vdf_get_result_form(cpu_vdf_context_t* ctx, cpu_vdf_form_t* form);

// Proof generation and verification
CPU_VDF_API int cpu_vdf_generate_proof(
    cpu_vdf_context_t* ctx,
    uint8_t recursion_level,
    cpu_vdf_proof_t* proof
);

CPU_VDF_API int cpu_vdf_generate_proof_for_iterations(
    cpu_vdf_context_t* ctx,
    uint64_t target_iterations,
    uint8_t recursion_level,
    cpu_vdf_proof_t* proof
);

CPU_VDF_API void cpu_vdf_free_proof(cpu_vdf_proof_t* proof);

CPU_VDF_API bool cpu_vdf_verify_proof(
    const uint8_t* discriminant_bytes,
    size_t discriminant_size,
    const uint8_t* initial_form,
    const cpu_vdf_proof_t* proof,
    uint64_t iterations,
    uint8_t recursion_level
);

CPU_VDF_API bool cpu_vdf_verify_proof_with_challenge(
    const uint8_t* challenge_hash,
    size_t discriminant_size_bits,
    const uint8_t* initial_form,
    const cpu_vdf_proof_t* proof,
    uint64_t iterations,
    uint8_t recursion_level
);

// Utility functions
CPU_VDF_API int cpu_vdf_create_discriminant(
    const uint8_t* challenge_hash,
    size_t discriminant_size_bits,
    uint8_t* discriminant_out,
    size_t discriminant_out_size
);

CPU_VDF_API void cpu_vdf_get_default_initial_form(uint8_t* form_out);
CPU_VDF_API double cpu_vdf_benchmark(const cpu_vdf_config_t* config, uint64_t test_iterations);
CPU_VDF_API void cpu_vdf_get_capabilities(cpu_vdf_capabilities_t* caps);
CPU_VDF_API const char* cpu_vdf_get_error_message(cpu_vdf_error_t error_code);
CPU_VDF_API const char* cpu_vdf_get_version(void);
CPU_VDF_API void cpu_vdf_set_debug_logging(bool enable);

// Configuration functions
CPU_VDF_API int cpu_vdf_set_callbacks(
    cpu_vdf_context_t* ctx,
    cpu_vdf_progress_callback_t progress_cb,
    cpu_vdf_completion_callback_t completion_cb,
    uint32_t update_interval_ms,
    void* user_data
);

CPU_VDF_API int cpu_vdf_set_thread_count(
    cpu_vdf_context_t* ctx,
    uint8_t num_threads,
    uint8_t proof_threads
);

CPU_VDF_API int cpu_vdf_set_optimizations(
    cpu_vdf_context_t* ctx,
    bool enable_fast_mode,
    bool enable_avx512
);

CPU_VDF_API int cpu_vdf_set_segment_size(
    cpu_vdf_context_t* ctx,
    uint32_t segment_size
);

// Test functions
CPU_VDF_API int cpu_vdf_self_test(void);
CPU_VDF_API int cpu_vdf_test_computation(
    const uint8_t* challenge_hash,
    uint64_t iterations,
    size_t discriminant_size_bits,
    const uint8_t* expected_result_form
);

// Checkpoint/streaming proof functions
CPU_VDF_API int cpu_vdf_get_checkpoint_proofs(
    cpu_vdf_context_t* ctx,
    uint64_t start_iteration,
    uint64_t end_iteration,
    cpu_vdf_checkpoint_proof_t* proofs,
    size_t* num_proofs
);
CPU_VDF_API void cpu_vdf_free_checkpoint_proof(cpu_vdf_checkpoint_proof_t* proof);
CPU_VDF_API int cpu_vdf_get_checkpoint_count(cpu_vdf_context_t* ctx, size_t* count);

#ifdef __cplusplus
}
#endif

#endif // CPU_VDF_STREAMER_H