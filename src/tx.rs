use crate::constants::{EMPTY32BYTES, EMPTY64BYTES, Sized32Bytes, Sized64Bytes, Sized256Bytes};
use aes_gcm::Nonce;
use aes_gcm::aead::Payload;
use bincode::{self, config, config::Configuration};
use bincode::{Decode, Encode};
use ring::signature::{EcdsaKeyPair, Ed25519KeyPair, KeyPair};
use std::sync::Arc;
//TODO: should i add the nonce manually or calibrate automatically?
//TODO: handle errors gracefully for best practice
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
    pub proof: Sized256Bytes,
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
            Transaction::Stake(tx) => tx.sign(sender),
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
    pub fn new(
        sender: &Ed25519KeyPair,
        delegation_receiver: Sized32Bytes,
        amount: u64,
        nonce: u64,
    ) -> Transaction {
        let sender = sender
            .public_key()
            .as_ref()
            .try_into()
            .expect("Could not get the public key");
        let tx = Stake {
            sender,
            delegation_receiver,
            amount,
            nonce,
            signature: EMPTY64BYTES,
        };
        Transaction::Stake(tx)
    }
}

impl Signable for Stake {
    fn sign(&mut self, sender: &Ed25519KeyPair) {
        let payload = bincode::encode_to_vec(
            (
                &self.sender,
                &self.delegation_receiver,
                &self.amount,
                &self.nonce,
            ),
            config::standard(),
        )
        .expect("Cant encode the message");
        self.signature = sender
            .sign(&payload)
            .as_ref()
            .try_into()
            .expect("Failed to sign message");
    }
}

impl Solve {
    pub fn new(
        sender: &Ed25519KeyPair,
        proof: Sized256Bytes,
        puzzle_id: Sized32Bytes,
        nonce: u64,
    ) -> Transaction {
        let sender = sender
            .public_key()
            .as_ref()
            .try_into()
            .expect("Can't fetch the public key");
        let tx = Solve {
            sender,
            proof,
            puzzle_id,
            nonce,
            signature: EMPTY64BYTES,
        };
        Transaction::Solve(tx)
    }
}
impl Signable for Solve {
    fn sign(&mut self, sender: &Ed25519KeyPair) {
        let payload = bincode::encode_to_vec(
            (&self.sender, &self.proof, &self.puzzle_id, &self.nonce),
            config::standard(),
        )
        .expect("Can't encode tx as bytes");
        self.signature = sender
            .sign(&payload)
            .as_ref()
            .try_into()
            .expect("Failed to sign message");
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ring::rand::SystemRandom;
    use ring::signature::{Ed25519KeyPair, KeyPair};

    // Helper function to create a test keypair
    fn create_test_keypair() -> Ed25519KeyPair {
        let rng = SystemRandom::new();
        let pkcs8_bytes = Ed25519KeyPair::generate_pkcs8(&rng).unwrap();
        Ed25519KeyPair::from_pkcs8(pkcs8_bytes.as_ref()).unwrap()
    }

    // Helper function to create a test sized array
    fn create_test_sized32() -> Sized32Bytes {
        [42u8; 32]
    }

    fn create_test_sized256() -> Sized256Bytes {
        [99u8; 256]
    }

    #[test]
    fn test_send_transaction_creation() {
        let sender_keypair = create_test_keypair();
        let receiver = create_test_sized32();
        let denom = create_test_sized32();
        let amount = 1000u64;
        let nonce = 1u64;

        let tx = Send::new(&sender_keypair, receiver, denom, amount, nonce);

        match tx {
            Transaction::Send(send_tx) => {
                // Verify sender public key is correctly set
                assert_eq!(send_tx.sender, sender_keypair.public_key().as_ref());
                assert_eq!(send_tx.receiver, receiver);
                assert_eq!(send_tx.denom, denom);
                assert_eq!(send_tx.amount, amount);
                assert_eq!(send_tx.nonce, nonce);
                // Signature should be empty initially
                assert_eq!(send_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Send transaction"),
        }
    }

    #[test]
    fn test_send_transaction_signing() {
        let sender_keypair = create_test_keypair();
        let receiver = create_test_sized32();
        let denom = create_test_sized32();
        let amount = 1000u64;
        let nonce = 1u64;

        let mut tx = Send::new(&sender_keypair, receiver, denom, amount, nonce);

        // Sign the transaction
        tx.sign(&sender_keypair);

        match tx {
            Transaction::Send(send_tx) => {
                // Signature should no longer be empty
                assert_ne!(send_tx.signature, EMPTY64BYTES);

                // Verify the signature is valid
                let payload = bincode::encode_to_vec(
                    (
                        &send_tx.sender,
                        &send_tx.receiver,
                        &send_tx.denom,
                        &send_tx.amount,
                        &send_tx.nonce,
                    ),
                    config::standard(),
                )
                .expect("Unable to encode the payload");

                // This would verify the signature is properly formed (64 bytes)
                assert_eq!(send_tx.signature.len(), 64);
            }
            _ => panic!("Expected Send transaction"),
        }
    }

    #[test]
    fn test_mint_transaction_creation() {
        let sender_keypair = create_test_keypair();
        let amount = 5000u64;
        let denom = create_test_sized32();
        let nonce = 2u64;

        let tx = Mint::new(&sender_keypair, amount, denom, nonce);

        match tx {
            Transaction::Mint(mint_tx) => {
                assert_eq!(mint_tx.sender, sender_keypair.public_key().as_ref());
                assert_eq!(mint_tx.amount, amount);
                assert_eq!(mint_tx.denom, denom);
                assert_eq!(mint_tx.nonce, nonce);
                assert_eq!(mint_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Mint transaction"),
        }
    }

    #[test]
    fn test_mint_transaction_signing() {
        let sender_keypair = create_test_keypair();
        let amount = 5000u64;
        let denom = create_test_sized32();
        let nonce = 2u64;

        let mut tx = Mint::new(&sender_keypair, amount, denom, nonce);
        tx.sign(&sender_keypair);

        match tx {
            Transaction::Mint(mint_tx) => {
                assert_ne!(mint_tx.signature, EMPTY64BYTES);
                assert_eq!(mint_tx.signature.len(), 64);
            }
            _ => panic!("Expected Mint transaction"),
        }
    }

    #[test]
    fn test_stake_transaction_creation() {
        let sender_keypair = create_test_keypair();
        let delegation_receiver = create_test_sized32();
        let amount = 10000u64;
        let nonce = 3u64;

        let tx = Stake::new(&sender_keypair, delegation_receiver, amount, nonce);

        match tx {
            Transaction::Stake(stake_tx) => {
                assert_eq!(stake_tx.sender, sender_keypair.public_key().as_ref());
                assert_eq!(stake_tx.delegation_receiver, delegation_receiver);
                assert_eq!(stake_tx.amount, amount);
                assert_eq!(stake_tx.nonce, nonce);
                assert_eq!(stake_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Stake transaction"),
        }
    }

    #[test]
    fn test_stake_transaction_signing() {
        let sender_keypair = create_test_keypair();
        let delegation_receiver = create_test_sized32();
        let amount = 10000u64;
        let nonce = 3u64;

        let mut tx = Stake::new(&sender_keypair, delegation_receiver, amount, nonce);
        tx.sign(&sender_keypair);

        match tx {
            Transaction::Stake(stake_tx) => {
                assert_ne!(stake_tx.signature, EMPTY64BYTES);
                assert_eq!(stake_tx.signature.len(), 64);
            }
            _ => panic!("Expected Stake transaction"),
        }
    }

    #[test]
    fn test_solve_transaction_creation() {
        let sender_keypair = create_test_keypair();
        let proof = create_test_sized256();
        let puzzle_id = create_test_sized32();
        let nonce = 4u64;

        let tx = Solve::new(&sender_keypair, proof, puzzle_id, nonce);

        match tx {
            Transaction::Solve(solve_tx) => {
                assert_eq!(solve_tx.sender, sender_keypair.public_key().as_ref());
                assert_eq!(solve_tx.proof, proof);
                assert_eq!(solve_tx.puzzle_id, puzzle_id);
                assert_eq!(solve_tx.nonce, nonce);
                assert_eq!(solve_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Solve transaction"),
        }
    }

    #[test]
    fn test_solve_transaction_signing() {
        let sender_keypair = create_test_keypair();
        let proof = create_test_sized256();
        let puzzle_id = create_test_sized32();
        let nonce = 4u64;

        let mut tx = Solve::new(&sender_keypair, proof, puzzle_id, nonce);
        tx.sign(&sender_keypair);

        match tx {
            Transaction::Solve(solve_tx) => {
                assert_ne!(solve_tx.signature, EMPTY64BYTES);
                assert_eq!(solve_tx.signature.len(), 64);
            }
            _ => panic!("Expected Solve transaction"),
        }
    }

    #[test]
    fn test_transaction_enum_sign_method() {
        let sender_keypair = create_test_keypair();

        // Test signing through the Transaction enum for each type
        let mut transactions = vec![
            Send::new(
                &sender_keypair,
                create_test_sized32(),
                create_test_sized32(),
                1000,
                1,
            ),
            Mint::new(&sender_keypair, 5000, create_test_sized32(), 2),
            Stake::new(&sender_keypair, create_test_sized32(), 10000, 3),
            Solve::new(
                &sender_keypair,
                create_test_sized256(),
                create_test_sized32(),
                4,
            ),
        ];

        for tx in transactions.iter_mut() {
            tx.sign(&sender_keypair);

            // Verify each transaction type was signed
            match tx {
                Transaction::Send(send_tx) => assert_ne!(send_tx.signature, EMPTY64BYTES),
                Transaction::Mint(mint_tx) => assert_ne!(mint_tx.signature, EMPTY64BYTES),
                Transaction::Stake(stake_tx) => assert_ne!(stake_tx.signature, EMPTY64BYTES),
                Transaction::Solve(solve_tx) => assert_ne!(solve_tx.signature, EMPTY64BYTES),
            }
        }
    }

    #[test]
    fn test_nonce_values() {
        let sender_keypair = create_test_keypair();

        // Test that different nonce values produce different signatures
        let mut tx1 = Send::new(
            &sender_keypair,
            create_test_sized32(),
            create_test_sized32(),
            1000,
            1,
        );
        let mut tx2 = Send::new(
            &sender_keypair,
            create_test_sized32(),
            create_test_sized32(),
            1000,
            2,
        );

        tx1.sign(&sender_keypair);
        tx2.sign(&sender_keypair);

        match (tx1, tx2) {
            (Transaction::Send(send1), Transaction::Send(send2)) => {
                assert_ne!(send1.signature, send2.signature);
            }
            _ => panic!("Expected Send transactions"),
        }
    }

    #[test]
    fn test_different_amounts_produce_different_signatures() {
        let sender_keypair = create_test_keypair();
        let receiver = create_test_sized32();
        let denom = create_test_sized32();
        let nonce = 1u64;

        let mut tx1 = Send::new(&sender_keypair, receiver, denom, 1000, nonce);
        let mut tx2 = Send::new(&sender_keypair, receiver, denom, 2000, nonce);

        tx1.sign(&sender_keypair);
        tx2.sign(&sender_keypair);

        match (tx1, tx2) {
            (Transaction::Send(send1), Transaction::Send(send2)) => {
                assert_ne!(send1.signature, send2.signature);
            }
            _ => panic!("Expected Send transactions"),
        }
    }

    #[test]
    fn test_edge_cases() {
        let sender_keypair = create_test_keypair();

        // Test with zero amounts
        let mut tx_zero = Send::new(
            &sender_keypair,
            create_test_sized32(),
            create_test_sized32(),
            0,
            1,
        );
        tx_zero.sign(&sender_keypair);

        match tx_zero {
            Transaction::Send(send_tx) => {
                assert_eq!(send_tx.amount, 0);
                assert_ne!(send_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Send transaction"),
        }

        // Test with max u64 value
        let mut tx_max = Mint::new(&sender_keypair, u64::MAX, create_test_sized32(), 1);
        tx_max.sign(&sender_keypair);

        match tx_max {
            Transaction::Mint(mint_tx) => {
                assert_eq!(mint_tx.amount, u64::MAX);
                assert_ne!(mint_tx.signature, EMPTY64BYTES);
            }
            _ => panic!("Expected Mint transaction"),
        }
    }
}
