#include "rsw_solver.h"
#include <iostream>
#include <chrono>

int main(int argc, char** argv) {
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0] << " <n_hex> <a_hex> <C_hex> <T>\n";
        return 1;
    }
    
    try {
        // Create solver instance
        rsw::Solver solver(0);  // Use GPU 0
        
        std::cout << "Using GPU: " << solver.get_device_name() << "\n";
        std::cout << "Optimal batch size: " << solver.get_optimal_batch_size() << "\n\n";
        
        // Setup puzzle parameters
        rsw::PuzzleParams params{
            .n = argv[1],
            .a = argv[2],
            .C = argv[3],
            .T = static_cast<uint32_t>(std::stoul(argv[4]))
        };
        
        // Example 1: Solve single puzzle
        {
            std::cout << "=== Solving single puzzle ===\n";
            auto start = std::chrono::high_resolution_clock::now();
            
            rsw::SolveResult result = solver.solve(params);
            
            auto end = std::chrono::high_resolution_clock::now();
            auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
            
            if (result.success) {
                std::cout << "Success! Time: " << ms << " ms\n";
                std::cout << "Key: " << rsw::util::bytes_to_hex(result.key, 32) << "\n\n";
            } else {
                std::cerr << "Failed: " << result.error_msg << "\n";
                return 1;
            }
        }
        
        // Example 2: Batch solving for better throughput
        {
            std::cout << "=== Batch solving (1000 puzzles) ===\n";
            
            // Create batch of same puzzle for simplicity
            std::vector<rsw::PuzzleParams> batch(1000, params);
            
            auto start = std::chrono::high_resolution_clock::now();
            
            std::vector<rsw::SolveResult> results = solver.solve_batch(batch);
            
            auto end = std::chrono::high_resolution_clock::now();
            auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
            
            // Check all succeeded
            size_t success_count = 0;
            for (const auto& result : results) {
                if (result.success) success_count++;
            }
            
            std::cout << "Solved " << success_count << "/" << batch.size() << " puzzles\n";
            std::cout << "Total time: " << ms << " ms\n";
            std::cout << "Average time per puzzle: " << (double)ms / batch.size() << " ms\n";
            std::cout << "Throughput: " << (1000.0 * batch.size()) / ms << " puzzles/sec\n";
            
            // Verify first and last match (since same puzzle)
            if (results.front().success && results.back().success) {
                std::string first_key = rsw::util::bytes_to_hex(results.front().key, 32);
                std::string last_key = rsw::util::bytes_to_hex(results.back().key, 32);
                std::cout << "\nFirst key:  " << first_key << "\n";
                std::cout << "Last key:   " << last_key << "\n";
                std::cout << "Keys match: " << (first_key == last_key ? "YES" : "NO") << "\n";
            }
        }
        
        // Example 3: Using the key with your Rust decryption
        {
            std::cout << "\n=== Key for Rust decryption ===\n";
            rsw::SolveResult result = solver.solve(params);
            if (result.success) {
                std::cout << "Key bytes: ";
                for (int i = 0; i < 32; i++) {
                    std::cout << (int)result.key[i];
                    if (i < 31) std::cout << ", ";
                }
                std::cout << "\n";
                
            }
        }
        
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }
    
    return 0;
}