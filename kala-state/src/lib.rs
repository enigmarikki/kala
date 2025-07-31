use anyhow::Result;
use bincode::{Decode, Encode};
use kala_vdf::{TickCertificate as VDFTickCertificate, VDFCheckpoint};
use rocksdb::{Options, DB};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::sync::Arc;

pub mod account;
pub mod tick;

pub use account::{Account, AccountState};
pub use tick::{TickCertificate, TickType};

/// Global chain state
#[derive(Serialize, Deserialize, Encode, Decode, Clone)]
pub struct ChainState {
    pub current_tick: u64,
    pub current_iteration: u64,
    pub last_tick_hash: [u8; 32],
    pub total_transactions: u64,
    pub vdf_checkpoint: VDFCheckpoint,
    pub tick_size: u64, // k = 65536 by default
    accounts: HashMap<[u8; 32], Account>,
    puzzles: HashMap<[u8; 32], PuzzleState>,
}

#[derive(Serialize, Deserialize, Encode, Decode, Clone)]
pub struct PuzzleState {
    pub solver: [u8; 32],
    pub solution_proof: Vec<u8>,
    pub solved_at_tick: u64,
    pub solved_at_iteration: u64,
}

/// State database wrapper
pub struct StateDB {
    db: Arc<DB>,
}

impl StateDB {
    pub fn open(path: &str) -> Result<Self> {
        let mut opts = Options::default();
        opts.create_if_missing(true);
        opts.set_compression_type(rocksdb::DBCompressionType::Lz4);

        Ok(Self {
            db: Arc::new(DB::open(&opts, path)?),
        })
    }

    pub fn load_chain_state(&self) -> Result<ChainState> {
        match self.db.get(b"chain_state")? {
            Some(data) => {
                let (state, _) = bincode::decode_from_slice(&data, bincode::config::standard())?;
                Ok(state)
            }
            None => Ok(ChainState::new()),
        }
    }

    pub fn save_chain_state(&self, state: &ChainState) -> Result<()> {
        let data = bincode::encode_to_vec(state, bincode::config::standard())?;
        self.db.put(b"chain_state", &data)?;
        Ok(())
    }

    pub fn store_tick(&self, certificate: &TickCertificate) -> Result<()> {
        let key = format!("tick:{:016x}", certificate.tick_number);
        let value = bincode::encode_to_vec(certificate, bincode::config::standard())?;
        self.db.put(key.as_bytes(), &value)?;

        // Update index
        self.update_tick_index(certificate.tick_number)?;

        Ok(())
    }

    pub fn store_vdf_tick_certificate(&self, cert: &VDFTickCertificate) -> Result<()> {
        let key = format!("vdf_tick:{:016x}", cert.tick_number);
        let value = bincode::encode_to_vec(cert, bincode::config::standard())?;
        self.db.put(key.as_bytes(), &value)?;
        Ok(())
    }

    pub fn get_vdf_tick_certificate(&self, tick_number: u64) -> Result<Option<VDFTickCertificate>> {
        let key = format!("vdf_tick:{:016x}", tick_number);
        match self.db.get(key.as_bytes())? {
            Some(data) => {
                let (cert, _) = bincode::decode_from_slice(&data, bincode::config::standard())?;
                Ok(Some(cert))
            }
            None => Ok(None),
        }
    }

    pub fn get_tick(&self, tick_number: u64) -> Result<Option<TickCertificate>> {
        let key = format!("tick:{:016x}", tick_number);
        match self.db.get(key.as_bytes())? {
            Some(data) => {
                let (cert, _) = bincode::decode_from_slice(&data, bincode::config::standard())?;
                Ok(Some(cert))
            }
            None => Ok(None),
        }
    }

    pub fn get_recent_ticks(&self, count: usize) -> Result<Vec<TickCertificate>> {
        let index = self.get_tick_index()?;
        let start = index.saturating_sub(count as u64);

        let mut ticks = Vec::new();
        for i in start..=index {
            if let Some(tick) = self.get_tick(i)? {
                ticks.push(tick);
            }
        }

        Ok(ticks)
    }

    fn update_tick_index(&self, tick_number: u64) -> Result<()> {
        self.db.put(b"tick_index", &tick_number.to_le_bytes())?;
        Ok(())
    }

    fn get_tick_index(&self) -> Result<u64> {
        match self.db.get(b"tick_index")? {
            Some(data) => Ok(u64::from_le_bytes(data.try_into().unwrap())),
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

    pub fn get_account(&self, address: &[u8; 32]) -> Option<&Account> {
        self.accounts.get(address)
    }

    pub fn get_account_mut(&mut self, address: &[u8; 32]) -> &mut Account {
        self.accounts.entry(*address).or_insert(Account::new())
    }

    pub fn get_balance(&self, address: &[u8; 32]) -> u64 {
        self.accounts.get(address).map(|a| a.balance).unwrap_or(0)
    }

    pub fn get_account_nonce(&self, address: &[u8; 32]) -> Option<u64> {
        self.accounts.get(address).map(|a| a.nonce)
    }

    pub fn update_nonce(&mut self, address: &[u8; 32], nonce: u64) {
        self.get_account_mut(address).nonce = nonce;
    }

    pub fn transfer(&mut self, from: &[u8; 32], to: &[u8; 32], amount: u64) -> Result<()> {
        // Deduct from sender
        let sender = self.get_account_mut(from);
        if sender.balance < amount {
            return Err(anyhow::anyhow!("Insufficient balance"));
        }
        sender.balance -= amount;

        // Add to receiver
        let receiver = self.get_account_mut(to);
        receiver.balance += amount;

        Ok(())
    }

    pub fn mint(&mut self, address: &[u8; 32], amount: u64) -> Result<()> {
        let account = self.get_account_mut(address);
        account.balance = account.balance.saturating_add(amount);
        Ok(())
    }

    pub fn stake(&mut self, staker: &[u8; 32], validator: &[u8; 32], amount: u64) -> Result<()> {
        let account = self.get_account_mut(staker);
        if account.balance < amount {
            return Err(anyhow::anyhow!("Insufficient balance"));
        }
        account.balance -= amount;
        account.staked_amount += amount;
        account.delegation = Some(*validator);
        Ok(())
    }

    pub fn record_puzzle_solution(
        &mut self,
        solver: &[u8; 32],
        puzzle_id: &[u8; 32],
        proof: &[u8],
    ) -> Result<()> {
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
