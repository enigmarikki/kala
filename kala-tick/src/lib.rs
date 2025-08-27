pub mod classgroup;
pub mod discriminant;
pub mod form;
pub mod streamer;
pub mod types;
pub mod verifier;

// Re-export main types for easy access
pub use classgroup::ClassGroup;
pub use discriminant::Discriminant;
pub use form::QuadraticForm;
pub use streamer::{CVDFConfig, CVDFStreamer, CVDFProof, ProofNode, CVDFFrontier};
pub use types::{CVDFError, Result};