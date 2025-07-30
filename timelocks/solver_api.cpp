#include "rsw_solver.h"
#include <cstring>
#include <cstdlib>

// C-compatible structures
extern "C" {

struct RSWSolver {
    rsw::Solver* solver;
};

struct RSWResult {
    uint8_t key[32];
    bool success;
    char* error_msg;  // Allocated string, caller must free
};

struct RSWBatchResult {
    RSWResult* results;
    size_t count;
};

// Create a new solver instance
RSWSolver* rsw_solver_new(int device_id) {
    try {
        RSWSolver* wrapper = new RSWSolver;
        wrapper->solver = new rsw::Solver(device_id);
        return wrapper;
    } catch (const std::exception& e) {
        return nullptr;
    }
}

// Destroy solver instance
void rsw_solver_free(RSWSolver* solver) {
    if (solver) {
        delete solver->solver;
        delete solver;
    }
}

// Solve a single puzzle
RSWResult rsw_solver_solve(RSWSolver* solver, 
                          const char* n_hex,
                          const char* a_hex,
                          const char* c_hex,
                          uint32_t t) {
    RSWResult result = {};
    
    if (!solver || !solver->solver) {
        result.success = false;
        result.error_msg = strdup("Invalid solver instance");
        return result;
    }
    
    try {
        rsw::PuzzleParams params {
            .n = n_hex,
            .a = a_hex,
            .C = c_hex,
            .T = t
        };
        
        rsw::SolveResult solve_result = solver->solver->solve(params);
        
        result.success = solve_result.success;
        memcpy(result.key, solve_result.key, 32);
        
        if (!solve_result.success) {
            result.error_msg = strdup(solve_result.error_msg.c_str());
        } else {
            result.error_msg = nullptr;
        }
        
    } catch (const std::exception& e) {
        result.success = false;
        result.error_msg = strdup(e.what());
    }
    
    return result;
}

// Solve multiple puzzles in batch
RSWBatchResult rsw_solver_solve_batch(RSWSolver* solver,
                                     const char** n_hex_array,
                                     const char** a_hex_array,
                                     const char** c_hex_array,
                                     const uint32_t* t_array,
                                     size_t count) {
    RSWBatchResult batch_result = {};
    
    if (!solver || !solver->solver || count == 0) {
        batch_result.results = nullptr;
        batch_result.count = 0;
        return batch_result;
    }
    
    try {
        // Build params vector
        std::vector<rsw::PuzzleParams> params_vec;
        params_vec.reserve(count);
        
        for (size_t i = 0; i < count; i++) {
            params_vec.push_back({
                .n = n_hex_array[i],
                .a = a_hex_array[i],
                .C = c_hex_array[i],
                .T = t_array[i]
            });
        }
        
        // Solve batch
        std::vector<rsw::SolveResult> results = solver->solver->solve_batch(params_vec);
        
        // Allocate results array
        batch_result.results = (RSWResult*)calloc(count, sizeof(RSWResult));
        batch_result.count = count;
        
        // Copy results
        for (size_t i = 0; i < count; i++) {
            batch_result.results[i].success = results[i].success;
            memcpy(batch_result.results[i].key, results[i].key, 32);
            
            if (!results[i].success && !results[i].error_msg.empty()) {
                batch_result.results[i].error_msg = strdup(results[i].error_msg.c_str());
            } else {
                batch_result.results[i].error_msg = nullptr;
            }
        }
        
    } catch (const std::exception& e) {
        // Clean up any partial allocation
        if (batch_result.results) {
            free(batch_result.results);
        }
        batch_result.results = nullptr;
        batch_result.count = 0;
    }
    
    return batch_result;
}

// Free batch results
void rsw_batch_result_free(RSWBatchResult* batch_result) {
    if (batch_result && batch_result->results) {
        for (size_t i = 0; i < batch_result->count; i++) {
            if (batch_result->results[i].error_msg) {
                free(batch_result->results[i].error_msg);
            }
        }
        free(batch_result->results);
        batch_result->results = nullptr;
        batch_result->count = 0;
    }
}

// Free error message string
void rsw_result_free_error(char* error_msg) {
    free(error_msg);
}

// Get device name
const char* rsw_solver_get_device_name(RSWSolver* solver) {
    static thread_local std::string device_name;
    if (solver && solver->solver) {
        device_name = solver->solver->get_device_name();
        return device_name.c_str();
    }
    return "Unknown";
}

// Get optimal batch size
size_t rsw_solver_get_optimal_batch_size(RSWSolver* solver) {
    if (solver && solver->solver) {
        return solver->solver->get_optimal_batch_size();
    }
    return 0;
}

} // extern "C"#include "rsw_solver.h"
#include <cstring>
#include <cstdlib>

// C-compatible structures
extern "C" {

struct RSWSolver {
    rsw::Solver* solver;
};

struct RSWResult {
    uint8_t key[32];
    bool success;
    char* error_msg;  // Allocated string, caller must free
};

// Destroy solver instance
void rsw_solver_free(RSWSolver* solver) {
    if (solver) {
        delete solver->solver;
        delete solver;
    }
}

// Solve a single puzzle
RSWResult rsw_solver_solve(RSWSolver* solver, 
                          const char* n_hex,
                          const char* a_hex,
                          const char* c_hex,
                          uint32_t t) {
    RSWResult result = {};
    
    if (!solver || !solver->solver) {
        result.success = false;
        result.error_msg = strdup("Invalid solver instance");
        return result;
    }
    
    try {
        rsw::PuzzleParams params {
            .n = n_hex,
            .a = a_hex,
            .C = c_hex,
            .T = t
        };
        
        rsw::SolveResult solve_result = solver->solver->solve(params);
        
        result.success = solve_result.success;
        memcpy(result.key, solve_result.key, 32);
        
        if (!solve_result.success) {
            result.error_msg = strdup(solve_result.error_msg.c_str());
        } else {
            result.error_msg = nullptr;
        }
        
    } catch (const std::exception& e) {
        result.success = false;
        result.error_msg = strdup(e.what());
    }
    
    return result;
}

// Free error message string
void rsw_result_free_error(char* error_msg) {
    free(error_msg);
}

// Get device name
const char* rsw_solver_get_device_name(RSWSolver* solver) {
    static thread_local std::string device_name;
    if (solver && solver->solver) {
        device_name = solver->solver->get_device_name();
        return device_name.c_str();
    }
    return "Unknown";
}

// Get optimal batch size
size_t rsw_solver_get_optimal_batch_size(RSWSolver* solver) {
    if (solver && solver->solver) {
        return solver->solver->get_optimal_batch_size();
    }
    return 0;
}

} // extern "C"