use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Account {
    pub balance: u64,
    pub nonce: u64,
    pub staked_amount: u64,
    pub delegation: Option<[u8; 32]>,
}

impl Account {
    pub fn new() -> Self {
        Self {
            balance: 0,
            nonce: 0,
            staked_amount: 0,
            delegation: None,
        }
    }
}

#[derive(Serialize, Deserialize, Clone)]
pub struct AccountState {
    pub address: [u8; 32],
    pub account: Account,
}
