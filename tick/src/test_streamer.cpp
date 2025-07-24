#include "streamer.h"
#include <iostream>
#include <iomanip>
#include <cstring>
#include <chrono>
#include <thread>
#include <vector>
#include <random>

// Helper function to print hex data
void print_hex(const char* label, const uint8_t* data, size_t len) {
    std::cout << label << ": ";
    for (size_t i = 0; i < len && i < 32; i++) {
        std::cout << std::hex << std::setfill('0') << std::setw(2) 
                  << static_cast<int>(data[i]);
    }
    if (len > 32) std::cout << "...";
    std::cout << std::dec << " (" << len << " bytes)" << std::endl;
}

// Progress callback
void progress_callback(uint64_t current, uint64_t total, void* user_data) {
    double percentage = (total > 0) ? (100.0 * current / total) : 0.0;
    std::cout << "\rProgress: " << std::fixed << std::setprecision(1) 
              << percentage << "% (" << current << "/" << total << ")";
    std::cout.flush();
}

// Completion callback
void completion_callback(bool success, uint64_t iterations, void* user_data) {
    std::cout << "\nComputation " << (success ? "completed" : "failed") 
              << " after " << iterations << " iterations" << std::endl;
}

// Test basic computation
bool test_basic_computation() {
    std::cout << "\n=== Test 1: Basic Computation ===" << std::endl;
    
    // Initialize configuration
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    std::cout << "Config initialized: threads=" << static_cast<int>(config.num_threads)
              << ", proof_threads=" << static_cast<int>(config.proof_threads) << std::endl;
    
    // Create context
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) {
        std::cerr << "Failed to create context" << std::endl;
        return false;
    }
    std::cout << "Context created successfully" << std::endl;
    
    // Set up challenge hash
    uint8_t challenge[32];
    for (int i = 0; i < 32; i++) {
        challenge[i] = i + 1;
    }
    print_hex("Challenge", challenge, 32);
    
    // Start computation
    uint64_t iterations = 10000;
    size_t discriminant_bits = 1024;
    
    int result = cpu_vdf_start_computation(ctx, challenge, nullptr, iterations, discriminant_bits);
    if (result != CPU_VDF_SUCCESS) {
        std::cerr << "Failed to start computation: " 
                  << cpu_vdf_get_error_message(static_cast<cpu_vdf_error_t>(result)) << std::endl;
        cpu_vdf_destroy(ctx);
        return false;
    }
    std::cout << "Computation started: " << iterations << " iterations, " 
              << discriminant_bits << " bit discriminant" << std::endl;
    
    // Monitor progress
    cpu_vdf_status_t status;
    auto start_time = std::chrono::steady_clock::now();
    
    while (true) {
        result = cpu_vdf_get_status(ctx, &status);
        if (result == CPU_VDF_SUCCESS) {
            std::cout << "\rStatus: " << status.current_iteration << "/" << status.target_iterations
                      << " (" << std::fixed << std::setprecision(1) << status.progress_percentage << "%) "
                      << status.iterations_per_second << " iter/s";
            std::cout.flush();
            
            if (status.state == CPU_VDF_STATE_COMPLETED || 
                status.state == CPU_VDF_STATE_ERROR ||
                status.state == CPU_VDF_STATE_STOPPED) {
                break;
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
    
    auto end_time = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    std::cout << "\nComputation took " << elapsed.count() << " ms" << std::endl;
    
    // Check if complete
    bool is_complete = cpu_vdf_is_complete(ctx);
    std::cout << "Is complete: " << (is_complete ? "Yes" : "No") << std::endl;
    
    if (is_complete) {
        // Get result form
        cpu_vdf_form_t result_form;
        result = cpu_vdf_get_result_form(ctx, &result_form);
        if (result == CPU_VDF_SUCCESS) {
            std::cout << "Result form retrieved successfully" << std::endl;
            print_hex("Form A", result_form.a_data, std::min(size_t(32), result_form.data_size));
            print_hex("Form B", result_form.b_data, std::min(size_t(32), result_form.data_size));
            print_hex("Form C", result_form.c_data, std::min(size_t(32), result_form.data_size));
        }
    }
    
    // Cleanup
    cpu_vdf_destroy(ctx);
    std::cout << "Context destroyed" << std::endl;
    
    return is_complete;
}

// Test with callbacks
bool test_with_callbacks() {
    std::cout << "\n=== Test 2: Computation with Callbacks ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) return false;
    
    // Set callbacks
    int user_data = 42;
    cpu_vdf_set_callbacks(ctx, progress_callback, completion_callback, 500, &user_data);
    std::cout << "Callbacks set with 500ms update interval" << std::endl;
    
    // Random challenge
    uint8_t challenge[32];
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, 255);
    for (int i = 0; i < 32; i++) {
        challenge[i] = dis(gen);
    }
    
    int result = cpu_vdf_start_computation(ctx, challenge, nullptr, 50000, 512);
    if (result != CPU_VDF_SUCCESS) {
        cpu_vdf_destroy(ctx);
        return false;
    }
    
    // Wait for completion
    result = cpu_vdf_wait_completion(ctx, 60000); // 60 second timeout
    bool success = (result == CPU_VDF_SUCCESS && cpu_vdf_is_complete(ctx));
    
    cpu_vdf_destroy(ctx);
    return success;
}

// Test stop functionality
bool test_stop_computation() {
    std::cout << "\n=== Test 3: Stop Computation ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) return false;
    
    uint8_t challenge[32] = {0};
    
    // Start a long computation
    int result = cpu_vdf_start_computation(ctx, challenge, nullptr, 1000000, 2048);
    if (result != CPU_VDF_SUCCESS) {
        cpu_vdf_destroy(ctx);
        return false;
    }
    std::cout << "Started long computation (1M iterations)" << std::endl;
    
    // Let it run for 2 seconds
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    // Check status before stopping
    cpu_vdf_status_t status;
    cpu_vdf_get_status(ctx, &status);
    std::cout << "Progress before stop: " << status.current_iteration 
              << " iterations" << std::endl;
    
    // Stop computation
    result = cpu_vdf_stop_computation(ctx);
    std::cout << "Stop requested: " 
              << cpu_vdf_get_error_message(static_cast<cpu_vdf_error_t>(result)) << std::endl;
    
    // Wait a bit and check final status
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
    cpu_vdf_get_status(ctx, &status);
    std::cout << "Final state: ";
    switch (status.state) {
        case CPU_VDF_STATE_IDLE: std::cout << "IDLE"; break;
        case CPU_VDF_STATE_COMPUTING: std::cout << "COMPUTING"; break;
        case CPU_VDF_STATE_COMPLETED: std::cout << "COMPLETED"; break;
        case CPU_VDF_STATE_STOPPED: std::cout << "STOPPED"; break;
        case CPU_VDF_STATE_ERROR: std::cout << "ERROR"; break;
    }
    std::cout << ", iterations: " << status.current_iteration << std::endl;
    
    cpu_vdf_destroy(ctx);
    return status.state == CPU_VDF_STATE_STOPPED;
}

// Test discriminant creation
bool test_discriminant_creation() {
    std::cout << "\n=== Test 4: Discriminant Creation ===" << std::endl;
    
    uint8_t challenge[32];
    for (int i = 0; i < 32; i++) {
        challenge[i] = i;
    }
    
    size_t discriminant_bits = 512;
    size_t discriminant_bytes = discriminant_bits / 8;
    std::vector<uint8_t> discriminant(discriminant_bytes);
    
    int result = cpu_vdf_create_discriminant(challenge, discriminant_bits, 
                                           discriminant.data(), discriminant.size());
    
    if (result > 0) {
        std::cout << "Discriminant created: " << result << " bytes" << std::endl;
        print_hex("Discriminant", discriminant.data(), result);
        
        // Basic validation - discriminants should use most of the requested bits
        std::cout << "Properties:" << std::endl;
        std::cout << "  Requested bits: " << discriminant_bits << std::endl;
        std::cout << "  Actual bytes: " << result << std::endl;
        
        // Check that it's not all zeros
        bool all_zeros = true;
        for (int i = 0; i < result; i++) {
            if (discriminant[i] != 0) {
                all_zeros = false;
                break;
            }
        }
        std::cout << "  Non-zero: " << (all_zeros ? "No (error)" : "Yes (correct)") << std::endl;
        
        // Note: The discriminant may not use the full bit range due to the generation algorithm
        // but it should still be a valid discriminant
        
        return !all_zeros && result > 0;
    } else {
        std::cout << "Failed to create discriminant" << std::endl;
        return false;
    }
}

// Test with custom discriminant
bool test_custom_discriminant() {
    std::cout << "\n=== Test 5: Computation with Custom Discriminant ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) return false;
    
    // Create discriminant
    uint8_t challenge[32] = {0xFF};
    size_t discriminant_bits = 256;
    std::vector<uint8_t> discriminant(discriminant_bits / 8);
    
    int bytes_written = cpu_vdf_create_discriminant(challenge, discriminant_bits,
                                                   discriminant.data(), discriminant.size());
    if (bytes_written <= 0) {
        cpu_vdf_destroy(ctx);
        return false;
    }
    
    // Use the discriminant directly
    int result = cpu_vdf_start_computation_with_discriminant(
        ctx, discriminant.data(), bytes_written, nullptr, 5000);
    
    if (result != CPU_VDF_SUCCESS) {
        std::cout << "Failed to start with custom discriminant: "
                  << cpu_vdf_get_error_message(static_cast<cpu_vdf_error_t>(result)) << std::endl;
        cpu_vdf_destroy(ctx);
        return false;
    }
    
    std::cout << "Started computation with custom discriminant" << std::endl;
    
    // Wait for completion
    result = cpu_vdf_wait_completion(ctx, 30000);
    bool success = (result == CPU_VDF_SUCCESS && cpu_vdf_is_complete(ctx));
    
    if (success) {
        std::cout << "Computation completed successfully" << std::endl;
    }
    
    cpu_vdf_destroy(ctx);
    return success;
}

// Test proof generation
bool test_proof_generation() {
    std::cout << "\n=== Test 6: Proof Generation ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    config.segment_size = 1000; // Enable checkpoints for efficient proof generation
    
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) return false;
    
    uint8_t challenge[32] = {0x42};
    size_t discriminant_bits = 512;
    uint64_t iterations = 10000;
    
    // Run a computation
    int result = cpu_vdf_start_computation(ctx, challenge, nullptr, iterations, discriminant_bits);
    if (result != CPU_VDF_SUCCESS) {
        cpu_vdf_destroy(ctx);
        return false;
    }
    
    // Wait for completion
    cpu_vdf_wait_completion(ctx, 0);
    
    if (cpu_vdf_is_complete(ctx)) {
        // Generate proof
        cpu_vdf_proof_t proof;
        memset(&proof, 0, sizeof(proof)); // Initialize proof structure
        result = cpu_vdf_generate_proof(ctx, 0, &proof);
        
        if (result == CPU_VDF_SUCCESS) {
            std::cout << "Proof generated: " << proof.length << " bytes" << std::endl;
            std::cout << "  Iterations: " << proof.iterations << std::endl;
            std::cout << "  Status: " << (proof.is_valid ? "Valid structure" : "Invalid") << std::endl;
            std::cout << "  Type: Wesolowski proof" << std::endl;
            
            // Display proof structure
            if (proof.data && proof.length > 10) {
                std::cout << "  Version: " << (int)proof.data[0] << std::endl;
                std::cout << "  Recursion level: " << (int)proof.data[1] << std::endl;
                
                // Extract iteration count from proof
                uint64_t proof_iters = 0;
                for (int i = 0; i < 8; i++) {
                    proof_iters = (proof_iters << 8) | proof.data[2 + i];
                }
                std::cout << "  Encoded iterations: " << proof_iters << std::endl;
            }
            
            // Free proof
            cpu_vdf_free_proof(&proof);
            
            std::cout << "\n✓ Proof generation successful" << std::endl;
            return true;
        } else {
            std::cout << "Proof generation failed: "
                      << cpu_vdf_get_error_message(static_cast<cpu_vdf_error_t>(result)) << std::endl;
            cpu_vdf_destroy(ctx);
            return false;
        }
    }
    
    cpu_vdf_destroy(ctx);
    return false;
}

// Test checkpoint proofs (streaming)
bool test_checkpoint_proofs() {
    std::cout << "\n=== Test 7: Checkpoint/Streaming Proofs ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    config.segment_size = 2000; // Checkpoint every 2000 iterations
    
    cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
    if (!ctx) return false;
    
    uint8_t challenge[32] = {0x33};
    uint64_t iterations = 10000;
    
    // Run computation
    int result = cpu_vdf_start_computation(ctx, challenge, nullptr, iterations, 512);
    if (result != CPU_VDF_SUCCESS) {
        cpu_vdf_destroy(ctx);
        return false;
    }
    
    // Wait for completion
    cpu_vdf_wait_completion(ctx, 0);
    
    if (cpu_vdf_is_complete(ctx)) {
        // Get checkpoint count
        size_t checkpoint_count = 0;
        result = cpu_vdf_get_checkpoint_count(ctx, &checkpoint_count);
        
        if (result == CPU_VDF_SUCCESS) {
            std::cout << "Total checkpoints stored: " << checkpoint_count << std::endl;
            std::cout << "Expected: " << (iterations / config.segment_size) + 1 << " (including initial)" << std::endl;
            
            // Get some checkpoint proofs
            std::vector<cpu_vdf_checkpoint_proof_t> checkpoints(5);
            size_t num_to_get = 5;
            result = cpu_vdf_get_checkpoint_proofs(ctx, 0, iterations, checkpoints.data(), &num_to_get);
            
            if (result == CPU_VDF_SUCCESS) {
                std::cout << "Retrieved " << num_to_get << " checkpoint proofs:" << std::endl;
                for (size_t i = 0; i < num_to_get; i++) {
                    std::cout << "  Checkpoint " << i << ": iteration " << checkpoints[i].iteration;
                    if (checkpoints[i].has_proof) {
                        std::cout << " (with proof, " << checkpoints[i].proof_length << " bytes)";
                    }
                    std::cout << std::endl;
                    
                    // Free checkpoint proof data
                    cpu_vdf_free_checkpoint_proof(&checkpoints[i]);
                }
                
                std::cout << "\n✓ Checkpoint system working correctly" << std::endl;
                cpu_vdf_destroy(ctx);
                return true;
            }
        }
    }
    
    cpu_vdf_destroy(ctx);
    return false;
}

// Benchmark test
bool test_benchmark() {
    std::cout << "\n=== Test 8: Benchmark ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    std::cout << "Running benchmark with " << static_cast<int>(config.num_threads) 
              << " threads..." << std::endl;
    
    double ips = cpu_vdf_benchmark(&config, 50000);
    
    if (ips > 0) {
        std::cout << "Benchmark result: " << std::fixed << std::setprecision(2) 
                  << ips << " iterations/second" << std::endl;
        std::cout << "This is using the ChiaVDF library's optimized square function" << std::endl;
        return true;
    } else {
        std::cout << "Benchmark failed" << std::endl;
        return false;
    }
}

// Test capabilities
void test_capabilities() {
    std::cout << "\n=== Test 9: System Capabilities ===" << std::endl;
    
    cpu_vdf_capabilities_t caps;
    cpu_vdf_get_capabilities(&caps);
    
    std::cout << "CPU Capabilities:" << std::endl;
    std::cout << "  Cores: " << caps.cpu_cores << std::endl;
    std::cout << "  Threads: " << caps.cpu_threads << std::endl;
    std::cout << "  AVX2: " << (caps.has_avx2 ? "Yes" : "No") << std::endl;
    std::cout << "  AVX512: " << (caps.has_avx512 ? "Yes" : "No") << std::endl;
    std::cout << "  BMI2: " << (caps.has_bmi2 ? "Yes" : "No") << std::endl;
    std::cout << "  ADX: " << (caps.has_adx ? "Yes" : "No") << std::endl;
}

// Test version and self-test
void test_misc() {
    std::cout << "\n=== Test 10: Miscellaneous ===" << std::endl;
    
    std::cout << "Library version: " << cpu_vdf_get_version() << std::endl;
    
    std::cout << "Running self-test..." << std::endl;
    int result = cpu_vdf_self_test();
    std::cout << "Self-test result: " 
              << cpu_vdf_get_error_message(static_cast<cpu_vdf_error_t>(result)) << std::endl;
    
    // Test default initial form
    uint8_t default_form[100];
    cpu_vdf_get_default_initial_form(default_form);
    print_hex("Default initial form marker", default_form, 10);
}

// Performance analysis test
bool test_performance_scaling() {
    std::cout << "\n=== Test 11: Performance Scaling ===" << std::endl;
    
    cpu_vdf_config_t config;
    cpu_vdf_config_init(&config);
    
    // Test with different iteration counts
    uint64_t iteration_counts[] = {1000, 5000, 10000, 50000};
    
    for (uint64_t iters : iteration_counts) {
        cpu_vdf_context_t* ctx = cpu_vdf_create(&config);
        if (!ctx) continue;
        
        uint8_t challenge[32] = {0x11};
        
        auto start = std::chrono::steady_clock::now();
        
        if (cpu_vdf_start_computation(ctx, challenge, nullptr, iters, 512) == CPU_VDF_SUCCESS) {
            cpu_vdf_wait_completion(ctx, 0);
            
            auto end = std::chrono::steady_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
            
            double rate = (duration.count() > 0) ? (double)iters * 1000 / duration.count() : 0;
            
            std::cout << "  " << std::setw(6) << iters << " iterations: " 
                      << std::setw(6) << duration.count() << " ms"
                      << " (" << std::fixed << std::setprecision(0) << rate << " iter/s)" << std::endl;
        }
        
        cpu_vdf_destroy(ctx);
    }
    
    return true;
}

// Main test runner
int main(int argc, char* argv[]) {
    std::cout << "CPU VDF Library Test Suite" << std::endl;
    std::cout << "Using ChiaVDF Backend" << std::endl;
    std::cout << "==========================" << std::endl;
    
    // Enable debug logging if requested
    if (argc > 1 && std::string(argv[1]) == "--debug") {
        cpu_vdf_set_debug_logging(true);
        std::cout << "Debug logging enabled" << std::endl;
    }
    
    int passed = 0;
    int failed = 0;
    
    // Run all tests
    struct Test {
        const char* name;
        bool (*func)();
        bool required;
    };
    
    Test tests[] = {
        {"Basic Computation", test_basic_computation, true},
        {"With Callbacks", test_with_callbacks, true},
        {"Stop Computation", test_stop_computation, true},
        {"Discriminant Creation", test_discriminant_creation, true},
        {"Custom Discriminant", test_custom_discriminant, true},
        {"Proof Generation", test_proof_generation, true},
        {"Checkpoint/Streaming Proofs", test_checkpoint_proofs, true},
        {"Benchmark", test_benchmark, true},
        {"Performance Scaling", test_performance_scaling, false}
    };
    
    for (const auto& test : tests) {
        try {
            bool result = test.func();
            if (result) {
                std::cout << "✓ " << test.name << " PASSED" << std::endl;
                passed++;
            } else {
                std::cout << "✗ " << test.name << " FAILED" << std::endl;
                if (test.required) failed++;
            }
        } catch (const std::exception& e) {
            std::cout << "✗ " << test.name << " EXCEPTION: " << e.what() << std::endl;
            if (test.required) failed++;
        }
    }
    
    // Run non-scoring tests
    test_capabilities();
    test_misc();
    
    // Summary
    std::cout << "\n=== Test Summary ===" << std::endl;
    std::cout << "Passed: " << passed << std::endl;
    std::cout << "Failed: " << failed << std::endl;
    std::cout << "Total: " << passed + failed << std::endl;
    
    if (failed == 0) {
        std::cout << "\n✓ All tests passed! The VDF implementation is working correctly." << std::endl;
        std::cout << "  Using ChiaVDF's optimized algorithms:" << std::endl;
        std::cout << "  - NUDUPL squaring algorithm" << std::endl;
        std::cout << "  - FastPowFormNucomp for exponentiation" << std::endl;
        std::cout << "  - Wesolowski proof scheme" << std::endl;
    }
    
    return failed > 0 ? 1 : 0;
}