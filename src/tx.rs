use crate::constants::{EMPTY32BYTES, EMPTY64BYTES, Sized32Bytes, Sized64Bytes};
use aes_gcm::aead::Payload;
use bincode::{self, config, config::Configuration};
use bincode::{Decode, Encode};
use ring::signature::{EcdsaKeyPair, Ed25519KeyPair, KeyPair};
use std::sync::Arc;
//TODO: should i add the nonce manually or calibrate automatically?
pub trait Signable {
    fn sign(&mut self, sender: &Ed25519KeyPair);
}

#[derive(Debug, Clone)]
pub struct Send {
    pub sender: Sized32Bytes,
    pub receiver: Sized32Bytes,
    pub denom: Sized32Bytes,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Sized64Bytes,
}

#[derive(Debug, Clone)]
pub struct Mint {
    pub sender: Sized32Bytes,
    pub amount: u64,
    pub denom: Sized32Bytes,
    pub nonce: u64,
    pub signature: Sized64Bytes,
}

#[derive(Debug, Clone)]
pub struct Solve {
    pub sender: Sized32Bytes,
    pub proof: Sized64Bytes,
    pub puzzle_id: Sized32Bytes,
    pub nonce: u64,
    pub signature: Sized64Bytes,
}

#[derive(Debug, Clone)]
pub struct Stake {
    pub sender: Sized32Bytes,
    pub delegation_receiver: Sized32Bytes,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Sized64Bytes,
}

#[derive(Debug, Clone)]
pub enum Transaction<SE = Send, MT = Mint, ST = Stake, SL = Solve> {
    Send(SE),
    Mint(MT),
    Stake(ST),
    Solve(SL),
}

impl Transaction {
    pub fn sign(&mut self, sender: &Ed25519KeyPair) {
        match self {
            Transaction::Send(tx) => tx.sign(sender),
            Transaction::Mint(tx) => tx.sign(sender),
            Transaction::Solve(tx) => tx.sign(sender),
            Transaction::Solve(tx) => tx.sign(sender),
        }
    }
}

impl Send {
    pub fn new(
        sender: &Ed25519KeyPair,
        receiver: Sized32Bytes,
        denom: Sized32Bytes,
        amount: u64,
        nonce: u64,
    ) -> Transaction {
        let sender: Sized32Bytes = sender
            .public_key()
            .as_ref()
            .try_into()
            .expect("Could not fetch the public key");
        let tx = Send {
            sender,
            receiver,
            denom,
            amount,
            signature: EMPTY64BYTES,
            nonce: nonce,
        };
        Transaction::Send(tx)
    }
}
impl Signable for Send {
    fn sign(&mut self, sender: &Ed25519KeyPair) {
        let payload = bincode::encode_to_vec(
            (
                &self.sender,
                &self.receiver,
                &self.denom,
                &self.amount,
                &self.nonce,
            ),
            config::standard(),
        )
        .expect("Unable to encode the payload");
        self.signature = sender
            .sign(&payload)
            .as_ref()
            .try_into()
            .expect("Failed to sign");
    }
}

impl Mint {
    pub fn new(
        sender: &Ed25519KeyPair,
        amount: u64,
        denom: Sized32Bytes,
        nonce: u64,
    ) -> Transaction {
        let sender = sender
            .public_key()
            .as_ref()
            .try_into()
            .expect("Could not fetch the senders public key");
        let tx = Mint {
            sender,
            amount,
            denom,
            nonce,
            signature: EMPTY64BYTES,
        };
        Transaction::Mint(tx)
    }
}

impl Signable for Mint {
    fn sign(&mut self, sender: &Ed25519KeyPair) {
        let payload = bincode::encode_to_vec(
            (&self.sender, &self.amount, &self.denom, &self.nonce),
            config::standard(),
        )
        .expect("Unable to encode the payload");
        self.signature = sender
            .sign(&payload)
            .as_ref()
            .try_into()
            .expect("Failed to sign the transaction");
    }
}

impl Stake {
    pub fn new(sender: &Ed25519KeyPair, delegation_receiver: Sized32Bytes, amount: u64, nonce: u64) -> Transaction{
        let sender = sender.public_key().as_ref().try_into().expect("Could not get the public key");

    }
}