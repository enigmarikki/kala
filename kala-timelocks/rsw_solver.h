#ifndef RSW_SOLVER_H
#define RSW_SOLVER_H

#include <cstdint>
#include <vector>
#include <memory>
#include <string>

namespace rsw {

// Forward declaration for implementation hiding
class SolverImpl;

// RSW puzzle parameters
struct PuzzleParams {
    const char* n;      // modulus (hex string)
    const char* a;      // base (hex string)
    const char* C;      // challenge (hex string)
    uint32_t T;         // time parameter
};

// Result of solving a puzzle
struct SolveResult {
    uint8_t key[32];    // 256-bit key
    bool success;
    std::string error_msg;
};

// Main solver class
class Solver {
public:
    // Constructor - optionally specify GPU device
    explicit Solver(int device_id = 0);
    ~Solver();
    
    // Non-copyable
    Solver(const Solver&) = delete;
    Solver& operator=(const Solver&) = delete;
    
    // Move constructible
    Solver(Solver&&) noexcept;
    Solver& operator=(Solver&&) noexcept;
    
    // Solve a single puzzle
    SolveResult solve(const PuzzleParams& params);
    
    // Solve multiple puzzles in batch for better GPU utilization
    std::vector<SolveResult> solve_batch(const std::vector<PuzzleParams>& params_batch);
    
    // Get maximum recommended batch size for current GPU
    size_t get_optimal_batch_size() const;
    
    // Get GPU properties
    std::string get_device_name() const;
    int get_device_id() const;

private:
    std::unique_ptr<SolverImpl> impl;
};

// Utility functions
namespace util {
    // Convert hex string to bytes
    std::vector<uint8_t> hex_to_bytes(const std::string& hex);
    
    // Convert bytes to hex string
    std::string bytes_to_hex(const uint8_t* data, size_t len);
}

} // namespace rsw

#endif // RSW_SOLVER_H