use std::sync::PoisonError;
use std::sync::{RwLockReadGuard, RwLockWriteGuard};
use thiserror::Error;

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

pub type Result<T> = std::result::Result<T, CVDFError>;
