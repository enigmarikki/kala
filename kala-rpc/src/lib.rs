//! # Kala RPC - JSON-RPC API Server
//!
//! This crate provides a comprehensive JSON-RPC 2.0 API for Kala blockchain nodes.
//! It enables external clients to interact with the blockchain through standard
//! HTTP requests, supporting both synchronous queries and asynchronous operations.
//!
//! ## API Overview
//!
//! The Kala RPC API provides the following functionality:
//!
//! ### Chain Information
//! - **`kala_chainInfo`**: Get current blockchain state and VDF progress
//! - **`kala_getTick`**: Retrieve specific tick certificates
//! - **`kala_getRecentTicks`**: Get recent tick history
//!
//! ### Transaction Operations  
//! - **`kala_submitTransaction`**: Submit timelock-encrypted transactions
//!
//! ### Account Queries
//! - **`kala_getAccount`**: Query account balances and state
//!
//! ## Timelock Transaction Flow
//!
//! 1. **Client creates transaction**: Standard blockchain transaction
//! 2. **Client encrypts with timelock**: Uses RSW puzzle for MEV protection
//! 3. **Client submits via RPC**: Transaction enters the mempool
//! 4. **Node timestamps arrival**: VDF timestamps transaction submission
//! 5. **Node orders pre-decryption**: Canonical ordering prevents MEV
//! 6. **Node decrypts in parallel**: GPU acceleration for puzzle solving
//! 7. **Node validates and applies**: Standard blockchain state transition
//!
//! ## Example Usage
//!
//! ```json
//! // Get chain information
//! {
//!   \"jsonrpc\": \"2.0\",
//!   \"method\": \"kala_chainInfo\",
//!   \"id\": 1
//! }
//!
//! // Submit encrypted transaction
//! {
//!   \"jsonrpc\": \"2.0\",
//!   \"method\": \"kala_submitTransaction\",
//!   \"params\": {
//!     \"encrypted_tx\": \"0x1234...abcd\"
//!   },
//!   \"id\": 2
//! }
//! ```
//!
//! ## Security Considerations
//!
//! - All transaction data is hex-encoded for safety
//! - Address validation prevents malformed requests  
//! - Rate limiting should be implemented at the HTTP layer
//! - HTTPS is recommended for production deployments

use jsonrpsee::{core::RpcResult, proc_macros::rpc, server::ServerBuilder};
use kala_common::prelude::*;
use kala_common::types::PublicKey;
use kala_state::TickCertificate;
use std::net::SocketAddr;

/// Current blockchain and VDF state information
///
/// This structure contains a comprehensive snapshot of the current
/// blockchain state, including VDF progress, transaction statistics,
/// and network health indicators.
#[derive(Serialize, Deserialize, Clone)]
pub struct ChainInfo {
    /// Current tick number (block height equivalent)
    pub current_tick: BlockHeight,
    /// Current VDF iteration number within the eternal computation
    pub current_iteration: IterationNumber,
    /// Current VDF output as a formatted string (a, b, c form values)
    pub vdf_output: String,
    /// Current VDF hash chain value (hex-encoded)
    pub hash_chain: String,
    /// Total number of transactions processed across all ticks
    pub total_transactions: u64,
    /// Number of accounts with non-zero state
    pub accounts: usize,
}

/// Request to submit a timelock-encrypted transaction
///
/// Contains the complete timelock transaction data in hex-encoded format.
/// The transaction must be properly encrypted with an RSW timelock puzzle
/// and targeted for a future tick.
#[derive(Serialize, Deserialize, Clone)]
pub struct SubmitTransactionRequest {
    /// Hex-encoded timelock-encrypted transaction data
    ///
    /// This contains the complete [`TimelockTransaction`] structure
    /// serialized and encoded as a hex string for safe transport.
    pub encrypted_tx: String,
}

/// Response from submitting a timelock transaction
///
/// Contains confirmation details and timing information for the
/// submitted transaction, allowing clients to track its progress
/// through the MEV-resistant processing pipeline.
#[derive(Serialize, Deserialize, Clone)]
pub struct SubmitTransactionResponse {
    /// Unique transaction hash for tracking and identification
    pub tx_hash: String,
    /// VDF iteration number when the transaction was timestamped
    pub submission_iteration: IterationNumber,
    /// Target tick number when the transaction will be processed
    pub target_tick: BlockHeight,
}

/// Request to retrieve a specific tick certificate
///
/// Used to query historical tick information including transaction
/// processing results and VDF state at tick completion.
#[derive(Serialize, Deserialize, Clone)]
pub struct GetTickRequest {
    /// The tick number to retrieve
    pub tick_number: BlockHeight,
}

/// Request to retrieve account information
///
/// Queries the current state of a specific account, including
/// balance, nonce, and staking information.
#[derive(Serialize, Deserialize, Clone)]
pub struct GetAccountRequest {
    /// Account address as a hex-encoded public key (64 characters)
    pub address: String,
}

/// Account state information
///
/// Contains the complete state of an account including balances,
/// transaction history, and staking status.
#[derive(Serialize, Deserialize, Clone)]
pub struct AccountInfo {
    /// Account balance in base units
    pub balance: u64,
    /// Transaction nonce (prevents replay attacks)
    pub nonce: u64,
    /// Amount currently staked by this account
    pub staked_amount: u64,
    /// Optional delegation target (hex-encoded address)
    pub delegation: Option<String>,
}

/// Main Kala blockchain JSON-RPC API trait
///
/// This trait defines the complete public API for Kala blockchain nodes.
/// It follows JSON-RPC 2.0 conventions and provides both real-time queries
/// and historical data access.
///
/// All methods are async and return [`RpcResult`] which automatically
/// handles JSON-RPC error responses and serialization.
#[rpc(server)]
pub trait KalaApi {
    /// Get current blockchain and VDF state information
    ///
    /// Returns comprehensive information about the current state of the
    /// blockchain including tick progress, VDF computation state, and
    /// network statistics.
    ///
    /// # Returns
    ///
    /// [`ChainInfo`] containing:
    /// - Current tick number and VDF iteration
    /// - VDF output values and hash chain state  
    /// - Transaction and account statistics
    ///
    /// # Example
    ///
    /// ```json
    /// {
    ///   "jsonrpc": "2.0",
    ///   "method": "kala_chainInfo",
    ///   "id": 1
    /// }
    /// ```
    #[method(name = "kala_chainInfo")]
    async fn chain_info(&self) -> RpcResult<ChainInfo>;

    /// Submit a timelock-encrypted transaction for processing
    ///
    /// Accepts a timelock-encrypted transaction and adds it to the mempool
    /// for processing in a future tick. The transaction must be properly
    /// encrypted with an RSW timelock puzzle and targeted appropriately.
    ///
    /// # Parameters
    ///
    /// - `req`: [`SubmitTransactionRequest`] containing hex-encoded transaction data
    ///
    /// # Returns
    ///
    /// [`SubmitTransactionResponse`] with transaction hash and timing information
    ///
    /// # Errors
    ///
    /// Returns error if:
    /// - Transaction is malformed or invalid
    /// - Target tick is in the past or too far in the future
    /// - Transaction would not decrypt in time for processing
    /// - Node is not accepting transactions for the target tick
    ///
    /// # Example
    ///
    /// ```json
    /// {
    ///   "jsonrpc": "2.0",
    ///   "method": "kala_submitTransaction",
    ///   "params": {
    ///     "encrypted_tx": "0x1234567890abcdef..."
    ///   },
    ///   "id": 2
    /// }
    /// ```
    #[method(name = "kala_submitTransaction")]
    async fn submit_transaction(
        &self,
        req: SubmitTransactionRequest,
    ) -> RpcResult<SubmitTransactionResponse>;

    /// Retrieve a specific tick certificate by tick number
    ///
    /// Returns the complete tick certificate for the specified tick,
    /// including VDF proofs, transaction processing results, and
    /// cryptographic commitments.
    ///
    /// # Parameters
    ///
    /// - `req`: [`GetTickRequest`] specifying the tick number
    ///
    /// # Returns
    ///
    /// `Option<TickCertificate>` - `None` if tick doesn't exist or hasn't
    /// been processed yet, otherwise the complete tick certificate.
    ///
    /// # Example
    ///
    /// ```json
    /// {
    ///   "jsonrpc": "2.0",
    ///   "method": "kala_getTick",
    ///   "params": {
    ///     "tick_number": 12345
    ///   },
    ///   "id": 3
    /// }
    /// ```
    #[method(name = "kala_getTick")]
    async fn get_tick(&self, req: GetTickRequest) -> RpcResult<Option<TickCertificate>>;

    /// Get recent tick certificates for blockchain exploration
    ///
    /// Returns the most recent tick certificates, useful for blockchain
    /// explorers and monitoring tools to display recent activity.
    ///
    /// # Parameters
    ///
    /// - `count`: Number of recent ticks to retrieve (maximum recommended: 100)
    ///
    /// # Returns
    ///
    /// Vector of [`TickCertificate`] ordered from most recent to oldest.
    ///
    /// # Example
    ///
    /// ```json
    /// {
    ///   "jsonrpc": "2.0",
    ///   "method": "kala_getRecentTicks",
    ///   "params": 10,
    ///   "id": 4
    /// }
    /// ```
    #[method(name = "kala_getRecentTicks")]
    async fn get_recent_ticks(&self, count: usize) -> RpcResult<Vec<TickCertificate>>;

    /// Query account information by address
    ///
    /// Retrieves the current state of an account including balance,
    /// nonce, staking information, and delegation status.
    ///
    /// # Parameters
    ///
    /// - `req`: [`GetAccountRequest`] with hex-encoded account address
    ///
    /// # Returns
    ///
    /// `Option<AccountInfo>` - `None` if account doesn't exist or has
    /// never been used, otherwise complete account state information.
    ///
    /// # Example
    ///
    /// ```json
    /// {
    ///   "jsonrpc": "2.0",
    ///   "method": "kala_getAccount",
    ///   "params": {
    ///     "address": "0x1234567890abcdef1234567890abcdef12345678"
    ///   },
    ///   "id": 5
    /// }
    /// ```
    #[method(name = "kala_getAccount")]
    async fn get_account(&self, req: GetAccountRequest) -> RpcResult<Option<AccountInfo>>;
}

/// Configuration for the JSON-RPC server
///
/// Contains network and binding configuration for the HTTP server
/// that hosts the JSON-RPC endpoints.
pub struct RpcConfig {
    /// Socket address to bind the server to (IP:port)
    pub listen_addr: SocketAddr,
}

/// Start the JSON-RPC server with the provided API implementation
///
/// Creates and starts an HTTP server that hosts the JSON-RPC endpoints.
/// This function will run indefinitely, serving requests until the server
/// is explicitly stopped or encounters a fatal error.
///
/// # Parameters
///
/// - `config`: [`RpcConfig`] specifying server binding configuration
/// - `api_impl`: Implementation of the [`KalaApiServer`] trait
///
/// # Returns
///
/// Returns `Ok(())` when the server shuts down gracefully, or an error
/// if the server fails to start or encounters a fatal error.
///
/// # Errors
///
/// - [`KalaError::Network`] if server binding fails
/// - [`KalaError::Network`] if server startup fails
///
/// # Example
///
/// ```no_run
/// use kala_rpc::{RpcConfig, start_server};
/// use std::net::SocketAddr;
///
/// # async fn example() -> kala_common::KalaResult<()> {
/// let config = RpcConfig {
///     listen_addr: "127.0.0.1:8545".parse::<SocketAddr>().unwrap(),
/// };
///
/// // api_impl would be your KalaApiServer implementation
/// # let api_impl = todo!();
/// start_server(config, api_impl).await?;
/// # Ok(())
/// # }
/// ```
pub async fn start_server<T: KalaApiServer>(config: RpcConfig, api_impl: T) -> KalaResult<()> {
    let server = ServerBuilder::default()
        .build(config.listen_addr)
        .await
        .map_err(|e| KalaError::network(format!("Failed to build server: {}", e)))?;

    let addr = server
        .local_addr()
        .map_err(|e| KalaError::network(format!("Failed to get local address: {}", e)))?;
    let handle = server.start(api_impl.into_rpc());

    tracing::info!("RPC server listening on {}", addr);

    handle.stopped().await;
    Ok(())
}

// Implement KalaSerialize for RPC types
// All RPC types use JSON encoding for human readability and HTTP compatibility

impl KalaSerialize for ChainInfo {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for SubmitTransactionRequest {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for SubmitTransactionResponse {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for GetTickRequest {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for GetAccountRequest {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

impl KalaSerialize for AccountInfo {
    /// RPC types use JSON for human readability over HTTP
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json
    }
}

// Validation helpers for RPC request types
// These use kala-common validation utilities for consistency

impl SubmitTransactionRequest {
    /// Validates the hex encoding of the encrypted transaction data
    ///
    /// Ensures the transaction data is properly formatted and can be
    /// decoded from hex. This is the first validation step before
    /// attempting to deserialize the transaction structure.
    ///
    /// # Returns
    ///
    /// - `Ok(())` if the hex encoding is valid
    /// - [`KalaError::Validation`] if the data is empty or invalid hex
    ///
    /// # Example
    ///
    /// ```
    /// use kala_rpc::SubmitTransactionRequest;
    ///
    /// let req = SubmitTransactionRequest {
    ///     encrypted_tx: "0x1234abcd".to_string(),
    /// };
    /// assert!(req.validate().is_ok());
    ///
    /// let bad_req = SubmitTransactionRequest {
    ///     encrypted_tx: "invalid_hex".to_string(),
    /// };
    /// assert!(bad_req.validate().is_err());
    /// ```
    pub fn validate(&self) -> KalaResult<()> {
        if self.encrypted_tx.is_empty() {
            return Err(KalaError::validation(
                "Encrypted transaction cannot be empty",
            ));
        }

        hex::decode(&self.encrypted_tx)
            .map_err(|_| KalaError::validation("Invalid hex encoding in encrypted_tx"))?;

        Ok(())
    }
}

impl GetAccountRequest {
    /// Validates the account address format and returns the parsed public key
    ///
    /// Uses kala-common validation utilities to ensure the address is a
    /// properly formatted public key. This prevents database queries with
    /// malformed addresses and provides early error detection.
    ///
    /// # Returns
    ///
    /// - `Ok(PublicKey)` if the address is valid
    /// - [`KalaError::Validation`] if the address format is invalid
    ///
    /// # Example
    ///
    /// ```
    /// use kala_rpc::GetAccountRequest;
    ///
    /// let req = GetAccountRequest {
    ///     address: "0x1234567890abcdef1234567890abcdef12345678".to_string(),
    /// };
    /// // This would validate if the hex string was a valid public key
    /// // let pubkey = req.validate()?;
    /// ```
    pub fn validate(&self) -> KalaResult<PublicKey> {
        ValidationUtils::validate_pubkey_hex(&self.address)
    }
}
