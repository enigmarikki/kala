//! CPU VDF Streamer - Rust bindings for high-performance VDF computation
//!
//! This crate provides safe Rust bindings to a CPU-optimized implementation
//! of Verifiable Delay Functions (VDFs) with support for streaming proofs.

#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(dead_code)]

use std::ffi::c_void;
use std::option::Option;
use std::ptr;
use std::slice;
use std::sync::Arc;
use thiserror::Error;
// Include the generated bindings
include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
use crate::root::*;
/// Errors that can occur during VDF operations
#[derive(Error, Debug)]
pub enum VdfError {
    #[error("Invalid configuration")]
    InvalidConfig,

    #[error("Invalid parameters")]
    InvalidParameters,

    #[error("Memory allocation failed")]
    MemoryAllocation,

    #[error("Computation failed")]
    ComputationFailed,

    #[error("Thread error")]
    ThreadError,

    #[error("Invalid discriminant")]
    InvalidDiscriminant,

    #[error("Invalid form")]
    InvalidForm,

    #[error("Proof generation failed")]
    ProofGenerationFailed,

    #[error("Verification failed")]
    VerificationFailed,

    #[error("Not initialized")]
    NotInitialized,

    #[error("Already running")]
    AlreadyRunning,

    #[error("Unknown error: {0}")]
    Unknown(i32),
}

impl From<cpu_vdf_error_t> for VdfError {
    fn from(err: cpu_vdf_error_t) -> Self {
        match err {
            CPU_VDF_ERROR_INVALID_CONFIG => VdfError::InvalidConfig,
            CPU_VDF_ERROR_INVALID_PARAMETERS => VdfError::InvalidParameters,
            CPU_VDF_ERROR_MEMORY_ALLOCATION => VdfError::MemoryAllocation,
            CPU_VDF_ERROR_COMPUTATION_FAILED => VdfError::ComputationFailed,
            CPU_VDF_ERROR_THREAD_ERROR => VdfError::ThreadError,
            CPU_VDF_ERROR_INVALID_DISCRIMINANT => VdfError::InvalidDiscriminant,
            CPU_VDF_ERROR_INVALID_FORM => VdfError::InvalidForm,
            CPU_VDF_ERROR_PROOF_GENERATION_FAILED => VdfError::ProofGenerationFailed,
            CPU_VDF_ERROR_VERIFICATION_FAILED => VdfError::VerificationFailed,
            CPU_VDF_ERROR_NOT_INITIALIZED => VdfError::NotInitialized,
            CPU_VDF_ERROR_ALREADY_RUNNING => VdfError::AlreadyRunning,
            _ => VdfError::Unknown(err),
        }
    }
}

/// VDF computation state
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VdfState {
    Idle,
    Computing,
    Completed,
    Error,
    Stopped,
}

impl From<cpu_vdf_state_t> for VdfState {
    fn from(state: cpu_vdf_state_t) -> Self {
        match state {
            CPU_VDF_STATE_IDLE => VdfState::Idle,
            CPU_VDF_STATE_COMPUTING => VdfState::Computing,
            CPU_VDF_STATE_COMPLETED => VdfState::Completed,
            CPU_VDF_STATE_ERROR => VdfState::Error,
            CPU_VDF_STATE_STOPPED => VdfState::Stopped,
            _ => VdfState::Error,
        }
    }
}

/// Configuration for VDF computation
#[derive(Debug, Clone)]
pub struct VdfConfig {
    inner: cpu_vdf_config_t,
}

impl Default for VdfConfig {
    fn default() -> Self {
        let mut config = cpu_vdf_config_t {
            num_threads: 0,
            proof_threads: 0,
            enable_fast_mode: false,
            enable_avx512: false,
            enable_logging: false,
            segment_size: 0,
        };

        unsafe {
            cpu_vdf_config_init(&mut config);
        }

        Self { inner: config }
    }
}

impl VdfConfig {
    /// Create a new configuration with default values
    pub fn new() -> Self {
        Self::default()
    }

    /// Set the number of computation threads
    pub fn with_threads(mut self, num_threads: u8) -> Self {
        self.inner.num_threads = num_threads;
        self
    }

    /// Set the number of proof generation threads
    pub fn with_proof_threads(mut self, proof_threads: u8) -> Self {
        self.inner.proof_threads = proof_threads;
        self
    }

    /// Enable fast computation mode
    pub fn with_fast_mode(mut self, enable: bool) -> Self {
        self.inner.enable_fast_mode = enable;
        self
    }

    /// Enable AVX-512 optimizations
    pub fn with_avx512(mut self, enable: bool) -> Self {
        self.inner.enable_avx512 = enable;
        self
    }

    /// Enable debug logging
    pub fn with_logging(mut self, enable: bool) -> Self {
        self.inner.enable_logging = enable;
        self
    }

    /// Set checkpoint interval for streaming proofs (0 = disabled)
    pub fn with_segment_size(mut self, size: u32) -> Self {
        self.inner.segment_size = size;
        self
    }
}

/// A quadratic form representing a VDF state
#[derive(Debug, Clone)]
pub struct VdfForm {
    pub a: Vec<u8>,
    pub b: Vec<u8>,
    pub c: Vec<u8>,
}

impl From<cpu_vdf_form_t> for VdfForm {
    fn from(form: cpu_vdf_form_t) -> Self {
        Self {
            a: form.a_data[..form.data_size as usize].to_vec(),
            b: form.b_data[..form.data_size as usize].to_vec(),
            c: form.c_data[..form.data_size as usize].to_vec(),
        }
    }
}

/// Status of VDF computation
#[derive(Debug, Clone)]
pub struct VdfStatus {
    pub current_iteration: u64,
    pub target_iterations: u64,
    pub state: VdfState,
    pub progress_percentage: f64,
    pub iterations_per_second: u64,
    pub elapsed_time_ms: u64,
    pub has_proof_ready: bool,
}

impl From<cpu_vdf_status_t> for VdfStatus {
    fn from(status: cpu_vdf_status_t) -> Self {
        Self {
            current_iteration: status.current_iteration,
            target_iterations: status.target_iterations,
            state: VdfState::from(status.state),
            progress_percentage: status.progress_percentage,
            iterations_per_second: status.iterations_per_second,
            elapsed_time_ms: status.elapsed_time_ms,
            has_proof_ready: status.has_proof_ready,
        }
    }
}

/// A VDF proof
pub struct VdfProof {
    data: Vec<u8>,
    iterations: u64,
    recursion_level: u8,
}

impl VdfProof {
    /// Get the proof data
    pub fn data(&self) -> &[u8] {
        &self.data
    }

    /// Get the number of iterations proven
    pub fn iterations(&self) -> u64 {
        self.iterations
    }

    /// Get the recursion level
    pub fn recursion_level(&self) -> u8 {
        self.recursion_level
    }
}

/// A checkpoint proof for streaming verification
pub struct CheckpointProof {
    pub iteration: u64,
    pub checkpoint_form: VdfForm,
    pub proof_data: Option<Vec<u8>>,
}

/// Progress callback type
pub type ProgressCallback = Box<dyn Fn(u64, u64) + Send + Sync>;

/// Completion callback type  
pub type CompletionCallback = Box<dyn Fn(bool, u64) + Send + Sync>;

/// VDF computation context
pub struct VdfContext {
    ptr: *mut cpu_vdf_context_t,
    // Keep callbacks alive for the lifetime of the context
    _progress_cb: Option<Arc<ProgressCallback>>,
    _completion_cb: Option<Arc<CompletionCallback>>,
}

// Safety: The C++ implementation uses mutexes for thread safety
unsafe impl Send for VdfContext {}
unsafe impl Sync for VdfContext {}

impl VdfContext {
    /// Create a new VDF context with the given configuration
    pub fn new(config: &VdfConfig) -> Result<Self, VdfError> {
        let ptr = unsafe { cpu_vdf_create(&config.inner) };

        if ptr.is_null() {
            return Err(VdfError::MemoryAllocation);
        }

        Ok(Self {
            ptr,
            _progress_cb: None,
            _completion_cb: None,
        })
    }

    /// Start VDF computation with a challenge hash
    pub fn start_computation(
        &mut self,
        challenge_hash: &[u8; 32],
        iterations: u64,
        discriminant_bits: usize,
    ) -> Result<(), VdfError> {
        let result = unsafe {
            cpu_vdf_start_computation(
                self.ptr,
                challenge_hash.as_ptr(),
                ptr::null(),
                iterations,
                discriminant_bits,
            )
        };

        if result == CPU_VDF_SUCCESS {
            Ok(())
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Start VDF computation with a custom discriminant
    pub fn start_computation_with_discriminant(
        &mut self,
        discriminant: &[u8],
        iterations: u64,
    ) -> Result<(), VdfError> {
        let result = unsafe {
            cpu_vdf_start_computation_with_discriminant(
                self.ptr,
                discriminant.as_ptr(),
                discriminant.len(),
                ptr::null(),
                iterations,
            )
        };

        if result == CPU_VDF_SUCCESS {
            Ok(())
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Stop the current computation
    pub fn stop_computation(&mut self) -> Result<(), VdfError> {
        let result = unsafe { cpu_vdf_stop_computation(self.ptr) };

        if result == CPU_VDF_SUCCESS {
            Ok(())
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Get the current status of the computation
    pub fn get_status(&self) -> Result<VdfStatus, VdfError> {
        let mut status = cpu_vdf_status_t {
            current_iteration: 0,
            target_iterations: 0,
            state: CPU_VDF_STATE_IDLE,
            progress_percentage: 0.0,
            iterations_per_second: 0,
            elapsed_time_ms: 0,
            has_proof_ready: false,
        };

        let result = unsafe { cpu_vdf_get_status(self.ptr, &mut status) };

        if result == CPU_VDF_SUCCESS {
            Ok(VdfStatus::from(status))
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Wait for computation to complete
    pub fn wait_completion(&self, timeout_ms: Option<u32>) -> Result<(), VdfError> {
        let timeout = timeout_ms.unwrap_or(0);
        let result = unsafe { cpu_vdf_wait_completion(self.ptr, timeout) };

        if result == CPU_VDF_SUCCESS {
            Ok(())
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Check if computation is complete
    pub fn is_complete(&self) -> bool {
        unsafe { cpu_vdf_is_complete(self.ptr) }
    }

    /// Get the result form after computation
    pub fn get_result_form(&self) -> Result<VdfForm, VdfError> {
        let mut form = cpu_vdf_form_t {
            a_data: [0; 256],
            b_data: [0; 256],
            c_data: [0; 256],
            data_size: 0,
        };

        let result = unsafe { cpu_vdf_get_result_form(self.ptr, &mut form) };

        if result == CPU_VDF_SUCCESS {
            Ok(VdfForm::from(form))
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Generate a proof for the computation
    pub fn generate_proof(&self, recursion_level: u8) -> Result<VdfProof, VdfError> {
        let mut proof = cpu_vdf_proof_t {
            data: ptr::null_mut(),
            length: 0,
            iterations: 0,
            is_valid: false,
            recursion_level: 0,
        };

        let result = unsafe { cpu_vdf_generate_proof(self.ptr, recursion_level, &mut proof) };

        if result == CPU_VDF_SUCCESS && !proof.data.is_null() {
            let data = unsafe { slice::from_raw_parts(proof.data, proof.length) }.to_vec();

            let vdf_proof = VdfProof {
                data,
                iterations: proof.iterations,
                recursion_level: proof.recursion_level,
            };

            // Free the C++ allocated memory
            unsafe { cpu_vdf_free_proof(&mut proof) };

            Ok(vdf_proof)
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Get checkpoint proofs for streaming verification
    pub fn get_checkpoint_proofs(
        &self,
        start_iteration: u64,
        end_iteration: u64,
        max_proofs: usize,
    ) -> Result<Vec<CheckpointProof>, VdfError> {
        let mut proofs = vec![
            cpu_vdf_checkpoint_proof_t {
                iteration: 0,
                checkpoint_form: cpu_vdf_form_t {
                    a_data: [0; 256],
                    b_data: [0; 256],
                    c_data: [0; 256],
                    data_size: 0,
                },
                proof_data: ptr::null_mut(),
                proof_length: 0,
                has_proof: false,
            };
            max_proofs
        ];

        let mut num_proofs = max_proofs;

        let result = unsafe {
            cpu_vdf_get_checkpoint_proofs(
                self.ptr,
                start_iteration,
                end_iteration,
                proofs.as_mut_ptr(),
                &mut num_proofs,
            )
        };

        if result == CPU_VDF_SUCCESS {
            let mut checkpoint_proofs = Vec::with_capacity(num_proofs);

            for i in 0..num_proofs {
                let proof = &proofs[i];

                let proof_data = if proof.has_proof && !proof.proof_data.is_null() {
                    Some(
                        unsafe { slice::from_raw_parts(proof.proof_data, proof.proof_length) }
                            .to_vec(),
                    )
                } else {
                    None
                };

                checkpoint_proofs.push(CheckpointProof {
                    iteration: proof.iteration,
                    checkpoint_form: VdfForm::from(proof.checkpoint_form),
                    proof_data,
                });

                // Free the C++ allocated memory
                unsafe { cpu_vdf_free_checkpoint_proof(&mut proofs[i]) };
            }

            Ok(checkpoint_proofs)
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Get the number of available checkpoints
    pub fn get_checkpoint_count(&self) -> Result<usize, VdfError> {
        let mut count = 0;
        let result = unsafe { cpu_vdf_get_checkpoint_count(self.ptr, &mut count) };

        if result == CPU_VDF_SUCCESS {
            Ok(count)
        } else {
            Err(VdfError::from(result))
        }
    }

    /// Set callbacks for progress and completion notifications
    pub fn set_callbacks<P, C>(
        &mut self,
        progress: Option<P>,
        completion: Option<C>,
        update_interval_ms: u32,
    ) -> Result<(), VdfError>
    where
        P: Fn(u64, u64) + Send + Sync + 'static,
        C: Fn(bool, u64) + Send + Sync + 'static,
    {
        // Wrap callbacks in Arc to share ownership
        self._progress_cb = progress.map(|cb| Arc::new(Box::new(cb) as ProgressCallback));
        self._completion_cb = completion.map(|cb| Arc::new(Box::new(cb) as CompletionCallback));

        // Create C function pointers
        let progress_ptr = if self._progress_cb.is_some() {
            Some(progress_callback_wrapper as unsafe extern "C" fn(u64, u64, *mut c_void))
        //as Some(cpu_vdf_progress_callback_t)
        } else {
            None
        };

        let completion_ptr = if self._completion_cb.is_some() {
            Some(completion_callback_wrapper as unsafe extern "C" fn(bool, u64, *mut c_void))
        } else {
            None
        };

        // Pass the Arc pointers as user data
        let user_data = Box::into_raw(Box::new((
            self._progress_cb.clone(),
            self._completion_cb.clone(),
        ))) as *mut c_void;

        let result = unsafe {
            cpu_vdf_set_callbacks(
                self.ptr,
                progress_ptr,
                completion_ptr,
                update_interval_ms,
                user_data,
            )
        };

        if result == CPU_VDF_SUCCESS {
            Ok(())
        } else {
            // Clean up the user data on error
            unsafe {
                let _ = Box::from_raw(
                    user_data
                        as *mut (
                            Option<Arc<ProgressCallback>>,
                            Option<Arc<CompletionCallback>>,
                        ),
                );
            }
            Err(VdfError::from(result))
        }
    }
}

impl Drop for VdfContext {
    fn drop(&mut self) {
        if !self.ptr.is_null() {
            unsafe {
                cpu_vdf_destroy(self.ptr);
            }
        }
    }
}

// Callback wrappers
unsafe extern "C" fn progress_callback_wrapper(
    current_iteration: u64,
    total_iterations: u64,
    user_data: *mut c_void,
) {
    if !user_data.is_null() {
        let callbacks = &*(user_data
            as *const (
                Option<Arc<ProgressCallback>>,
                Option<Arc<CompletionCallback>>,
            ));
        if let Some(ref cb) = callbacks.0 {
            cb(current_iteration, total_iterations);
        }
    }
}

unsafe extern "C" fn completion_callback_wrapper(
    success: bool,
    iterations_completed: u64,
    user_data: *mut c_void,
) {
    if !user_data.is_null() {
        let callbacks = &*(user_data
            as *const (
                Option<Arc<ProgressCallback>>,
                Option<Arc<CompletionCallback>>,
            ));
        if let Some(ref cb) = callbacks.1 {
            cb(success, iterations_completed);
        }
    }
}

/// Create a discriminant from a challenge hash
pub fn create_discriminant(
    challenge_hash: &[u8; 32],
    size_bits: usize,
) -> Result<Vec<u8>, VdfError> {
    let out_size = (size_bits + 7) / 8;
    let mut discriminant = vec![0u8; out_size];

    let result = unsafe {
        cpu_vdf_create_discriminant(
            challenge_hash.as_ptr(),
            size_bits,
            discriminant.as_mut_ptr(),
            discriminant.len(),
        )
    };

    if result > 0 {
        discriminant.truncate(result as usize);
        Ok(discriminant)
    } else {
        Err(VdfError::InvalidParameters)
    }
}

/// Verify a proof with a challenge hash
pub fn verify_proof_with_challenge(
    challenge_hash: &[u8; 32],
    discriminant_size_bits: usize,
    proof: &VdfProof,
    iterations: u64,
    recursion_level: u8,
) -> bool {
    let c_proof = cpu_vdf_proof_t {
        data: proof.data.as_ptr() as *mut u8,
        length: proof.data.len(),
        iterations: proof.iterations,
        is_valid: true,
        recursion_level: proof.recursion_level,
    };

    unsafe {
        cpu_vdf_verify_proof_with_challenge(
            challenge_hash.as_ptr(),
            discriminant_size_bits,
            ptr::null(),
            &c_proof,
            iterations,
            recursion_level,
        )
    }
}

/// Verify a proof with a discriminant
pub fn verify_proof(
    discriminant: &[u8],
    proof: &VdfProof,
    iterations: u64,
    recursion_level: u8,
) -> bool {
    let c_proof = cpu_vdf_proof_t {
        data: proof.data.as_ptr() as *mut u8,
        length: proof.data.len(),
        iterations: proof.iterations,
        is_valid: true,
        recursion_level: proof.recursion_level,
    };

    unsafe {
        cpu_vdf_verify_proof(
            discriminant.as_ptr(),
            discriminant.len(),
            ptr::null(),
            &c_proof,
            iterations,
            recursion_level,
        )
    }
}

/// Benchmark VDF performance
pub fn benchmark(config: &VdfConfig, test_iterations: u64) -> Result<f64, VdfError> {
    let result = unsafe { cpu_vdf_benchmark(&config.inner, test_iterations) };

    if result > 0.0 {
        Ok(result)
    } else {
        Err(VdfError::ComputationFailed)
    }
}

/// Get CPU capabilities
pub fn get_capabilities() -> cpu_vdf_capabilities_t {
    let mut caps = cpu_vdf_capabilities_t {
        has_avx2: false,
        has_avx512: false,
        has_bmi2: false,
        has_adx: false,
        cpu_cores: 0,
        cpu_threads: 0,
    };

    unsafe {
        cpu_vdf_get_capabilities(&mut caps);
    }

    caps
}

/// Get library version
pub fn get_version() -> &'static str {
    unsafe {
        let ptr = cpu_vdf_get_version();
        if ptr.is_null() {
            "Unknown"
        } else {
            std::ffi::CStr::from_ptr(ptr).to_str().unwrap_or("Unknown")
        }
    }
}

/// Run self-test
pub fn self_test() -> Result<(), VdfError> {
    let result = unsafe { cpu_vdf_self_test() };

    if result == CPU_VDF_SUCCESS {
        Ok(())
    } else {
        Err(VdfError::from(result))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_context() {
        let config = VdfConfig::new();
        let context = VdfContext::new(&config);
        assert!(context.is_ok());
    }

    #[test]
    fn test_create_discriminant() {
        let challenge = [0u8; 32];
        let discriminant = create_discriminant(&challenge, 512);
        assert!(discriminant.is_ok());
        assert!(!discriminant.unwrap().is_empty());
    }

    #[test]
    fn test_get_version() {
        let version = get_version();
        assert!(!version.is_empty());
        println!("VDF Library version: {}", version);
    }

    #[test]
    fn test_capabilities() {
        let caps = get_capabilities();
        println!("CPU capabilities: {:?}", caps);
        assert!(caps.cpu_cores > 0);
    }
}
