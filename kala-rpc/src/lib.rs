use anyhow::Result;
use jsonrpsee::{core::RpcResult, proc_macros::rpc, server::ServerBuilder};
use kala_state::TickCertificate;
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;

#[derive(Serialize, Deserialize, Clone)]
pub struct ChainInfo {
    pub current_tick: u64,
    pub current_iteration: u64,
    pub vdf_output: String,
    pub hash_chain: String,
    pub total_transactions: u64,
    pub accounts: usize,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct SubmitTransactionRequest {
    pub encrypted_tx: String, // Hex encoded
}

#[derive(Serialize, Deserialize, Clone)]
pub struct SubmitTransactionResponse {
    pub tx_hash: String,
    pub submission_iteration: u64,
    pub target_tick: u64,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct GetTickRequest {
    pub tick_number: u64,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct GetAccountRequest {
    pub address: String, // Hex encoded
}

#[derive(Serialize, Deserialize, Clone)]
pub struct AccountInfo {
    pub balance: u64,
    pub nonce: u64,
    pub staked_amount: u64,
    pub delegation: Option<String>,
}

#[rpc(server)]
pub trait KalaApi {
    #[method(name = "kala_chainInfo")]
    async fn chain_info(&self) -> RpcResult<ChainInfo>;

    #[method(name = "kala_submitTransaction")]
    async fn submit_transaction(
        &self,
        req: SubmitTransactionRequest,
    ) -> RpcResult<SubmitTransactionResponse>;

    #[method(name = "kala_getTick")]
    async fn get_tick(&self, req: GetTickRequest) -> RpcResult<Option<TickCertificate>>;

    #[method(name = "kala_getRecentTicks")]
    async fn get_recent_ticks(&self, count: usize) -> RpcResult<Vec<TickCertificate>>;

    #[method(name = "kala_getAccount")]
    async fn get_account(&self, req: GetAccountRequest) -> RpcResult<Option<AccountInfo>>;
}

/// RPC server configuration
pub struct RpcConfig {
    pub listen_addr: SocketAddr,
}

/// Start the JSON-RPC server
pub async fn start_server<T: KalaApiServer>(config: RpcConfig, api_impl: T) -> Result<()> {
    let server = ServerBuilder::default().build(config.listen_addr).await?;

    let addr = server.local_addr()?;
    let handle = server.start(api_impl.into_rpc());

    tracing::info!("RPC server listening on {}", addr);

    handle.stopped().await;
    Ok(())
}
