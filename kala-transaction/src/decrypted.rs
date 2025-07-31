// decrypted.rs
use crate::generated::tx::{
    self, MintTx, MintTxArgs, SendTx, SendTxArgs, SolveTx, SolveTxArgs, StakeTx, StakeTxArgs,
    Transaction as TransactionFb, TransactionArgs, TxBody,
};
use crate::types::{Mint, Result, Send, Solve, Stake, Transaction, TransactionError};
use flatbuffers::FlatBufferBuilder;

/// Convert Rust transaction to FlatBuffer format
pub fn transaction_to_flatbuffer(tx: &Transaction) -> Result<Vec<u8>> {
    let mut fbb = FlatBufferBuilder::new();

    let (body_type, body_val) = match tx {
        Transaction::Send(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let receiver_vec = fbb.create_vector(&t.receiver);
            let denom_vec = fbb.create_vector(&t.denom);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = SendTx::create(
                &mut fbb,
                &SendTxArgs {
                    sender: Some(sender_vec),
                    receiver: Some(receiver_vec),
                    denom: Some(denom_vec),
                    amount: t.amount,
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::SendTx, off.as_union_value())
        }
        Transaction::Mint(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let denom_vec = fbb.create_vector(&t.denom);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = MintTx::create(
                &mut fbb,
                &MintTxArgs {
                    sender: Some(sender_vec),
                    amount: t.amount,
                    denom: Some(denom_vec),
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::MintTx, off.as_union_value())
        }
        Transaction::Stake(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let delegation_receiver_vec = fbb.create_vector(&t.delegation_receiver);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = StakeTx::create(
                &mut fbb,
                &StakeTxArgs {
                    sender: Some(sender_vec),
                    delegation_receiver: Some(delegation_receiver_vec),
                    amount: t.amount,
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::StakeTx, off.as_union_value())
        }
        Transaction::Solve(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let proof_vec = fbb.create_vector(&t.proof); // Already a Vec<u8>
            let puzzle_id_vec = fbb.create_vector(&t.puzzle_id);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = SolveTx::create(
                &mut fbb,
                &SolveTxArgs {
                    sender: Some(sender_vec),
                    proof: Some(proof_vec),
                    puzzle_id: Some(puzzle_id_vec),
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
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
    Ok(fbb.finished_data().to_vec())
}

/// Helper function to convert a FlatBuffer vector to a fixed-size array
fn vec_to_array<const N: usize>(vec: flatbuffers::Vector<u8>) -> Result<[u8; N]> {
    let bytes = vec.bytes();
    if bytes.len() != N {
        return Err(TransactionError::InvalidSize {
            expected: N,
            actual: bytes.len(),
        });
    }
    let mut array = [0u8; N];
    array.copy_from_slice(bytes);
    Ok(array)
}

/// Helper function to convert FlatBuffer vector to Vec<u8> with size validation
fn vec_to_vec(vec: flatbuffers::Vector<u8>, expected_size: Option<usize>) -> Result<Vec<u8>> {
    let bytes = vec.bytes().to_vec();
    if let Some(expected) = expected_size {
        if bytes.len() != expected {
            return Err(TransactionError::InvalidSize {
                expected,
                actual: bytes.len(),
            });
        }
    }
    Ok(bytes)
}

/// Convert FlatBuffer to Rust transaction
pub fn flatbuffer_to_transaction(bytes: &[u8]) -> Result<Transaction> {
    let tx = tx::root_as_transaction(bytes)
        .map_err(|e| TransactionError::FlatbufferError(format!("Failed to parse: {e}")))?;

    let transaction = match tx.body_type() {
        TxBody::SendTx => {
            let st = tx
                .body_as_send_tx()
                .ok_or_else(|| TransactionError::InvalidFormat("Invalid SendTx".to_string()))?;

            Transaction::Send(Send {
                sender: vec_to_array::<32>(st.sender().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing sender".to_string())
                })?)?,
                receiver: vec_to_array::<32>(st.receiver().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing receiver".to_string())
                })?)?,
                denom: vec_to_array::<32>(st.denom().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing denom".to_string())
                })?)?,
                amount: st.amount(),
                nonce: st.nonce(),
                signature: vec_to_vec(
                    st.signature().ok_or_else(|| {
                        TransactionError::InvalidFormat("Missing signature".to_string())
                    })?,
                    Some(64),
                )?,
                gas_sponsorer: vec_to_array::<32>(st.gas_sponsorer().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing gas_sponsorer".to_string())
                })?)?,
            })
        }
        TxBody::MintTx => {
            let mt = tx
                .body_as_mint_tx()
                .ok_or_else(|| TransactionError::InvalidFormat("Invalid MintTx".to_string()))?;

            Transaction::Mint(Mint {
                sender: vec_to_array::<32>(mt.sender().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing sender".to_string())
                })?)?,
                amount: mt.amount(),
                denom: vec_to_array::<32>(mt.denom().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing denom".to_string())
                })?)?,
                nonce: mt.nonce(),
                signature: vec_to_vec(
                    mt.signature().ok_or_else(|| {
                        TransactionError::InvalidFormat("Missing signature".to_string())
                    })?,
                    Some(64),
                )?,
                gas_sponsorer: vec_to_array::<32>(mt.gas_sponsorer().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing gas_sponsorer".to_string())
                })?)?,
            })
        }
        TxBody::StakeTx => {
            let st = tx
                .body_as_stake_tx()
                .ok_or_else(|| TransactionError::InvalidFormat("Invalid StakeTx".to_string()))?;

            Transaction::Stake(Stake {
                sender: vec_to_array::<32>(st.sender().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing sender".to_string())
                })?)?,
                delegation_receiver: vec_to_array::<32>(st.delegation_receiver().ok_or_else(
                    || TransactionError::InvalidFormat("Missing delegation_receiver".to_string()),
                )?)?,
                amount: st.amount(),
                nonce: st.nonce(),
                signature: vec_to_vec(
                    st.signature().ok_or_else(|| {
                        TransactionError::InvalidFormat("Missing signature".to_string())
                    })?,
                    Some(64),
                )?,
                gas_sponsorer: vec_to_array::<32>(st.gas_sponsorer().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing gas_sponsorer".to_string())
                })?)?,
            })
        }
        TxBody::SolveTx => {
            let sv = tx
                .body_as_solve_tx()
                .ok_or_else(|| TransactionError::InvalidFormat("Invalid SolveTx".to_string()))?;

            Transaction::Solve(Solve {
                sender: vec_to_array::<32>(sv.sender().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing sender".to_string())
                })?)?,
                proof: vec_to_vec(
                    sv.proof().ok_or_else(|| {
                        TransactionError::InvalidFormat("Missing proof".to_string())
                    })?,
                    Some(256),
                )?,
                puzzle_id: vec_to_array::<32>(sv.puzzle_id().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing puzzle_id".to_string())
                })?)?,
                nonce: sv.nonce(),
                signature: vec_to_vec(
                    sv.signature().ok_or_else(|| {
                        TransactionError::InvalidFormat("Missing signature".to_string())
                    })?,
                    Some(64),
                )?,
                gas_sponsorer: vec_to_array::<32>(sv.gas_sponsorer().ok_or_else(|| {
                    TransactionError::InvalidFormat("Missing gas_sponsorer".to_string())
                })?)?,
            })
        }
        _ => {
            return Err(TransactionError::InvalidFormat(
                "Unknown transaction type".to_string(),
            ))
        }
    };

    Ok(transaction)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::types::{bytes64, EMPTY64BYTES};

    #[test]
    fn test_transaction_roundtrip() {
        let tx = Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: 1000,
            nonce: 1,
            signature: bytes64(EMPTY64BYTES),
            gas_sponsorer: [5u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (tx, decoded) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.sender, b.sender);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.signature, b.signature);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }
}
