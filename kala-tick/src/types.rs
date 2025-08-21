use bincode::error::EncodeError;
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

    #[error("Serialization error: {0}")]
    SerializationError(#[from] EncodeError),

    #[error("Invalid state transition")]
    InvalidStateTransition,

    #[error("Frontier verification failed")]
    FrontierVerificationFailed,

    #[error("Reduction failed")]
    ReductionFailed,

    #[error("Division error")]
    DivisionError,

    #[error("Invalid form")]
    InvalidForm
}

pub type Result<T> = std::result::Result<T, CVDFError>;
