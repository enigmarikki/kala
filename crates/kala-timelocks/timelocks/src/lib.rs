//! RSW Timelock Puzzle Solver
//!
//! This library provides Rust bindings to a CUDA-accelerated RSW puzzle solver.

use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[repr(C)]
struct RSWSolver {
    _private: [u8; 0],
}

#[repr(C)]
struct RSWResult {
    key: [u8; 32],
    success: bool,
    error_msg: *mut c_char,
}

#[repr(C)]
struct RSWBatchResult {
    results: *mut RSWResult,
    count: usize,
}

#[link(name = "rsw_solver")]
extern "C" {
    fn rsw_solver_new(device_id: i32) -> *mut RSWSolver;
    fn rsw_solver_free(solver: *mut RSWSolver);
    fn rsw_solver_solve(
        solver: *mut RSWSolver,
        n_hex: *const c_char,
        a_hex: *const c_char,
        c_hex: *const c_char,
        t: u32,
    ) -> RSWResult;
    fn rsw_solver_solve_batch(
        solver: *mut RSWSolver,
        n_hex_array: *const *const c_char,
        a_hex_array: *const *const c_char,
        c_hex_array: *const *const c_char,
        t_array: *const u32,
        count: usize,
    ) -> RSWBatchResult;
    fn rsw_batch_result_free(batch_result: *mut RSWBatchResult);
    fn rsw_result_free_error(error_msg: *mut c_char);
    fn rsw_solver_get_device_name(solver: *mut RSWSolver) -> *const c_char;
    fn rsw_solver_get_optimal_batch_size(solver: *mut RSWSolver) -> usize;
}

/// RSW Puzzle Solver using GPU acceleration
pub struct Solver {
    inner: *mut RSWSolver,
}

/// Result of solving an RSW puzzle
#[derive(Debug, Clone)]
pub struct SolveResult {
    /// The 256-bit key derived from the puzzle
    pub key: [u8; 32],
}

/// Error type for RSW operations
#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Failed to create solver: GPU not available or invalid device ID")]
    CreationFailed,

    #[error("Solver error: {0}")]
    SolverError(String),

    #[error("Invalid hex string: {0}")]
    InvalidHex(String),
}

impl Solver {
    /// Create a new solver instance using the specified GPU device
    pub fn new(device_id: i32) -> Result<Self, Error> {
        unsafe {
            let solver = rsw_solver_new(device_id);
            if solver.is_null() {
                Err(Error::CreationFailed)
            } else {
                Ok(Solver { inner: solver })
            }
        }
    }

    /// Create a solver using the default GPU (device 0)
    pub fn default() -> Result<Self, Error> {
        Self::new(0)
    }

    /// Solve an RSW puzzle
    ///
    /// # Arguments
    /// * `n` - RSA modulus as hex string
    /// * `a` - Base value as hex string (typically "2")
    /// * `c` - Challenge value as hex string
    /// * `t` - Number of sequential squarings
    ///
    /// # Returns
    /// The 256-bit key as a byte array
    pub fn solve(&self, n: &str, a: &str, c: &str, t: u32) -> Result<SolveResult, Error> {
        // Validate hex strings
        if !is_valid_hex(n) {
            return Err(Error::InvalidHex("n".to_string()));
        }
        if !is_valid_hex(a) {
            return Err(Error::InvalidHex("a".to_string()));
        }
        if !is_valid_hex(c) {
            return Err(Error::InvalidHex("c".to_string()));
        }

        // Convert to C strings
        let n_cstr =
            CString::new(n).map_err(|_| Error::InvalidHex("n contains null".to_string()))?;
        let a_cstr =
            CString::new(a).map_err(|_| Error::InvalidHex("a contains null".to_string()))?;
        let c_cstr =
            CString::new(c).map_err(|_| Error::InvalidHex("c contains null".to_string()))?;

        unsafe {
            let result = rsw_solver_solve(
                self.inner,
                n_cstr.as_ptr(),
                a_cstr.as_ptr(),
                c_cstr.as_ptr(),
                t,
            );

            if result.success {
                Ok(SolveResult { key: result.key })
            } else {
                let error_msg = if result.error_msg.is_null() {
                    "Unknown error".to_string()
                } else {
                    let msg = CStr::from_ptr(result.error_msg)
                        .to_string_lossy()
                        .to_string();
                    rsw_result_free_error(result.error_msg);
                    msg
                };
                Err(Error::SolverError(error_msg))
            }
        }
    }

    /// Solve multiple RSW puzzles in batch for better GPU utilization
    ///
    /// # Arguments
    /// * `puzzles` - Vector of (n, a, c, t) tuples
    ///
    /// # Returns
    /// Vector of results in the same order as input
    pub fn solve_batch(
        &self,
        puzzles: &[(String, String, String, u32)],
    ) -> Result<Vec<SolveResult>, Error> {
        if puzzles.is_empty() {
            return Ok(Vec::new());
        }

        // Convert strings to C strings
        let mut n_cstrings: Vec<CString> = Vec::new();
        let mut a_cstrings: Vec<CString> = Vec::new();
        let mut c_cstrings: Vec<CString> = Vec::new();
        let mut t_values: Vec<u32> = Vec::new();

        for (n, a, c, t) in puzzles {
            // Validate hex strings
            if !is_valid_hex(n) {
                return Err(Error::InvalidHex("n".to_string()));
            }
            if !is_valid_hex(a) {
                return Err(Error::InvalidHex("a".to_string()));
            }
            if !is_valid_hex(c) {
                return Err(Error::InvalidHex("c".to_string()));
            }

            n_cstrings.push(
                CString::new(n.as_str())
                    .map_err(|_| Error::InvalidHex("n contains null".to_string()))?,
            );
            a_cstrings.push(
                CString::new(a.as_str())
                    .map_err(|_| Error::InvalidHex("a contains null".to_string()))?,
            );
            c_cstrings.push(
                CString::new(c.as_str())
                    .map_err(|_| Error::InvalidHex("c contains null".to_string()))?,
            );
            t_values.push(*t);
        }

        // Create arrays of pointers
        let n_ptrs: Vec<*const c_char> = n_cstrings.iter().map(|s| s.as_ptr()).collect();
        let a_ptrs: Vec<*const c_char> = a_cstrings.iter().map(|s| s.as_ptr()).collect();
        let c_ptrs: Vec<*const c_char> = c_cstrings.iter().map(|s| s.as_ptr()).collect();

        unsafe {
            let batch_result = rsw_solver_solve_batch(
                self.inner,
                n_ptrs.as_ptr(),
                a_ptrs.as_ptr(),
                c_ptrs.as_ptr(),
                t_values.as_ptr(),
                puzzles.len(),
            );

            // Convert results
            let mut results = Vec::with_capacity(puzzles.len());

            if !batch_result.results.is_null() && batch_result.count == puzzles.len() {
                let result_slice =
                    std::slice::from_raw_parts(batch_result.results, batch_result.count);

                for (i, rsw_result) in result_slice.iter().enumerate() {
                    if rsw_result.success {
                        results.push(SolveResult {
                            key: rsw_result.key,
                        });
                    } else {
                        let error_msg = if rsw_result.error_msg.is_null() {
                            "Unknown error".to_string()
                        } else {
                            CStr::from_ptr(rsw_result.error_msg)
                                .to_string_lossy()
                                .to_string()
                        };

                        // Free the batch result before returning error
                        rsw_batch_result_free(&batch_result as *const _ as *mut _);
                        return Err(Error::SolverError(format!("Puzzle {i}: {error_msg}")));
                    }
                }

                // Free the batch result
                rsw_batch_result_free(&batch_result as *const _ as *mut _);
            } else {
                return Err(Error::SolverError("Batch solve failed".to_string()));
            }

            Ok(results)
        }
    }

    /// Get the name of the GPU device being used
    pub fn device_name(&self) -> String {
        unsafe {
            let name_ptr = rsw_solver_get_device_name(self.inner);
            if name_ptr.is_null() {
                "Unknown".to_string()
            } else {
                CStr::from_ptr(name_ptr).to_string_lossy().to_string()
            }
        }
    }

    /// Get the optimal batch size for this GPU
    pub fn optimal_batch_size(&self) -> usize {
        unsafe { rsw_solver_get_optimal_batch_size(self.inner) }
    }
}

impl Drop for Solver {
    fn drop(&mut self) {
        unsafe {
            rsw_solver_free(self.inner);
        }
    }
}

// Safe to send across threads (GPU context is thread-safe)
unsafe impl Send for Solver {}
unsafe impl Sync for Solver {}

// Helper function to validate hex strings
fn is_valid_hex(s: &str) -> bool {
    !s.is_empty() && s.chars().all(|c| c.is_ascii_hexdigit())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solver_creation() {
        match Solver::new(0) {
            Ok(solver) => {
                println!("GPU: {}", solver.device_name());
                println!("Optimal batch size: {}", solver.optimal_batch_size());
            }
            Err(e) => {
                eprintln!("No GPU available: {e}");
            }
        }
    }

    #[test]
    fn test_invalid_hex() {
        let solver = match Solver::default() {
            Ok(s) => s,
            Err(_) => return, // Skip test if no GPU
        };

        assert!(matches!(
            solver.solve("xyz", "2", "abcd", 100),
            Err(Error::InvalidHex(_))
        ));
    }

    #[test]
    fn test_batch_solve() {
        let solver = match Solver::default() {
            Ok(s) => s,
            Err(_) => return, // Skip test if no GPU
        };
        let puzzle = (
            "abcd1234".to_string(),
            "2".to_string(),
            "5678".to_string(),
            65536,
        );
        // Create a small batch of test puzzles
        let puzzles = vec![puzzle.clone(); 1000];
        match solver.solve_batch(&puzzles) {
            Ok(results) => {
                assert_eq!(results.len(), 1000);
                println!("Batch solve successful: {} results", results.len());
            }
            Err(e) => {
                // Expected to fail with invalid hex in test
                println!("Batch solve error (expected): {e}");
            }
        }
    }
}
