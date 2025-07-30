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
    fn rsw_result_free_error(error_msg: *mut c_char);
    fn rsw_solver_get_device_name(solver: *mut RSWSolver) -> *const c_char;
    fn rsw_solver_get_optimal_batch_size(solver: *mut RSWSolver) -> usize;
}

/// RSW Puzzle Solver using GPU acceleration
pub struct Solver {
    inner: *mut RSWSolver,
}

/// Result of solving an RSW puzzle
#[derive(Debug)]
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
        let n_cstr = CString::new(n).map_err(|_| Error::InvalidHex("n contains null".to_string()))?;
        let a_cstr = CString::new(a).map_err(|_| Error::InvalidHex("a contains null".to_string()))?;
        let c_cstr = CString::new(c).map_err(|_| Error::InvalidHex("c contains null".to_string()))?;
        
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
    
    /// Get the name of the GPU device being used
    pub fn device_name(&self) -> String {
        unsafe {
            let name_ptr = rsw_solver_get_device_name(self.inner);
            if name_ptr.is_null() {
                "Unknown".to_string()
            } else {
                CStr::from_ptr(name_ptr)
                    .to_string_lossy()
                    .to_string()
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

/// Solve an RSW puzzle and decrypt a message using AES-GCM
/// 
/// This is a convenience function that combines RSW solving with AES-GCM decryption.
#[cfg(feature = "aes")]
pub fn solve_and_decrypt(
    n: &str,
    a: &str,
    c: &str,
    t: u32,
    iv: &[u8],
    tag: &[u8],
    ciphertext: &[u8],
) -> Result<Vec<u8>, Box<dyn std::error::Error>> {
    use aes_gcm::{
        aead::{Aead, KeyInit},
        Aes256Gcm, Nonce,
    };
    
    // Solve the puzzle
    let solver = Solver::default()?;
    let result = solver.solve(n, a, c, t)?;
    
    // Decrypt with AES-GCM
    let cipher = Aes256Gcm::new_from_slice(&result.key)
        .map_err(|e| format!("Invalid key length: {}", e))?;
    let nonce = Nonce::from_slice(iv);
    
    // Combine ciphertext and tag
    let mut combined = ciphertext.to_vec();
    combined.extend_from_slice(tag);
    
    cipher
        .decrypt(nonce, combined.as_ref())
        .map_err(|_| "Decryption failed".into())
}

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
                eprintln!("No GPU available: {}", e);
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
}