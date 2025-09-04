// kala-state/src/lib.rs
use kala_common::{
    crypto::CryptoUtils,
    database::{DatabaseOps, KalaDatabase, TypedDatabaseOps},
    error::{KalaError, KalaResult},
    types::{Hash, HashExt, IterationNumber, NodeId, PublicKey, Signature, TickNumber, Timestamp},
};
use kala_tick::{Discriminant, QuadraticForm};
use kala_transaction::types::{
    Burn, Bytes32, Mint, RSWPuzzle, SealedTransaction, Send, Solve, Stake, Transaction, Unstake,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use std::sync::Arc;
// Constants from the whitepaper
const K_ITERATIONS: u64 = 65536;
const COLLECTION_PHASE_END: u64 = 21845;
const CONSENSUS_PHASE_END: u64 = 43690;
const RSW_HARDNESS_CONSTANT: u64 = 32768;
const BYZANTINE_THRESHOLD_DENOMINATOR: usize = 3;

/// Account state
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Account {
    pub address: Bytes32,
    pub balances: BTreeMap<Bytes32, u64>,
    pub stake: BTreeMap<Bytes32, u64>,
    pub nonce: u64,
    pub puzzles_solved: Vec<Bytes32>,
}
/// Encrypted envelope for MEV prevention
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EncryptedEnvelope {
    pub hash: Hash,
    pub ciphertext: SealedTransaction,
    pub puzzle: RSWPuzzle,
    pub witnessed_iteration: IterationNumber,
    pub witness_chain_id: NodeId,
}

/// Witness observation
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WitnessObservation {
    pub envelope_hash: Hash,
    pub iteration_seen: IterationNumber,
    pub chain_id: NodeId,
    pub vdf_proof: Vec<u8>,
}

/// Canonical timestamp after Byzantine agreement
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CanonicalTimestamp {
    pub envelope_hash: Hash,
    pub canonical_iteration: IterationNumber,
    pub witness_count: usize,
    pub observations: Vec<WitnessObservation>,
}

/// Tick phase
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum TickPhase {
    Collection,
    Consensus,
    Decryption,
    StateUpdate,
    Finalization,
}

/// Tick status
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TickStatus {
    FullTick {
        transactions: Vec<Transaction>,
        state_root: Hash,
    },
    PartialTick {
        transactions: Vec<Transaction>,
        witness_count: usize,
    },
    WitnessTick {
        vdf_proofs: Vec<Vec<u8>>,
    },
}

/// Complete tick state
#[derive(Debug, Clone)]
pub struct TickState {
    pub tick_number: TickNumber,
    pub start_iteration: IterationNumber,
    pub end_iteration: IterationNumber,
    pub vdf_form: QuadraticForm,
    pub vdf_proof: Vec<u8>,
    pub status: TickStatus,
    pub canonical_timestamps: Vec<CanonicalTimestamp>,
    pub state_root: Hash,
    pub witness_signatures: BTreeMap<NodeId, Signature>,
}

/// Main Kala blockchain state
#[derive(Debug, Clone)]
pub struct KalaState {
    // Chain identification
    pub chain_id: NodeId,
    pub witness_set: BTreeMap<NodeId, bool>,
    pub byzantine_threshold: usize,

    // Current state
    pub current_tick: TickNumber,
    pub current_iteration: IterationNumber,
    pub current_phase: TickPhase,

    // VDF state from kala_tick
    pub vdf_discriminant: Discriminant,
    pub vdf_current_form: QuadraticForm,
    pub vdf_proof_cache: BTreeMap<IterationNumber, Vec<u8>>,

    // Account state - BTreeMap for determinism
    pub accounts: BTreeMap<Bytes32, Account>,
    pub total_supply: BTreeMap<Bytes32, u64>,

    // Transaction processing
    pub pending_envelopes: Vec<EncryptedEnvelope>,
    pub observations: BTreeMap<Hash, Vec<WitnessObservation>>,
    pub decrypted_transactions: BTreeMap<Hash, Transaction>,

    // Tick history
    pub tick_history: BTreeMap<TickNumber, TickState>,
    pub last_finalized_tick: TickNumber,

    // Metrics
    pub total_transactions: u64,
    pub total_iterations: IterationNumber,
}

impl KalaState {
    pub fn genesis(chain_id: NodeId, witness_ids: Vec<NodeId>) -> Self {
        let witness_set: BTreeMap<NodeId, bool> =
            witness_ids.into_iter().map(|id| (id, true)).collect();
        let byzantine_threshold = witness_set.len() / BYZANTINE_THRESHOLD_DENOMINATOR;

        let vdf_discriminant = Self::default_discriminant();
        let vdf_current_form = QuadraticForm::identity(&vdf_discriminant);

        Self {
            chain_id,
            witness_set,
            byzantine_threshold,
            current_tick: 0,
            current_iteration: 0,
            current_phase: TickPhase::Collection,
            vdf_discriminant,
            vdf_current_form,
            vdf_proof_cache: BTreeMap::new(),
            accounts: BTreeMap::new(),
            total_supply: BTreeMap::new(),
            pending_envelopes: Vec::new(),
            observations: BTreeMap::new(),
            decrypted_transactions: BTreeMap::new(),
            tick_history: BTreeMap::new(),
            last_finalized_tick: 0,
            total_transactions: 0,
            total_iterations: 0,
        }
    }

    fn default_discriminant() -> Discriminant {
        // Chia's production discriminant
        Discriminant::from_dec(
           "-124066695684124741398798927404814432744698427125735684128131855064976895337309138910015071214657674309443149407457784008482598157929231340464085999434282861720534396192739736935050532214954818802779747295302822211107847281287030932738037727304145398879969731231251163866678649517086953552040496395816730581483"
       ).expect("Valid discriminant")
    }

    pub fn get_current_phase(&self) -> TickPhase {
        let iteration_in_tick = self.current_iteration % K_ITERATIONS;
        if iteration_in_tick < COLLECTION_PHASE_END {
            TickPhase::Collection
        } else if iteration_in_tick < CONSENSUS_PHASE_END {
            TickPhase::Consensus
        } else if iteration_in_tick < RSW_HARDNESS_CONSTANT {
            TickPhase::Consensus
        } else if iteration_in_tick < (K_ITERATIONS * 5 / 6) {
            TickPhase::Decryption
        } else {
            TickPhase::StateUpdate
        }
    }

    pub fn compute_state_root(&self) -> KalaResult<Hash> {
        let account_hashes: Vec<Hash> = self
            .accounts
            .values()
            .map(|account| {
                // Use bincode instead of serde_json for byte array serialization
                let bytes = bincode::serialize(account)
                    .map_err(|e| KalaError::serialization(format!("Failed to serialize: {}", e)))?;
                Ok(CryptoUtils::hash(&bytes))
            })
            .collect::<KalaResult<Vec<_>>>()?;

        Ok(CryptoUtils::merkle_root_from_hashes(&account_hashes))
    }
    pub fn apply_transaction(&mut self, tx: &Transaction) -> KalaResult<()> {
        match tx {
            Transaction::Send(send) => self.apply_send(send),
            Transaction::Mint(mint) => self.apply_mint(mint),
            Transaction::Burn(burn) => self.apply_burn(burn),
            Transaction::Stake(stake) => self.apply_stake(stake),
            Transaction::Unstake(unstake) => self.apply_unstake(unstake),
            Transaction::Solve(solve) => self.apply_solve(solve),
        }
    }

    fn apply_send(&mut self, send: &Send) -> KalaResult<()> {
        // Validate signature
        send.validate()?;

        // Get sender account
        let sender_account = self
            .accounts
            .get_mut(&send.sender)
            .ok_or_else(|| KalaError::validation("Sender account not found"))?;

        // Check nonce
        if sender_account.nonce != send.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        // Check balance
        let sender_balance = *sender_account.balances.get(&send.denom).unwrap_or(&0);
        if sender_balance < send.amount {
            return Err(KalaError::validation("Insufficient balance"));
        }

        // Update sender
        sender_account
            .balances
            .insert(send.denom, sender_balance - send.amount);
        sender_account.nonce += 1;

        // Update receiver
        let receiver_account = self
            .accounts
            .entry(send.receiver)
            .or_insert_with(|| Account {
                address: send.receiver,
                balances: BTreeMap::new(),
                stake: BTreeMap::new(),
                nonce: 0,
                puzzles_solved: Vec::new(),
            });

        let receiver_balance = *receiver_account.balances.get(&send.denom).unwrap_or(&0);
        receiver_account
            .balances
            .insert(send.denom, receiver_balance + send.amount);

        self.total_transactions += 1;
        Ok(())
    }

    fn apply_mint(&mut self, mint: &Mint) -> KalaResult<()> {
        // Check minting permissions (placeholder - add real logic)
        let account = self.accounts.entry(mint.sender).or_insert_with(|| Account {
            address: mint.sender,
            balances: BTreeMap::new(),
            stake: BTreeMap::new(),
            nonce: 0,
            puzzles_solved: Vec::new(),
        });

        if account.nonce != mint.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        let current = *account.balances.get(&mint.denom).unwrap_or(&0);
        account.balances.insert(mint.denom, current + mint.amount);
        account.nonce += 1;

        // Update total supply
        let total = self.total_supply.entry(mint.denom).or_insert(0);
        *total += mint.amount;

        self.total_transactions += 1;
        Ok(())
    }

    fn apply_burn(&mut self, burn: &Burn) -> KalaResult<()> {
        let account = self
            .accounts
            .get_mut(&burn.sender)
            .ok_or_else(|| KalaError::validation("Account not found"))?;

        if account.nonce != burn.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        let current = *account.balances.get(&burn.denom).unwrap_or(&0);
        if current < burn.amount {
            return Err(KalaError::validation("Insufficient balance"));
        }

        account.balances.insert(burn.denom, current - burn.amount);
        account.nonce += 1;

        // Update total supply
        if let Some(total) = self.total_supply.get_mut(&burn.denom) {
            *total = total.saturating_sub(burn.amount);
        }

        self.total_transactions += 1;
        Ok(())
    }

    fn apply_stake(&mut self, stake: &Stake) -> KalaResult<()> {
        let account = self
            .accounts
            .get_mut(&stake.delegator)
            .ok_or_else(|| KalaError::validation("Delegator not found"))?;

        if account.nonce != stake.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        // Assume native token for staking
        let native_denom = [0u8; 32];
        let balance = *account.balances.get(&native_denom).unwrap_or(&0);

        if balance < stake.amount {
            return Err(KalaError::validation("Insufficient balance for staking"));
        }

        // Move from balance to stake
        account
            .balances
            .insert(native_denom, balance - stake.amount);
        let current_stake = *account.stake.get(&stake.witness).unwrap_or(&0);
        account
            .stake
            .insert(stake.witness, current_stake + stake.amount);
        account.nonce += 1;

        self.total_transactions += 1;
        Ok(())
    }

    fn apply_unstake(&mut self, unstake: &Unstake) -> KalaResult<()> {
        let account = self
            .accounts
            .get_mut(&unstake.delegator)
            .ok_or_else(|| KalaError::validation("Delegator not found"))?;

        if account.nonce != unstake.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        let current_stake = *account.stake.get(&unstake.witness).unwrap_or(&0);
        if current_stake < unstake.amount {
            return Err(KalaError::validation("Insufficient stake"));
        }

        // Move from stake to balance
        let native_denom = [0u8; 32];
        let balance = *account.balances.get(&native_denom).unwrap_or(&0);
        account
            .balances
            .insert(native_denom, balance + unstake.amount);

        if current_stake == unstake.amount {
            account.stake.remove(&unstake.witness);
        } else {
            account
                .stake
                .insert(unstake.witness, current_stake - unstake.amount);
        }
        account.nonce += 1;

        self.total_transactions += 1;
        Ok(())
    }

    fn apply_solve(&mut self, solve: &Solve) -> KalaResult<()> {
        solve.validate()?;

        let account = self
            .accounts
            .get_mut(&solve.sender)
            .ok_or_else(|| KalaError::validation("Solver not found"))?;

        if account.nonce != solve.nonce {
            return Err(KalaError::validation("Invalid nonce"));
        }

        if account.puzzles_solved.contains(&solve.puzzle_id) {
            return Err(KalaError::validation("Puzzle already solved"));
        }

        account.puzzles_solved.push(solve.puzzle_id);
        account.nonce += 1;

        // Add puzzle reward logic here

        self.total_transactions += 1;
        Ok(())
    }

    pub fn verify_state(&self) -> KalaResult<()> {
        // Verify balances match supply
        for (denom, total_supply) in &self.total_supply {
            let sum: u64 = self
                .accounts
                .values()
                .map(|acc| *acc.balances.get(denom).unwrap_or(&0))
                .sum();

            if sum != *total_supply {
                return Err(KalaError::validation(format!(
                    "Balance sum {} != supply {}",
                    sum, total_supply
                )));
            }
        }

        // Verify iteration count
        if self.current_iteration
            != self.current_tick * K_ITERATIONS + (self.current_iteration % K_ITERATIONS)
        {
            return Err(KalaError::validation("Iteration count inconsistent"));
        }

        Ok(())
    }
    pub fn update_vdf_state(
        &mut self,
        form: QuadraticForm,
        proof: Vec<u8>,
        iteration: IterationNumber,
    ) {
        self.vdf_current_form = form;
        self.vdf_proof_cache.insert(iteration, proof);
        self.total_iterations = iteration;
    }

    pub fn update_tick_state(
        &mut self,
        tick: TickNumber,
        phase: TickPhase,
        iteration: IterationNumber,
    ) {
        self.current_tick = tick;
        self.current_phase = phase;
        self.current_iteration = iteration;
    }

    pub fn add_envelope(&mut self, envelope: EncryptedEnvelope) {
        self.pending_envelopes.push(envelope);
    }

    pub fn add_observation(&mut self, hash: Hash, observation: WitnessObservation) {
        self.observations
            .entry(hash)
            .or_insert_with(Vec::new)
            .push(observation);
    }

    pub fn add_decrypted_transaction(&mut self, hash: Hash, tx: Transaction) {
        self.decrypted_transactions.insert(hash, tx);
    }

    pub fn store_tick(&mut self, tick_state: TickState) {
        self.tick_history
            .insert(tick_state.tick_number, tick_state.clone());
        self.last_finalized_tick = tick_state.tick_number;
    }
}

/// Persistent state storage
pub struct StateManager {
    db: Arc<KalaDatabase>,
    current_state: KalaState,
}

impl StateManager {
    pub async fn new(
        db_path: &str,
        chain_id: NodeId,
        witness_ids: Vec<NodeId>,
    ) -> KalaResult<Self> {
        let db = Arc::new(KalaDatabase::new(db_path)?);

        let current_state = match db.load_typed::<StorableState>("state", "current").await? {
            Some(stored) => stored.to_kala_state(),
            None => KalaState::genesis(chain_id, witness_ids),
        };

        Ok(Self { db, current_state })
    }

    pub async fn save_state(&self) -> KalaResult<()> {
        let storable = StorableState::from_kala_state(&self.current_state);
        self.db.store_typed("state", "current", &storable).await
    }
    pub fn get_state(&self) -> &KalaState {
        &self.current_state
    }

    pub fn get_state_mut(&mut self) -> &mut KalaState {
        &mut self.current_state
    }

    pub async fn export_state(&self) -> KalaResult<Vec<u8>> {
        let storable = StorableState::from_kala_state(&self.current_state);
        bincode::serialize(&storable)
            .map_err(|e| KalaError::Serialization(format!("Failed to serialize: {}", e)))
    }

    pub async fn import_state(&mut self, data: &[u8]) -> KalaResult<()> {
        let storable: StorableState = bincode::deserialize(data)
            .map_err(|e| KalaError::Deserialization(format!("Failed to deserialize: {}", e)))?;
        self.current_state = storable.to_kala_state();
        self.save_state().await
    }
}

/// Serializable version of KalaState
#[derive(Serialize, Deserialize)]
struct StorableState {
    chain_id: NodeId,
    witness_set: BTreeMap<NodeId, bool>,
    byzantine_threshold: usize,
    current_tick: TickNumber,
    current_iteration: IterationNumber,
    current_phase: TickPhase,
    vdf_discriminant_hex: String,
    vdf_current_form_a: String,
    vdf_current_form_b: String,
    vdf_current_form_c: String,
    accounts: BTreeMap<Bytes32, Account>,
    total_supply: BTreeMap<Bytes32, u64>,
}

impl StorableState {
    fn from_kala_state(state: &KalaState) -> Self {
        Self {
            chain_id: state.chain_id,
            witness_set: state.witness_set.clone(),
            byzantine_threshold: state.byzantine_threshold,
            current_tick: state.current_tick,
            current_iteration: state.current_iteration,
            current_phase: state.current_phase,
            vdf_discriminant_hex: state.vdf_discriminant.value.to_string_radix(16),
            vdf_current_form_a: state.vdf_current_form.a.to_string_radix(16),
            vdf_current_form_b: state.vdf_current_form.b.to_string_radix(16),
            vdf_current_form_c: state.vdf_current_form.c.to_string_radix(16),
            accounts: state.accounts.clone(),
            total_supply: state.total_supply.clone(),
        }
    }

    fn to_kala_state(&self) -> KalaState {
        use rug::Integer;

        let discriminant =
            Discriminant::from_hex(&self.vdf_discriminant_hex).expect("Valid discriminant");

        let form = QuadraticForm::new(
            Integer::from_str_radix(&self.vdf_current_form_a, 16).expect("Valid a"),
            Integer::from_str_radix(&self.vdf_current_form_b, 16).expect("Valid b"),
            Integer::from_str_radix(&self.vdf_current_form_c, 16).expect("Valid c"),
        );

        KalaState {
            chain_id: self.chain_id,
            witness_set: self.witness_set.clone(),
            byzantine_threshold: self.byzantine_threshold,
            current_tick: self.current_tick,
            current_iteration: self.current_iteration,
            current_phase: self.current_phase,
            vdf_discriminant: discriminant,
            vdf_current_form: form,
            vdf_proof_cache: BTreeMap::new(),
            accounts: self.accounts.clone(),
            total_supply: self.total_supply.clone(),
            pending_envelopes: Vec::new(),
            observations: BTreeMap::new(),
            decrypted_transactions: BTreeMap::new(),
            tick_history: BTreeMap::new(),
            last_finalized_tick: 0,
            total_transactions: 0,
            total_iterations: 0,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use kala_transaction::types::{Burn, Mint, Send, Solve, Stake, Unstake};
    use tempfile::tempdir;
    use tokio;
    // Helper function to create test witness IDs
    fn test_witness_ids() -> Vec<NodeId> {
        vec![[1u8; 32], [2u8; 32], [3u8; 32]]
    }

    // Helper function to create a test account
    fn create_test_account(address: Bytes32, balance: u64) -> Account {
        let mut balances = BTreeMap::new();
        balances.insert([0u8; 32], balance); // Native token
        Account {
            address,
            balances,
            stake: BTreeMap::new(),
            nonce: 0,
            puzzles_solved: Vec::new(),
        }
    }

    #[test]
    fn test_genesis_state() {
        let chain_id = [42u8; 32];
        let witness_ids = test_witness_ids();
        let state = KalaState::genesis(chain_id, witness_ids.clone());

        assert_eq!(state.chain_id, chain_id);
        assert_eq!(state.witness_set.len(), 3);
        assert_eq!(state.byzantine_threshold, 1); // 3 / 3 = 1
        assert_eq!(state.current_tick, 0);
        assert_eq!(state.current_iteration, 0);
        assert_eq!(state.current_phase, TickPhase::Collection);
        assert!(state.accounts.is_empty());
        assert!(state.total_supply.is_empty());
        assert_eq!(state.total_transactions, 0);
        assert_eq!(state.total_iterations, 0);

        // Verify all witnesses are active
        for id in witness_ids {
            assert_eq!(state.witness_set.get(&id), Some(&true));
        }
    }
    #[test]
    fn test_phase_calculation() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        // Collection phase (0 - 21844)
        state.current_iteration = 0;
        assert_eq!(state.get_current_phase(), TickPhase::Collection);

        state.current_iteration = 10000;
        assert_eq!(state.get_current_phase(), TickPhase::Collection);

        state.current_iteration = COLLECTION_PHASE_END - 1;
        assert_eq!(state.get_current_phase(), TickPhase::Collection);

        // Consensus phase (21845 - 43689)
        state.current_iteration = COLLECTION_PHASE_END;
        assert_eq!(state.get_current_phase(), TickPhase::Consensus);

        state.current_iteration = 30000;
        assert_eq!(state.get_current_phase(), TickPhase::Consensus);

        state.current_iteration = CONSENSUS_PHASE_END - 1;
        assert_eq!(state.get_current_phase(), TickPhase::Consensus);

        // Decryption phase
        state.current_iteration = CONSENSUS_PHASE_END + 1;
        assert_eq!(state.get_current_phase(), TickPhase::Decryption);

        // State update phase (last 1/6 of tick)
        state.current_iteration = K_ITERATIONS * 5 / 6;
        assert_eq!(state.get_current_phase(), TickPhase::StateUpdate);
    }

    #[test]
    fn test_apply_send_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let sender_addr = [1u8; 32];
        let receiver_addr = [2u8; 32];
        let denom = [0u8; 32];

        // Setup sender account
        state
            .accounts
            .insert(sender_addr, create_test_account(sender_addr, 1000));

        // Create send transaction
        let send = Send {
            sender: sender_addr,
            receiver: receiver_addr,
            denom,
            amount: 100,
            nonce: 0,
            signature: [0u8; 64], // Simplified for test
            gas_sponsorer: sender_addr,
        };

        // Apply transaction
        let result = state.apply_send(&send);
        assert!(result.is_ok());

        // Verify sender balance
        let sender = state.accounts.get(&sender_addr).unwrap();
        assert_eq!(*sender.balances.get(&denom).unwrap(), 900);
        assert_eq!(sender.nonce, 1);

        // Verify receiver balance
        let receiver = state.accounts.get(&receiver_addr).unwrap();
        assert_eq!(*receiver.balances.get(&denom).unwrap(), 100);

        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_send_insufficient_balance() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let sender_addr = [1u8; 32];
        let receiver_addr = [2u8; 32];
        let denom = [0u8; 32];

        // Setup sender with insufficient balance
        state
            .accounts
            .insert(sender_addr, create_test_account(sender_addr, 50));

        let send = Send {
            sender: sender_addr,
            receiver: receiver_addr,
            denom,
            amount: 100,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: sender_addr,
        };

        let result = state.apply_send(&send);
        assert!(result.is_err());
        assert_eq!(state.total_transactions, 0);
    }

    #[test]
    fn test_apply_send_invalid_nonce() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let sender_addr = [1u8; 32];
        let receiver_addr = [2u8; 32];
        let denom = [0u8; 32];

        state
            .accounts
            .insert(sender_addr, create_test_account(sender_addr, 1000));

        let send = Send {
            sender: sender_addr,
            receiver: receiver_addr,
            denom,
            amount: 100,
            nonce: 5, // Wrong nonce
            signature: [0u8; 64],
            gas_sponsorer: sender_addr,
        };

        let result = state.apply_send(&send);
        assert!(result.is_err());
    }

    #[test]
    fn test_apply_mint_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let minter_addr = [1u8; 32];
        let denom = [99u8; 32];

        let mint = Mint {
            sender: minter_addr,
            denom,
            amount: 1000,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: minter_addr,
        };

        let result = state.apply_mint(&mint);
        assert!(result.is_ok());

        // Verify account balance
        let account = state.accounts.get(&minter_addr).unwrap();
        assert_eq!(*account.balances.get(&denom).unwrap(), 1000);
        assert_eq!(account.nonce, 1);

        // Verify total supply
        assert_eq!(*state.total_supply.get(&denom).unwrap(), 1000);
        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_burn_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let burner_addr = [1u8; 32];
        let denom = [0u8; 32];

        // Setup account with tokens
        let mut account = create_test_account(burner_addr, 1000);
        state.accounts.insert(burner_addr, account);
        state.total_supply.insert(denom, 1000);

        let burn = Burn {
            sender: burner_addr,
            denom,
            amount: 300,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: burner_addr,
        };

        let result = state.apply_burn(&burn);
        assert!(result.is_ok());

        // Verify balance reduced
        let account = state.accounts.get(&burner_addr).unwrap();
        assert_eq!(*account.balances.get(&denom).unwrap(), 700);
        assert_eq!(account.nonce, 1);

        // Verify total supply reduced
        assert_eq!(*state.total_supply.get(&denom).unwrap(), 700);
        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_stake_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let delegator_addr = [1u8; 32];
        let witness_addr = [2u8; 32];
        let native_denom = [0u8; 32];

        // Setup delegator with balance
        state
            .accounts
            .insert(delegator_addr, create_test_account(delegator_addr, 1000));

        let stake = Stake {
            delegator: delegator_addr,
            witness: witness_addr,
            amount: 400,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: delegator_addr,
        };

        let result = state.apply_stake(&stake);
        assert!(result.is_ok());

        let account = state.accounts.get(&delegator_addr).unwrap();
        assert_eq!(*account.balances.get(&native_denom).unwrap(), 600);
        assert_eq!(*account.stake.get(&witness_addr).unwrap(), 400);
        assert_eq!(account.nonce, 1);
        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_unstake_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let delegator_addr = [1u8; 32];
        let witness_addr = [2u8; 32];
        let native_denom = [0u8; 32];

        // Setup delegator with staked tokens
        let mut account = create_test_account(delegator_addr, 600);
        account.stake.insert(witness_addr, 400);
        state.accounts.insert(delegator_addr, account);

        let unstake = Unstake {
            delegator: delegator_addr,
            witness: witness_addr,
            amount: 200,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: delegator_addr,
        };

        let result = state.apply_unstake(&unstake);
        assert!(result.is_ok());

        let account = state.accounts.get(&delegator_addr).unwrap();
        assert_eq!(*account.balances.get(&native_denom).unwrap(), 800);
        assert_eq!(*account.stake.get(&witness_addr).unwrap(), 200);
        assert_eq!(account.nonce, 1);
        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_unstake_full_amount() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let delegator_addr = [1u8; 32];
        let witness_addr = [2u8; 32];
        let native_denom = [0u8; 32];

        // Setup delegator with staked tokens
        let mut account = create_test_account(delegator_addr, 600);
        account.stake.insert(witness_addr, 400);
        state.accounts.insert(delegator_addr, account);

        let unstake = Unstake {
            delegator: delegator_addr,
            witness: witness_addr,
            amount: 400, // Full amount
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: delegator_addr,
        };

        let result = state.apply_unstake(&unstake);
        assert!(result.is_ok());

        let account = state.accounts.get(&delegator_addr).unwrap();
        assert_eq!(*account.balances.get(&native_denom).unwrap(), 1000);
        assert!(account.stake.get(&witness_addr).is_none()); // Entry removed
        assert_eq!(account.nonce, 1);
    }

    #[test]
    fn test_apply_solve_transaction() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let solver_addr = [1u8; 32];
        let puzzle_id = [99u8; 32];

        // Setup solver account
        state
            .accounts
            .insert(solver_addr, create_test_account(solver_addr, 0));

        let solve = Solve {
            sender: solver_addr,
            puzzle_id,
            proof: [0u8; 256],
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: solver_addr,
        };

        let result = state.apply_solve(&solve);
        assert!(result.is_ok());

        let account = state.accounts.get(&solver_addr).unwrap();
        assert!(account.puzzles_solved.contains(&puzzle_id));
        assert_eq!(account.nonce, 1);
        assert_eq!(state.total_transactions, 1);
    }

    #[test]
    fn test_apply_solve_duplicate_puzzle() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let solver_addr = [1u8; 32];
        let puzzle_id = [99u8; 32];

        // Setup solver account with puzzle already solved
        let mut account = create_test_account(solver_addr, 0);
        account.puzzles_solved.push(puzzle_id);
        state.accounts.insert(solver_addr, account);

        let solve = Solve {
            sender: solver_addr,
            puzzle_id,
            proof: [0u8; 256],
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: solver_addr,
        };

        let result = state.apply_solve(&solve);
        assert!(result.is_err());
        assert_eq!(state.total_transactions, 0);
    }

    #[test]
    fn test_compute_state_root() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        // Add some accounts
        state
            .accounts
            .insert([1u8; 32], create_test_account([1u8; 32], 1000));
        state
            .accounts
            .insert([2u8; 32], create_test_account([2u8; 32], 2000));
        state
            .accounts
            .insert([3u8; 32], create_test_account([3u8; 32], 3000));

        let root1 = state.compute_state_root().unwrap();

        // Root should be deterministic
        let root2 = state.compute_state_root().unwrap();
        assert_eq!(root1, root2);

        // Modify state
        state.accounts.get_mut(&[1u8; 32]).unwrap().nonce = 1;

        let root3 = state.compute_state_root().unwrap();
        assert_ne!(root1, root3);
    }
    #[test]
    fn test_verify_state_valid() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let denom = [0u8; 32];

        // Setup consistent state
        state
            .accounts
            .insert([1u8; 32], create_test_account([1u8; 32], 500));
        state
            .accounts
            .insert([2u8; 32], create_test_account([2u8; 32], 300));
        state.total_supply.insert(denom, 800);

        let result = state.verify_state();
        assert!(result.is_ok());
    }

    #[test]
    fn test_verify_state_invalid_supply() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        let denom = [0u8; 32];

        // Setup inconsistent state
        state
            .accounts
            .insert([1u8; 32], create_test_account([1u8; 32], 500));
        state
            .accounts
            .insert([2u8; 32], create_test_account([2u8; 32], 300));
        state.total_supply.insert(denom, 900); // Wrong total

        let result = state.verify_state();
        assert!(result.is_err());
    }

    #[test]
    fn test_verify_state_iteration_consistency() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        state.current_tick = 5;
        state.current_iteration = K_ITERATIONS * 5 + 100; // Correct
        assert!(state.verify_state().is_ok());

        state.current_iteration = K_ITERATIONS * 6; // Wrong
        assert!(state.verify_state().is_err());
    }

    #[tokio::test]
    async fn test_state_manager_new_genesis() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("test_db");
        let chain_id = [42u8; 32];
        let witness_ids = test_witness_ids();

        let manager = StateManager::new(db_path.to_str().unwrap(), chain_id, witness_ids.clone())
            .await
            .unwrap();

        assert_eq!(manager.current_state.chain_id, chain_id);
        assert_eq!(manager.current_state.witness_set.len(), 3);
        assert_eq!(manager.current_state.current_tick, 0);
    }

    #[tokio::test]
    async fn test_state_manager_persistence() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("test_db");
        let chain_id = [42u8; 32];
        let witness_ids = test_witness_ids();

        // Create and save state
        {
            let mut manager =
                StateManager::new(db_path.to_str().unwrap(), chain_id, witness_ids.clone())
                    .await
                    .unwrap();

            // Modify state
            manager.current_state.current_tick = 10;
            manager.current_state.current_iteration = K_ITERATIONS * 10;
            manager
                .current_state
                .accounts
                .insert([1u8; 32], create_test_account([1u8; 32], 5000));
            manager.current_state.total_supply.insert([0u8; 32], 5000);

            // Save state
            manager.save_state().await.unwrap();
        }

        // Load state in new manager
        {
            let manager = StateManager::new(db_path.to_str().unwrap(), chain_id, witness_ids)
                .await
                .unwrap();

            assert_eq!(manager.current_state.current_tick, 10);
            assert_eq!(manager.current_state.current_iteration, K_ITERATIONS * 10);
            assert_eq!(manager.current_state.accounts.len(), 1);
            assert_eq!(
                *manager.current_state.total_supply.get(&[0u8; 32]).unwrap(),
                5000
            );

            let account = manager.current_state.accounts.get(&[1u8; 32]).unwrap();
            assert_eq!(*account.balances.get(&[0u8; 32]).unwrap(), 5000);
        }
    }
    #[tokio::test]
    async fn test_state_manager_multiple_saves() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("test_db");
        let chain_id = [42u8; 32];
        let witness_ids = test_witness_ids();

        {
            // Create manager in its own scope
            let mut manager =
                StateManager::new(db_path.to_str().unwrap(), chain_id, witness_ids.clone())
                    .await
                    .unwrap();

            // First save
            manager.current_state.current_tick = 5;
            manager.save_state().await.unwrap();

            // Second save (should overwrite)
            manager.current_state.current_tick = 10;
            manager.save_state().await.unwrap();
        } // Manager drops here, releasing the database

        // Load and verify latest state in a new manager
        let new_manager = StateManager::new(db_path.to_str().unwrap(), chain_id, witness_ids)
            .await
            .unwrap();

        assert_eq!(new_manager.current_state.current_tick, 10);
    }

    #[test]
    fn test_storable_state_conversion() {
        let mut state = KalaState::genesis([42u8; 32], test_witness_ids());

        // Modify state
        state.current_tick = 100;
        state.current_iteration = K_ITERATIONS * 100;
        state.current_phase = TickPhase::Consensus;
        state
            .accounts
            .insert([1u8; 32], create_test_account([1u8; 32], 1000));
        state.total_supply.insert([0u8; 32], 1000);

        // Convert to storable
        let storable = StorableState::from_kala_state(&state);

        // Convert back
        let restored = storable.to_kala_state();

        // Verify fields match
        assert_eq!(restored.chain_id, state.chain_id);
        assert_eq!(restored.witness_set, state.witness_set);
        assert_eq!(restored.byzantine_threshold, state.byzantine_threshold);
        assert_eq!(restored.current_tick, state.current_tick);
        assert_eq!(restored.current_iteration, state.current_iteration);
        assert_eq!(restored.current_phase, state.current_phase);
        assert_eq!(restored.accounts, state.accounts);
        assert_eq!(restored.total_supply, state.total_supply);

        // VDF discriminant should match
        assert_eq!(
            restored.vdf_discriminant.value.to_string_radix(16),
            state.vdf_discriminant.value.to_string_radix(16)
        );
    }

    #[test]
    fn test_transaction_counter() {
        let mut state = KalaState::genesis([0u8; 32], test_witness_ids());

        // Setup accounts
        state
            .accounts
            .insert([1u8; 32], create_test_account([1u8; 32], 1000));
        state
            .accounts
            .insert([2u8; 32], create_test_account([2u8; 32], 0));

        assert_eq!(state.total_transactions, 0);

        // Apply multiple transactions
        let send = Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [0u8; 32],
            amount: 100,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: [1u8; 32],
        };
        state.apply_send(&send).unwrap();
        assert_eq!(state.total_transactions, 1);

        let mint = Mint {
            sender: [3u8; 32],
            denom: [99u8; 32],
            amount: 500,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: [3u8; 32],
        };
        state.apply_mint(&mint).unwrap();
        assert_eq!(state.total_transactions, 2);

        // Failed transaction shouldn't increment counter
        let invalid_send = Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [0u8; 32],
            amount: 10000, // Too much
            nonce: 1,
            signature: [0u8; 64],
            gas_sponsorer: [1u8; 32],
        };
        let _ = state.apply_send(&invalid_send);
        assert_eq!(state.total_transactions, 2); // Still 2
    }
}
