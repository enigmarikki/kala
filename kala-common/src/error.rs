//kala-common/src/error.rs
//! Standardized error types for all Kala components

use thiserror::Error;

/// Standard result type used throughout Kala
pub type KalaResult<T> = std::result::Result<T, KalaError>;

/// Comprehensive error type for all Kala operations
#[derive(Error, Debug)]
pub enum KalaError {
    // Serialization errors
    #[error("Serialization error: {0}")]
    Serialization(String),

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
    #[error("VDF error: {0}")]
    VDF(String),

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
    pub fn vdf(msg: impl Into<String>) -> Self {
        Self::VDF(msg.into())
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
