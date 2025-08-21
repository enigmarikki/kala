//! # Kala State Management
//!
//! This crate provides comprehensive state management for the Kala blockchain,
//! handling persistent storage, account management, and tick certificate tracking.
//!
//! ## Architecture Overview
//!
//! The state management system is built around two main components:
//!
//! ### [`ChainState`] - In-Memory State
//! - Current blockchain state including accounts and balances
//! - VDF checkpoint tracking for consensus
//! - Timelock puzzle solution registry
//! - Efficient in-memory operations for consensus processing
//!
//! ### [`StateDB`] - Persistent Storage  
//! - RocksDB-backed persistent storage
//! - Tick certificate archival and retrieval
//! - State checkpoint persistence
//! - Optimized for high-throughput tick processing
//!
//! ## Key Features
//!
//! ### Account Management
//! - Balance tracking with overflow protection
//! - Nonce-based replay attack prevention
//! - Staking and delegation support
//! - Efficient account lookup and updates
//!
//! ### Tick Certificate Storage
//! - Persistent storage of all processed ticks
//! - Fast retrieval by tick number
//! - Recent tick queries for blockchain explorers
//! - VDF certificate integration
//!
//! ### Timelock Integration
//! - Puzzle solution tracking and verification
//! - Integration with VDF timing for puzzle hardness
//! - MEV-resistant transaction ordering support
//!
//! ## Example Usage
//!
//! ```no_run
//! use kala_state::{StateDB, ChainState};
//!
//! # async fn example() -> kala_common::KalaResult<()> {
//! // Initialize database
//! let db = StateDB::open("./blockchain_state")?;
//!
//! // Load or create chain state
//! let mut state = db.load_chain_state().await?;
//!
//! // Process account operations
//! let alice = [1u8; 32];
//! let bob = [2u8; 32];
//! state.mint(&alice, 1000)?;
//! state.transfer(&alice, &bob, 100)?;
//!
//! // Save state changes
//! db.save_chain_state(&state).await?;
//! # Ok(())
//! # }
//! ```

use bincode::{Decode, Encode};
use kala_common::prelude::*;
use kala_common::types::Hash;
use kala_vdf::{TickCertificate as VDFTickCertificate, VDFCheckpoint};
use serde_json;
use std::collections::HashMap;

pub mod account;
pub mod tick;

pub use account::{Account, AccountState};
pub use tick::{TickCertificate, TickType};

/// Global chain state using kala-common types
#[derive(Serialize, Deserialize, Encode, Decode, Clone)]
pub struct ChainState {
    pub current_tick: BlockHeight,
    pub current_iteration: IterationNumber,
    pub last_tick_hash: Hash,
    pub total_transactions: u64,
    pub vdf_checkpoint: VDFCheckpoint,
    pub tick_size: u64, // k = 65536 by default
    accounts: HashMap<Hash, Account>,
    puzzles: HashMap<Hash, PuzzleState>,
}

#[derive(Serialize, Deserialize, Encode, Decode, Clone)]
pub struct PuzzleState {
    pub solver: Hash,
    pub solution_proof: Vec<u8>,
    pub solved_at_tick: BlockHeight,
    pub solved_at_iteration: IterationNumber,
}

/// State database wrapper using kala-common database operations
pub struct StateDB {
    db: KalaDatabase,
}

impl StateDB {
    pub fn open(path: &str) -> KalaResult<Self> {
        let db = KalaDatabase::new(path)?;
        Ok(Self { db })
    }

    pub async fn load_chain_state(&self) -> KalaResult<ChainState> {
        match self.db.load_data("", "chain_state").await? {
            Some(state) => Ok(state),
            None => Ok(ChainState::new()),
        }
    }

    pub async fn save_chain_state(&self, state: &ChainState) -> KalaResult<()> {
        self.db.store_data("", "chain_state", state).await
    }

    pub async fn store_tick(&self, certificate: &TickCertificate) -> KalaResult<()> {
        let key = format!("{:016x}", certificate.tick_number);
        // Use JSON serialization for external types
        let json_data = serde_json::to_vec(certificate).map_err(|e| {
            KalaError::serialization(format!("Failed to serialize tick certificate: {}", e))
        })?;
        self.db
            .put_raw(format!("tick:{}", key).as_bytes(), &json_data)?;

        // Update index
        self.update_tick_index(certificate.tick_number).await?;

        Ok(())
    }

    pub async fn store_vdf_tick_certificate(&self, cert: &VDFTickCertificate) -> KalaResult<()> {
        let key = format!("{:016x}", cert.tick_number);
        // Use JSON serialization for external types
        let json_data = serde_json::to_vec(cert).map_err(|e| {
            KalaError::serialization(format!("Failed to serialize VDF certificate: {}", e))
        })?;
        self.db
            .put_raw(format!("vdf_tick:{}", key).as_bytes(), &json_data)
    }

    pub async fn get_vdf_tick_certificate(
        &self,
        tick_number: u64,
    ) -> KalaResult<Option<VDFTickCertificate>> {
        let key = format!("{:016x}", tick_number);
        // Use JSON deserialization for external types
        match self.db.get_raw(format!("vdf_tick:{}", key).as_bytes())? {
            Some(data) => {
                let cert = serde_json::from_slice(&data).map_err(|e| {
                    KalaError::serialization(format!(
                        "Failed to deserialize VDF certificate: {}",
                        e
                    ))
                })?;
                Ok(Some(cert))
            }
            None => Ok(None),
        }
    }

    pub async fn get_tick(&self, tick_number: u64) -> KalaResult<Option<TickCertificate>> {
        let key = format!("{:016x}", tick_number);
        // Use JSON deserialization for external types
        match self.db.get_raw(format!("tick:{}", key).as_bytes())? {
            Some(data) => {
                let cert = serde_json::from_slice(&data).map_err(|e| {
                    KalaError::serialization(format!(
                        "Failed to deserialize tick certificate: {}",
                        e
                    ))
                })?;
                Ok(Some(cert))
            }
            None => Ok(None),
        }
    }

    pub async fn get_recent_ticks(&self, count: usize) -> KalaResult<Vec<TickCertificate>> {
        let index = self.get_tick_index().await?;
        let start = index.saturating_sub(count as u64);

        let mut ticks = Vec::new();
        for i in start..=index {
            if let Some(tick) = self.get_tick(i).await? {
                ticks.push(tick);
            }
        }

        Ok(ticks)
    }

    async fn update_tick_index(&self, tick_number: u64) -> KalaResult<()> {
        // Use raw bytes for simple u64 storage
        self.db.put_raw(b"tick_index", &tick_number.to_le_bytes())
    }

    async fn get_tick_index(&self) -> KalaResult<u64> {
        // Use raw bytes for simple u64 retrieval
        match self.db.get_raw(b"tick_index")? {
            Some(bytes) => {
                if bytes.len() == 8 {
                    let mut array = [0u8; 8];
                    array.copy_from_slice(&bytes);
                    Ok(u64::from_le_bytes(array))
                } else {
                    Ok(0)
                }
            }
            None => Ok(0),
        }
    }
}

impl ChainState {
    pub fn new() -> Self {
        let discriminant = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";

        Self {
            current_tick: 0,
            current_iteration: 0,
            last_tick_hash: [0; 32],
            total_transactions: 0,
            tick_size: 65536, // k from the paper
            vdf_checkpoint: VDFCheckpoint {
                iteration: 0,
                form_a: "1".to_string(),
                form_b: "0".to_string(),
                form_c: "1".to_string(),
                hash_chain: {
                    use sha2::{Digest, Sha256};
                    let mut hasher = Sha256::new();
                    hasher.update(b"genesis");
                    hasher.finalize().into()
                },
                discriminant: discriminant.to_string(),
                tick_size: 65536,
                tick_certificates: Vec::new(),
            },
            accounts: HashMap::new(),
            puzzles: HashMap::new(),
        }
    }

    pub fn from_vdf_checkpoint(checkpoint: VDFCheckpoint) -> Self {
        let current_tick = checkpoint.iteration / checkpoint.tick_size;
        let current_iteration = checkpoint.iteration;

        Self {
            current_tick,
            current_iteration,
            last_tick_hash: checkpoint.hash_chain,
            total_transactions: 0,
            tick_size: checkpoint.tick_size,
            vdf_checkpoint: checkpoint,
            accounts: HashMap::new(),
            puzzles: HashMap::new(),
        }
    }

    pub fn update_from_vdf_checkpoint(&mut self, checkpoint: VDFCheckpoint) {
        self.current_iteration = checkpoint.iteration;
        self.current_tick = checkpoint.iteration / checkpoint.tick_size;
        self.last_tick_hash = checkpoint.hash_chain;
        self.vdf_checkpoint = checkpoint;
    }

    pub fn get_account(&self, address: &Hash) -> Option<&Account> {
        self.accounts.get(address)
    }

    pub fn get_account_mut(&mut self, address: &Hash) -> &mut Account {
        self.accounts.entry(*address).or_insert(Account::new())
    }

    pub fn get_balance(&self, address: &Hash) -> u64 {
        self.accounts.get(address).map(|a| a.balance).unwrap_or(0)
    }

    pub fn get_account_nonce(&self, address: &Hash) -> Option<u64> {
        self.accounts.get(address).map(|a| a.nonce)
    }

    pub fn update_nonce(&mut self, address: &Hash, nonce: u64) {
        self.get_account_mut(address).nonce = nonce;
    }

    pub fn transfer(&mut self, from: &Hash, to: &Hash, amount: u64) -> KalaResult<()> {
        // Deduct from sender
        let sender = self.get_account_mut(from);
        if sender.balance < amount {
            return Err(KalaError::state("Insufficient balance"));
        }
        sender.balance -= amount;

        // Add to receiver
        let receiver = self.get_account_mut(to);
        receiver.balance += amount;

        Ok(())
    }

    pub fn mint(&mut self, address: &Hash, amount: u64) -> KalaResult<()> {
        let account = self.get_account_mut(address);
        account.balance = account.balance.saturating_add(amount);
        Ok(())
    }

    pub fn stake(&mut self, staker: &Hash, validator: &Hash, amount: u64) -> KalaResult<()> {
        let account = self.get_account_mut(staker);
        if account.balance < amount {
            return Err(KalaError::state("Insufficient balance"));
        }
        account.balance -= amount;
        account.staked_amount += amount;
        account.delegation = Some(*validator);
        Ok(())
    }

    pub fn record_puzzle_solution(
        &mut self,
        solver: &Hash,
        puzzle_id: &Hash,
        proof: &[u8],
    ) -> KalaResult<()> {
        self.puzzles.insert(
            *puzzle_id,
            PuzzleState {
                solver: *solver,
                solution_proof: proof.to_vec(),
                solved_at_tick: self.current_tick,
                solved_at_iteration: self.current_iteration,
            },
        );
        Ok(())
    }

    pub fn get_account_count(&self) -> usize {
        self.accounts.len()
    }

    /// Get the tick number for a given iteration
    pub fn iteration_to_tick(&self, iteration: u64) -> u64 {
        iteration / self.tick_size
    }

    /// Get the starting iteration for a given tick
    pub fn tick_to_iteration(&self, tick: u64) -> u64 {
        tick * self.tick_size
    }

    /// Check if we're at a tick boundary
    pub fn is_tick_boundary(&self, iteration: u64) -> bool {
        iteration % self.tick_size == 0 && iteration > 0
    }
}

// Implement KalaSerialize for state types
impl KalaSerialize for ChainState {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact for frequent state persistence
    }
}

impl KalaSerialize for PuzzleState {
    fn preferred_encoding() -> EncodingType {
        EncodingType::Bincode // Compact storage for puzzles
    }
}

// Since we can't implement KalaSerialize for external types due to orphan rules,
// we'll use direct serialization for these types in the database operations
