//kala-common/src/error.rs
//! Standardized error types for all Kala components

use std::sync::PoisonError;
use std::sync::{RwLockReadGuard, RwLockWriteGuard};
use thiserror::Error;
/// Standard result type used throughout Kala
pub type KalaResult<T> = std::result::Result<T, KalaError>;

#[derive(Error, Debug)]
pub enum CVDFError {
    #[error("Invalid discriminant")]
    InvalidDiscriminant,

    #[error("Invalid class group element")]
    InvalidElement,

    #[error("Invalid proof at step {step}")]
    InvalidProof { step: usize },

    #[error("Computation error: {0}")]
    ComputationError(String),

    #[error("Serialization error : {0}")]
    SerializationError(String),

    #[error("Deserialization error : {0}")]
    DeserializationError(String),

    #[error("Invalid state transition")]
    InvalidStateTransition,

    #[error("Frontier verification failed")]
    FrontierVerificationFailed,

    #[error("Reduction failed")]
    ReductionFailed,

    #[error("Division error")]
    DivisionError,

    #[error("Invalid form")]
    InvalidForm,

    #[error("Lock poisoned: {0}")]
    LockPoisoned(String),
}
impl From<CVDFError> for KalaError {
    fn from(err: CVDFError) -> Self {
        KalaError::CVDFError(err)
    }
}
impl<T> From<PoisonError<RwLockReadGuard<'_, T>>> for CVDFError {
    fn from(err: PoisonError<RwLockReadGuard<'_, T>>) -> Self {
        CVDFError::LockPoisoned(err.to_string())
    }
}

impl<T> From<PoisonError<RwLockWriteGuard<'_, T>>> for CVDFError {
    fn from(err: PoisonError<RwLockWriteGuard<'_, T>>) -> Self {
        CVDFError::LockPoisoned(err.to_string())
    }
}
/// Comprehensive error type for all Kala operations
#[derive(Error, Debug)]
pub enum KalaError {
    // Serialization errors
    #[error("Serialization error: {0}")]
    Serialization(String),
    // Deserialization errors
    #[error("Serialization error: {0}")]
    Deserialization(String),

    // Network errors
    #[error("Network error: {0}")]
    Network(String),

    // Database errors
    #[error("Database error: {0}")]
    Database(#[from] rocksdb::Error),

    // Validation errors
    #[error("Validation error: {0}")]
    Validation(String),

    // Cryptographic errors
    #[error("Crypto error: {0}")]
    Crypto(String),

    // Transaction errors
    #[error("Transaction error: {0}")]
    Transaction(String),

    // VDF computation errors
    #[error("CVDF error: {0}")]
    CVDFError(CVDFError),

    // State management errors
    #[error("State error: {0}")]
    State(String),

    // Configuration errors
    #[error("Config error: {0}")]
    Config(String),

    // I/O errors
    #[error("I/O error: {0}")]
    IO(#[from] std::io::Error),

    // JSON errors
    #[error("JSON error: {0}")]
    Json(#[from] serde_json::Error),

    // Generic errors
    #[error("Internal error: {0}")]
    Internal(String),

    // External library errors
    #[error("External error: {0}")]
    External(#[from] anyhow::Error),
}

impl KalaError {
    /// Create a new network error
    pub fn network(msg: impl Into<String>) -> Self {
        Self::Network(msg.into())
    }

    /// Create a new validation error
    pub fn validation(msg: impl Into<String>) -> Self {
        Self::Validation(msg.into())
    }

    /// Create a new crypto error
    pub fn crypto(msg: impl Into<String>) -> Self {
        Self::Crypto(msg.into())
    }

    /// Create a new transaction error
    pub fn transaction(msg: impl Into<String>) -> Self {
        Self::Transaction(msg.into())
    }

    /// Create a new VDF error
    pub fn vdf(error: CVDFError) -> Self {
        Self::CVDFError(error)
    }

    /// Create a new state error
    pub fn state(msg: impl Into<String>) -> Self {
        Self::State(msg.into())
    }

    /// Create a new config error
    pub fn config(msg: impl Into<String>) -> Self {
        Self::Config(msg.into())
    }

    /// Create a new internal error
    pub fn internal(msg: impl Into<String>) -> Self {
        Self::Internal(msg.into())
    }

    /// Create a new serialization error (helper for backward compatibility)
    pub fn serialization(msg: impl Into<String>) -> Self {
        Self::Internal(format!("Serialization: {}", msg.into()))
    }

    /// Create a new database error (helper for backward compatibility)
    pub fn database(msg: impl Into<String>) -> Self {
        Self::Internal(format!("Database: {}", msg.into()))
    }
}

/// Convenience macro for creating KalaError instances
#[macro_export]
macro_rules! kala_error {
    ($variant:ident, $($arg:tt)*) => {
        $crate::error::KalaError::$variant(format!($($arg)*))
    };
}

/// Convenience macro for returning early with a KalaError
#[macro_export]
macro_rules! kala_bail {
    ($variant:ident, $($arg:tt)*) => {
        return Err($crate::kala_error!($variant, $($arg)*))
    };
}
