//! – Uses tx_generated.rs produced from `schema/tx.fbs` (vector<u8> fields).  
//! – Signs the canonical FlatBuffers bytes (signature field zeroed).  

use crate::constants::{EMPTY64BYTES, Sized32Bytes, Sized64Bytes};
use crate::kalav1::tx_generated::tx::{
    Bytes32, Bytes64, Bytes256, MintTx, MintTxArgs, SendTx, SendTxArgs, SolveTx, SolveTxArgs,
    StakeTx, StakeTxArgs, Transaction as TransactionFb, TransactionArgs, TxBody,
};

use flatbuffers::FlatBufferBuilder;
use ring::signature::{Ed25519KeyPair, KeyPair};

// ---------------------------------------------------------------------------
// Trait that every variant implements
// ---------------------------------------------------------------------------
pub trait Signable {
    fn sign(&mut self, signer: &Ed25519KeyPair);
}

// ---------------------------------------------------------------------------
// Concrete variant structs
// ---------------------------------------------------------------------------
#[derive(Debug, Clone)]
pub struct Send {
    pub sender: Bytes32,
    pub receiver: Bytes32,
    pub denom: Bytes32,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Bytes64,
}

#[derive(Debug, Clone)]
pub struct Mint {
    pub sender: Bytes32,
    pub amount: u64,
    pub denom: Bytes32,
    pub nonce: u64,
    pub signature: Bytes64,
}

#[derive(Debug, Clone)]
pub struct Stake {
    pub sender: Bytes32,
    pub delegation_receiver: Bytes32,
    pub amount: u64,
    pub nonce: u64,
    pub signature: Bytes64,
}

#[derive(Debug, Clone)]
pub struct Solve {
    pub sender: Bytes32,
    pub proof: Bytes256,
    pub puzzle_id: Bytes32,
    pub nonce: u64,
    pub signature: Bytes64,
}

// ---------------------------------------------------------------------------
// Enum wrapper (mirrors FlatBuffers union)
// ---------------------------------------------------------------------------
#[derive(Debug, Clone)]
pub enum Transaction {
    Send(Send),
    Mint(Mint),
    Stake(Stake),
    Solve(Solve),
}

// ---------------------------------------------------------------------------
// FlatBuffers encode / decode
// ---------------------------------------------------------------------------
impl Transaction {
    /// Serialise the transaction into its canonical FlatBuffers byte slice.
    pub fn to_flatbuf(&self) -> Vec<u8> {
        let mut fbb = FlatBufferBuilder::new();
        let (body_type, body_val) = match self {
            Transaction::Send(t) => {
                let off = SendTx::create(
                    &mut fbb,
                    &SendTxArgs {
                        sender: Some(&t.sender),
                        receiver: Some(&t.receiver),
                        denom: Some(&t.denom),
                        amount: t.amount,
                        nonce: t.nonce,
                        signature: Some(&t.signature),
                    },
                );
                (TxBody::SendTx, off.as_union_value())
            }
            Transaction::Mint(t) => {
                let off = MintTx::create(
                    &mut fbb,
                    &MintTxArgs {
                        sender: Some(&t.sender),
                        amount: t.amount,
                        denom: Some(&t.denom),
                        nonce: t.nonce,
                        signature: Some(&t.signature),
                    },
                );
                (TxBody::MintTx, off.as_union_value())
            }
            Transaction::Stake(t) => {
                let off = StakeTx::create(
                    &mut fbb,
                    &StakeTxArgs {
                        sender: Some(&t.sender),
                        delegation_receiver: Some(&t.delegation_receiver),
                        amount: t.amount,
                        nonce: t.nonce,
                        signature: Some(&t.signature),
                    },
                );
                (TxBody::StakeTx, off.as_union_value())
            }
            Transaction::Solve(t) => {
                let off = SolveTx::create(
                    &mut fbb,
                    &SolveTxArgs {
                        sender: Some(&t.sender),
                        proof: Some(&t.proof),
                        puzzle_id: Some(&t.puzzle_id),
                        nonce: t.nonce,
                        signature: Some(&t.signature),
                    },
                );
                (TxBody::SolveTx, off.as_union_value())
            }
        };

        let root = TransactionFb::create(
            &mut fbb,
            &TransactionArgs {
                body_type,
                body: Some(body_val),
            },
        );
        fbb.finish(root, None);
        fbb.finished_data().to_vec()
    }

    /// Deserialize a FlatBuffers payload back into `Transaction` (length‑checks included).
    pub fn from_flatbuf(bytes: &[u8]) -> Option<Self> {
        let tx = crate::kalav1::tx_generated::tx::root_as_transaction(bytes).ok()?;
        match tx.body_type() {
            TxBody::SendTx => {
                let st = tx.body_as_send_tx()?;
                Some(Transaction::Send(Send {
                    sender: *st.sender()?,
                    receiver: *st.receiver()?,
                    denom: *st.denom()?,
                    amount: st.amount(),
                    nonce: st.nonce(),
                    signature: *st.signature()?,
                }))
            }
            TxBody::MintTx => {
                let mt = tx.body_as_mint_tx()?;
                Some(Transaction::Mint(Mint {
                    sender: *mt.sender()?,
                    amount: mt.amount(),
                    denom: *mt.denom()?,
                    nonce: mt.nonce(),
                    signature: *mt.signature()?,
                }))
            }
            TxBody::StakeTx => {
                let st = tx.body_as_stake_tx()?;
                Some(Transaction::Stake(Stake {
                    sender: *st.sender()?,
                    delegation_receiver: *st.delegation_receiver()?,
                    amount: st.amount(),
                    nonce: st.nonce(),
                    signature: *st.signature()?,
                }))
            }
            TxBody::SolveTx => {
                let sv = tx.body_as_solve_tx()?;
                Some(Transaction::Solve(Solve {
                    sender: *sv.sender()?,
                    proof: *sv.proof()?,
                    puzzle_id: *sv.puzzle_id()?,
                    nonce: sv.nonce(),
                    signature: *sv.signature()?,
                }))
            }
            _ => None,
        }
    }
}

// ---------------------------------------------------------------------------
// Constructors + Sign impls (now signing FlatBuffers payloads)
// ---------------------------------------------------------------------------
impl Send {
    pub fn new(
        kp: &Ed25519KeyPair,
        receiver: Bytes32,
        denom: Bytes32,
        amount: u64,
        nonce: u64,
    ) -> Transaction {
        let key: Sized32Bytes = kp.public_key().as_ref().try_into().unwrap();
        Transaction::Send(Send {
            sender: Bytes32(key),
            receiver,
            denom,
            amount,
            nonce,
            signature: Bytes64(EMPTY64BYTES),
        })
    }
}

impl Signable for Send {
    fn sign(&mut self, kp: &Ed25519KeyPair) {
        let mut tmp = self.clone();
        tmp.signature = Bytes64(EMPTY64BYTES); // zero before hashing
        let payload = Transaction::Send(tmp).to_flatbuf();
        let signature_bytes: Sized64Bytes = kp.sign(&payload).as_ref().try_into().unwrap();
        self.signature = Bytes64(signature_bytes);
    }
}

impl Mint {
    pub fn new(kp: &Ed25519KeyPair, amount: u64, denom: Bytes32, nonce: u64) -> Transaction {
        let key: Sized32Bytes = kp.public_key().as_ref().try_into().unwrap();

        Transaction::Mint(Mint {
            sender: Bytes32(key),
            amount,
            denom,
            nonce,
            signature: Bytes64(EMPTY64BYTES),
        })
    }
}

impl Signable for Mint {
    fn sign(&mut self, kp: &Ed25519KeyPair) {
        let mut tmp = self.clone();
        tmp.signature = Bytes64(EMPTY64BYTES);
        let payload = Transaction::Mint(tmp).to_flatbuf();
        let signature_bytes: Sized64Bytes = kp.sign(&payload).as_ref().try_into().unwrap();
        self.signature = Bytes64(signature_bytes);
    }
}

impl Stake {
    pub fn new(
        kp: &Ed25519KeyPair,
        delegation_receiver: Bytes32,
        amount: u64,
        nonce: u64,
    ) -> Transaction {
        let key: Sized32Bytes = kp.public_key().as_ref().try_into().unwrap();
        Transaction::Stake(Stake {
            sender: Bytes32(key),
            delegation_receiver,
            amount,
            nonce,
            signature: Bytes64(EMPTY64BYTES),
        })
    }
}

impl Signable for Stake {
    fn sign(&mut self, kp: &Ed25519KeyPair) {
        let mut tmp = self.clone();
        tmp.signature = Bytes64(EMPTY64BYTES);
        let payload = Transaction::Stake(tmp).to_flatbuf();
        let signature_bytes: Sized64Bytes = kp.sign(&payload).as_ref().try_into().unwrap();
        self.signature = Bytes64(signature_bytes);
    }
}

impl Solve {
    pub fn new(
        kp: &Ed25519KeyPair,
        proof: Bytes256,
        puzzle_id: Bytes32,
        nonce: u64,
    ) -> Transaction {
        let key: Sized32Bytes = kp.public_key().as_ref().try_into().unwrap();

        Transaction::Solve(Solve {
            sender: Bytes32(key),
            proof,
            puzzle_id,
            nonce,
            signature: Bytes64(EMPTY64BYTES),
        })
    }
}

impl Signable for Solve {
    fn sign(&mut self, kp: &Ed25519KeyPair) {
        let mut tmp = self.clone();
        tmp.signature = Bytes64(EMPTY64BYTES);
        let payload = Transaction::Solve(tmp).to_flatbuf();
        let signature_bytes: Sized64Bytes = kp.sign(&payload).as_ref().try_into().unwrap();
        self.signature = Bytes64(signature_bytes);
    }
}

// ---------------------------------------------------------------------------
// Blanket impl so `Transaction` itself is Signable via enum dispatch
// ---------------------------------------------------------------------------
impl Signable for Transaction {
    fn sign(&mut self, kp: &Ed25519KeyPair) {
        match self {
            Transaction::Send(t) => t.sign(kp),
            Transaction::Mint(t) => t.sign(kp),
            Transaction::Stake(t) => t.sign(kp),
            Transaction::Solve(t) => t.sign(kp),
        }
    }
}#[cfg(test)]
mod tests {
    use super::*;
    use ring::rand::SystemRandom;
    use ring::signature::{Ed25519KeyPair, KeyPair};

    /* ---------- helper macros & creators -------------------------- */

    macro_rules! b32  { ($byte:expr) => { Bytes32([$byte; 32]) }; }
    macro_rules! b64  { ($byte:expr) => { Bytes64([$byte; 64]) }; }
    macro_rules! b256 { ($byte:expr) => { Bytes256([$byte; 256]) }; }

    fn keypair() -> Ed25519KeyPair {
        let rng = SystemRandom::new();
        let pkcs8 = Ed25519KeyPair::generate_pkcs8(&rng).unwrap();
        Ed25519KeyPair::from_pkcs8(pkcs8.as_ref()).unwrap()
    }

    /* ---------- SEND --------------------------------------------- */

    #[test]
    fn send_create_sign_roundtrip() {
        let kp = keypair();
        let mut tx = Send::new(&kp, b32!(1), b32!(2), 123, 1);

        // sender pub-key check
        let pk_array: [u8; 32] = kp.public_key().as_ref().try_into().unwrap();
        match &tx {
            Transaction::Send(s) => {
                assert_eq!(s.sender.0, pk_array);
                assert_eq!(s.signature.0, EMPTY64BYTES);
            }
            _ => panic!(),
        }

        // sign & verify signature changes
        tx.sign(&kp);
        match &tx {
            Transaction::Send(s) => {
                assert_ne!(s.signature.0, EMPTY64BYTES);
                assert_eq!(s.signature.0.len(), 64);
            }
            _ => panic!(),
        }

        // FlatBuffers round-trip
        let buf   = tx.to_flatbuf();
        let back  = Transaction::from_flatbuf(&buf).unwrap();
        match (tx, back) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.sender.0, b.sender.0);
                assert_eq!(a.signature.0, b.signature.0);
            }
            _ => panic!(),
        }
    }

    /* ---------- MINT --------------------------------------------- */

    #[test]
    fn mint_roundtrip() {
        let kp = keypair();
        let mut tx = Mint::new(&kp, 9_999, b32!(3), 2);
        tx.sign(&kp);

        let buf  = tx.to_flatbuf();
        let back = Transaction::from_flatbuf(&buf).unwrap();

        match (tx, back) {
            (Transaction::Mint(a), Transaction::Mint(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.signature.0, b.signature.0);
            }
            _ => panic!(),
        }
    }

    /* ---------- STAKE -------------------------------------------- */

    #[test]
    fn stake_sig_diff_on_amount() {
        let kp = keypair();
        let mut tx1 = Stake::new(&kp, b32!(4), 1_000, 1);
        let mut tx2 = Stake::new(&kp, b32!(4), 2_000, 1);
        tx1.sign(&kp);
        tx2.sign(&kp);

        match (tx1, tx2) {
            (Transaction::Stake(a), Transaction::Stake(b)) => {
                assert_ne!(a.signature.0, b.signature.0);
            }
            _ => panic!(),
        }
    }

    /* ---------- SOLVE -------------------------------------------- */

    #[test]
    fn solve_roundtrip() {
        let kp = keypair();
        let mut tx = Solve::new(&kp, b256!(5), b32!(6), 3);
        tx.sign(&kp);

        let buf  = tx.to_flatbuf();
        let back = Transaction::from_flatbuf(&buf).unwrap();

        match (tx, back) {
            (Transaction::Solve(a), Transaction::Solve(b)) => {
                assert_eq!(a.proof.0, b.proof.0);
                assert_eq!(a.signature.0, b.signature.0);
            }
            _ => panic!(),
        }
    }

    /* ---------- ENUM DISPATCH LOOP ------------------------------- */

    #[test]
    fn sign_and_roundtrip_all_variants() {
        let kp = keypair();
        let mut cases = vec![
            Send::new(&kp, b32!(10), b32!(11), 1, 1),
            Mint::new(&kp, 2, b32!(12), 2),
            Stake::new(&kp, b32!(13), 3, 3),
            Solve::new(&kp, b256!(14), b32!(15), 4),
        ];

        for tx in cases.iter_mut() {
            tx.sign(&kp);
            let buf   = tx.to_flatbuf();
            let back  = Transaction::from_flatbuf(&buf).unwrap();

            // Compare by FlatBuffers bytes equivalence
            assert_eq!(buf, back.to_flatbuf());
        }
    }
}
