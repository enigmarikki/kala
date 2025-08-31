// Standardized networking patterns for Kala
// This module provides consistent patterns for network communication

use anyhow::{anyhow, Result};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::sync::Arc;
use std::time::{Duration, SystemTime, UNIX_EPOCH};
use tokio::sync::RwLock;
use tracing::{debug, warn};

use crate::serialization::{EncodingType, KalaSerialize, NetworkMessage};

/// Network protocol version
pub const PROTOCOL_VERSION: u32 = 1;

pub use crate::types::network::MAX_MESSAGE_SIZE;

/// Network node identifier
pub type NodeId = [u8; 32];

/// Message types used throughout Kala network
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MessageType {
    // VDF-related messages
    VDFCheckpoint,
    TickCertificate,

    // Transaction messages
    TimelockTransaction,
    TransactionBatch,

    // State synchronization
    StateRequest,
    StateResponse,

    // Peer discovery and health
    Ping,
    Pong,
    PeerDiscovery,

    // Custom message types
    Custom(String),
}

impl MessageType {
    pub fn as_str(&self) -> &str {
        match self {
            Self::VDFCheckpoint => "vdf_checkpoint",
            Self::TickCertificate => "tick_certificate",
            Self::TimelockTransaction => "timelock_transaction",
            Self::TransactionBatch => "transaction_batch",
            Self::StateRequest => "state_request",
            Self::StateResponse => "state_response",
            Self::Ping => "ping",
            Self::Pong => "pong",
            Self::PeerDiscovery => "peer_discovery",
            Self::Custom(s) => s,
        }
    }
}

/// Network configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NetworkConfig {
    pub listen_address: String,
    pub max_peers: usize,
    pub connection_timeout: Duration,
    pub keepalive_interval: Duration,
    pub message_buffer_size: usize,
}

impl Default for NetworkConfig {
    fn default() -> Self {
        Self {
            listen_address: "0.0.0.0:1719".to_string(),
            max_peers: 100,
            connection_timeout: Duration::from_secs(30),
            keepalive_interval: Duration::from_secs(60),
            message_buffer_size: 1000,
        }
    }
}

/// Peer connection information
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PeerInfo {
    pub id: NodeId,
    pub address: String,
    pub last_seen: u64,
    pub protocol_version: u32,
    pub connected: bool,
    pub ping_ms: Option<u32>,
}

impl KalaSerialize for PeerInfo {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode
    }
}

/// Network statistics for monitoring
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct NetworkStats {
    pub messages_sent: HashMap<String, u64>,
    pub messages_received: HashMap<String, u64>,
    pub bytes_sent: u64,
    pub bytes_received: u64,
    pub connections_established: u64,
    pub connections_dropped: u64,
    pub peer_count: usize,
    pub uptime_seconds: u64,
}

impl KalaSerialize for NetworkStats {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Json // Human-readable for monitoring
    }
}

/// Message handler trait for processing different message types
#[async_trait::async_trait]
pub trait MessageHandler: Send + Sync {
    async fn handle_message(
        &self,
        message: &NetworkMessage,
        sender: &NodeId,
    ) -> Result<Option<NetworkMessage>>;

    fn supported_message_types(&self) -> Vec<MessageType>;
}

/// Network layer abstraction
pub struct NetworkLayer {
    config: NetworkConfig,
    node_id: NodeId,
    peers: Arc<RwLock<HashMap<NodeId, PeerInfo>>>,
    handlers: Arc<RwLock<HashMap<String, Arc<dyn MessageHandler>>>>,
    stats: Arc<RwLock<NetworkStats>>,
    start_time: SystemTime,
}

impl NetworkLayer {
    pub fn new(config: NetworkConfig, node_id: NodeId) -> Self {
        Self {
            config,
            node_id,
            peers: Arc::new(RwLock::new(HashMap::new())),
            handlers: Arc::new(RwLock::new(HashMap::new())),
            stats: Arc::new(RwLock::new(NetworkStats::default())),
            start_time: SystemTime::now(),
        }
    }

    /// Register a message handler for specific message types
    pub async fn register_handler(&self, handler: Arc<dyn MessageHandler>) {
        let mut handlers = self.handlers.write().await;
        for msg_type in handler.supported_message_types() {
            handlers.insert(msg_type.as_str().to_string(), handler.clone());
        }
    }

    /// Send a message to a specific peer
    pub async fn send_to_peer<T: KalaSerialize>(
        &self,
        peer_id: &NodeId,
        message_type: MessageType,
        payload: &T,
    ) -> Result<()> {
        let message = NetworkMessage::new(message_type.as_str(), payload, Some(self.node_id))?;

        // Update statistics
        let mut stats = self.stats.write().await;
        let msg_type_str = message_type.as_str().to_string();
        *stats.messages_sent.entry(msg_type_str).or_insert(0) += 1;
        stats.bytes_sent += message.payload.len() as u64;

        // TODO: Implement actual network sending
        debug!(
            "Sending {} message to peer {:?}",
            message_type.as_str(),
            peer_id
        );

        Ok(())
    }

    /// Broadcast a message to all connected peers
    pub async fn broadcast<T: KalaSerialize>(
        &self,
        message_type: MessageType,
        payload: &T,
    ) -> Result<()> {
        let peers = self.peers.read().await;
        let connected_peers: Vec<NodeId> = peers
            .iter()
            .filter(|(_, info)| info.connected)
            .map(|(id, _)| *id)
            .collect();

        drop(peers);

        for peer_id in connected_peers {
            if let Err(e) = self
                .send_to_peer(&peer_id, message_type.clone(), payload)
                .await
            {
                warn!("Failed to send message to peer {:?}: {}", peer_id, e);
            }
        }

        Ok(())
    }

    /// Process an incoming message
    pub async fn handle_incoming_message(
        &self,
        message: NetworkMessage,
        sender: &NodeId,
    ) -> Result<()> {
        // Update receive statistics
        let mut stats = self.stats.write().await;
        let msg_type = message.message_type.clone();
        *stats.messages_received.entry(msg_type.clone()).or_insert(0) += 1;
        stats.bytes_received += message.payload.len() as u64;
        drop(stats);

        // Find appropriate handler
        let handlers = self.handlers.read().await;
        if let Some(handler) = handlers.get(&msg_type) {
            let handler = handler.clone();
            drop(handlers);

            match handler.handle_message(&message, sender).await {
                Ok(Some(_response)) => {
                    // Send response back to sender
                    // TODO: Implement response sending
                    debug!("Generated response for {}", msg_type);
                }
                Ok(None) => {
                    debug!("Message {} processed successfully", msg_type);
                }
                Err(e) => {
                    warn!("Handler failed for message {}: {}", msg_type, e);
                }
            }
        } else {
            warn!("No handler registered for message type: {}", msg_type);
        }

        Ok(())
    }

    /// Add or update peer information
    pub async fn update_peer(&self, peer_info: PeerInfo) {
        let mut peers = self.peers.write().await;
        peers.insert(peer_info.id, peer_info);

        // Update peer count in stats
        let mut stats = self.stats.write().await;
        stats.peer_count = peers.len();
    }

    /// Remove a peer
    pub async fn remove_peer(&self, peer_id: &NodeId) {
        let mut peers = self.peers.write().await;
        peers.remove(peer_id);

        // Update stats
        let mut stats = self.stats.write().await;
        stats.peer_count = peers.len();
        stats.connections_dropped += 1;
    }

    /// Get current network statistics
    pub async fn get_stats(&self) -> NetworkStats {
        let mut stats = self.stats.read().await.clone();

        // Update uptime
        stats.uptime_seconds = self
            .start_time
            .elapsed()
            .unwrap_or(Duration::ZERO)
            .as_secs();

        stats
    }

    /// Get list of connected peers
    pub async fn get_peers(&self) -> Vec<PeerInfo> {
        self.peers.read().await.values().cloned().collect()
    }

    /// Start periodic maintenance tasks
    pub async fn start_maintenance(&self) {
        let peers = self.peers.clone();
        let config = self.config.clone();

        tokio::spawn(async move {
            let mut interval = tokio::time::interval(config.keepalive_interval);

            loop {
                interval.tick().await;

                // Clean up disconnected peers
                let mut peers_write = peers.write().await;
                let now = SystemTime::now()
                    .duration_since(UNIX_EPOCH)
                    .unwrap_or(Duration::ZERO)
                    .as_secs();

                peers_write.retain(|_, peer| {
                    let age = now.saturating_sub(peer.last_seen);
                    age < config.connection_timeout.as_secs()
                });

                debug!("Network maintenance: {} active peers", peers_write.len());
            }
        });
    }
}

/// Standard ping message for keepalive
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PingMessage {
    pub timestamp: u64,
    pub node_id: NodeId,
    pub protocol_version: u32,
}

impl KalaSerialize for PingMessage {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode
    }
}

/// Standard pong response
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PongMessage {
    pub timestamp: u64,
    pub original_timestamp: u64,
    pub node_id: NodeId,
}

impl KalaSerialize for PongMessage {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode
    }
}

/// Basic ping/pong handler for keepalive
pub struct PingPongHandler {
    node_id: NodeId,
}

impl PingPongHandler {
    pub fn new(node_id: NodeId) -> Self {
        Self { node_id }
    }
}

#[async_trait::async_trait]
impl MessageHandler for PingPongHandler {
    async fn handle_message(
        &self,
        message: &NetworkMessage,
        sender: &NodeId,
    ) -> Result<Option<NetworkMessage>> {
        match message.message_type.as_str() {
            "ping" => {
                let ping: PingMessage = message.decode_payload()?;

                let pong = PongMessage {
                    timestamp: SystemTime::now()
                        .duration_since(UNIX_EPOCH)
                        .unwrap_or(Duration::ZERO)
                        .as_secs(),
                    original_timestamp: ping.timestamp,
                    node_id: self.node_id,
                };

                let response = NetworkMessage::new("pong", &pong, Some(self.node_id))?;
                Ok(Some(response))
            }
            "pong" => {
                let _pong: PongMessage = message.decode_payload()?;
                debug!("Received pong from {:?}", sender);
                Ok(None)
            }
            _ => Err(anyhow!(
                "Unsupported message type: {}",
                message.message_type
            )),
        }
    }

    fn supported_message_types(&self) -> Vec<MessageType> {
        vec![MessageType::Ping, MessageType::Pong]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_network_layer_creation() {
        let config = NetworkConfig::default();
        let node_id = [0u8; 32];
        let network = NetworkLayer::new(config, node_id);

        let stats = network.get_stats().await;
        assert_eq!(stats.peer_count, 0);
    }

    #[tokio::test]
    async fn test_ping_pong_handler() {
        let node_id = [1u8; 32];
        let handler = PingPongHandler::new(node_id);

        let ping = PingMessage {
            timestamp: 1234567890,
            node_id: [2u8; 32],
            protocol_version: PROTOCOL_VERSION,
        };

        let ping_msg = NetworkMessage::new("ping", &ping, Some([2u8; 32])).unwrap();
        let sender = [2u8; 32];

        let response = handler.handle_message(&ping_msg, &sender).await.unwrap();
        assert!(response.is_some());

        if let Some(resp) = response {
            assert_eq!(resp.message_type, "pong");
        }
    }
}
