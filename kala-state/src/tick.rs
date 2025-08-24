
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
#[derive(Serialize, Deserialize, Clone)]
pub struct TickCertificate {
    pub tick_number: u64,
    pub tick_type: TickType,
    pub vdf_iteration: u64,
    pub vdf_form: (String, String, String), // (a, b, c)
    pub hash_chain_value: [u8; 32],
    pub tick_hash: [u8; 32],
    pub transaction_count: u32,
    pub transaction_merkle_root: [u8; 32],
    pub timestamp: u64,
    pub previous_tick_hash: [u8; 32],
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum TickType {
    Full,       // Contains validated transactions with consensus
    Empty,      // Consensus achieved but no transactions included
    Checkpoint, // No consensus - only VDF proof preserved
}

impl TickCertificate {
    pub fn compute_hash(&self) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(&self.tick_number.to_le_bytes());
        hasher.update(&self.vdf_iteration.to_le_bytes());
        hasher.update(self.vdf_form.0.as_bytes());
        hasher.update(self.vdf_form.1.as_bytes());
        hasher.update(self.vdf_form.2.as_bytes());
        hasher.update(&self.hash_chain_value);
        hasher.update(&self.transaction_merkle_root);
        hasher.finalize().into()
    }
}
