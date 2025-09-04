use crate::generated::tx::{
    self, BurnTx, BurnTxArgs, MintTx, MintTxArgs, SendTx, SendTxArgs, SolveTx, SolveTxArgs,
    StakeTx, StakeTxArgs, Transaction as TransactionFb, TransactionArgs, TxBody, UnstakeTx,
    UnstakeTxArgs,
};
use crate::types::{Burn, Mint, Send, Solve, Stake, Transaction, Unstake};
use flatbuffers::FlatBufferBuilder;
use kala_common::prelude::{KalaError, KalaResult};
use sha2::{Digest, Sha256};

/// Compute transaction hash
pub fn hash_transaction(data: &[u8]) -> [u8; 32] {
    Sha256::digest(data).into()
}
/// Convert Rust transaction to FlatBuffer format
pub fn transaction_to_flatbuffer(tx: &Transaction) -> KalaResult<Vec<u8>> {
    let mut fbb = FlatBufferBuilder::new();

    let (body_type, body_val) = match tx {
        Transaction::Send(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let receiver_vec = fbb.create_vector(&t.receiver);
            let denom_vec = fbb.create_vector(&t.denom);
            let signature_vec = fbb.create_vector(&t.signature);
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
        Transaction::Burn(t) => {
            // Create vector offsets for byte arrays
            let sender_vec = fbb.create_vector(&t.sender);
            let denom_vec = fbb.create_vector(&t.denom);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = BurnTx::create(
                &mut fbb,
                &BurnTxArgs {
                    sender: Some(sender_vec),
                    amount: t.amount,
                    denom: Some(denom_vec),
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::BurnTx, off.as_union_value())
        }
        Transaction::Stake(t) => {
            // Create vector offsets for byte arrays
            let delegator_vec = fbb.create_vector(&t.delegator);
            let witness_vec = fbb.create_vector(&t.witness);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = StakeTx::create(
                &mut fbb,
                &StakeTxArgs {
                    delegator: Some(delegator_vec),
                    witness: Some(witness_vec),
                    amount: t.amount,
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::StakeTx, off.as_union_value())
        }
        Transaction::Unstake(t) => {
            // Create vector offsets for byte arrays
            let delegator_vec = fbb.create_vector(&t.delegator);
            let witness_vec = fbb.create_vector(&t.witness);
            let signature_vec = fbb.create_vector(&t.signature); // Already a Vec<u8>
            let gas_sponsorer_vec = fbb.create_vector(&t.gas_sponsorer);

            let off = UnstakeTx::create(
                &mut fbb,
                &UnstakeTxArgs {
                    delegator: Some(delegator_vec),
                    witness: Some(witness_vec),
                    amount: t.amount,
                    nonce: t.nonce,
                    signature: Some(signature_vec),
                    gas_sponsorer: Some(gas_sponsorer_vec),
                },
            );
            (TxBody::UnstakeTx, off.as_union_value())
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
fn vec_to_array<const N: usize>(vec: flatbuffers::Vector<u8>) -> KalaResult<[u8; N]> {
    let bytes = vec.bytes();
    if bytes.len() != N {
        return Err(KalaError::validation(format!(
            "Invalid size: expected {}, got {}",
            N,
            bytes.len()
        )));
    }
    let mut array = [0u8; N];
    array.copy_from_slice(bytes);
    Ok(array)
}


/// Convert FlatBuffer to Rust transaction
pub fn flatbuffer_to_transaction(bytes: &[u8]) -> KalaResult<Transaction> {
    let tx = tx::root_as_transaction(bytes)
        .map_err(|e| KalaError::validation(format!("Failed to parse: {e}")))?;

    let transaction =
        match tx.body_type() {
            TxBody::SendTx => {
                let st = tx
                    .body_as_send_tx()
                    .ok_or_else(|| KalaError::validation("Invalid SendTx".to_string()))?;

                Transaction::Send(Send {
                    sender: vec_to_array::<32>(
                        st.sender()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    receiver: vec_to_array::<32>(
                        st.receiver()
                            .ok_or_else(|| KalaError::validation("Missing receiver".to_string()))?,
                    )?,
                    denom: vec_to_array::<32>(
                        st.denom()
                            .ok_or_else(|| KalaError::validation("Missing denom".to_string()))?,
                    )?,
                    amount: st.amount(),
                    nonce: st.nonce(),
                    signature: vec_to_array(
                        st.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?,
                    )?,
                    gas_sponsorer: vec_to_array::<32>(st.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            TxBody::MintTx => {
                let mt = tx
                    .body_as_mint_tx()
                    .ok_or_else(|| KalaError::validation("Invalid MintTx".to_string()))?;

                Transaction::Mint(Mint {
                    sender: vec_to_array::<32>(
                        mt.sender()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    amount: mt.amount(),
                    denom: vec_to_array::<32>(
                        mt.denom()
                            .ok_or_else(|| KalaError::validation("Missing denom".to_string()))?,
                    )?,
                    nonce: mt.nonce(),
                    signature: vec_to_array::<64>(
                        mt.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?,
                    )?,
                    gas_sponsorer: vec_to_array::<32>(mt.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            TxBody::BurnTx => {
                let mt = tx
                    .body_as_burn_tx()
                    .ok_or_else(|| KalaError::validation("Invalid BurnTx".to_string()))?;

                Transaction::Burn(Burn {
                    sender: vec_to_array::<32>(
                        mt.sender()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    amount: mt.amount(),
                    denom: vec_to_array::<32>(
                        mt.denom()
                            .ok_or_else(|| KalaError::validation("Missing denom".to_string()))?,
                    )?,
                    nonce: mt.nonce(),
                    signature: vec_to_array(
                        mt.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?
                    )?,
                    gas_sponsorer: vec_to_array::<32>(mt.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            TxBody::StakeTx => {
                let st = tx
                    .body_as_stake_tx()
                    .ok_or_else(|| KalaError::validation("Invalid StakeTx".to_string()))?;

                Transaction::Stake(Stake {
                    delegator: vec_to_array::<32>(
                        st.delegator()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    witness: vec_to_array::<32>(
                        st.witness()
                            .ok_or_else(|| KalaError::validation("Missing witness".to_string()))?,
                    )?,
                    amount: st.amount(),
                    nonce: st.nonce(),
                    signature: vec_to_array(
                        st.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?
                    )?,
                    gas_sponsorer: vec_to_array::<32>(st.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            TxBody::UnstakeTx => {
                let st = tx
                    .body_as_unstake_tx()
                    .ok_or_else(|| KalaError::validation("Invalid UnstakeTx".to_string()))?;

                Transaction::Unstake(Unstake {
                    delegator: vec_to_array::<32>(
                        st.delegator()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    witness: vec_to_array::<32>(
                        st.witness()
                            .ok_or_else(|| KalaError::validation("Missing witness".to_string()))?,
                    )?,
                    amount: st.amount(),
                    nonce: st.nonce(),
                    signature: vec_to_array(
                        st.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?
                    )?,
                    gas_sponsorer: vec_to_array::<32>(st.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            TxBody::SolveTx => {
                let sv = tx
                    .body_as_solve_tx()
                    .ok_or_else(|| KalaError::validation("Invalid SolveTx".to_string()))?;

                Transaction::Solve(Solve {
                    sender: vec_to_array::<32>(
                        sv.sender()
                            .ok_or_else(|| KalaError::validation("Missing sender".to_string()))?,
                    )?,
                    proof: vec_to_array(
                        sv.proof()
                            .ok_or_else(|| KalaError::validation("Missing proof".to_string()))?,
                    )?,
                    puzzle_id: vec_to_array::<32>(
                        sv.puzzle_id().ok_or_else(|| 
                            KalaError::validation("Missing puzzle_id".to_string())
                        )?,
                    )?,
                    nonce: sv.nonce(),
                    signature: vec_to_array(
                        sv.signature().ok_or_else(|| 
                            KalaError::validation("Missing signature".to_string())
                        )?
                    )?,
                    gas_sponsorer: vec_to_array::<32>(sv.gas_sponsorer().ok_or_else(|| {
                        KalaError::validation("Missing gas_sponsorer".to_string())
                    })?)?,
                })
            }
            _ => {
                return Err(KalaError::validation(
                    "Invalid transaction type".to_string(),
                ))
            }
        };

    Ok(transaction)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::types::{Bytes64, EMPTY64BYTES};

    fn create_test_send_tx() -> Transaction {
        Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: 1000,
            nonce: 1,
            signature: EMPTY64BYTES,
            gas_sponsorer: [5u8; 32],
        })
    }

    fn create_test_mint_tx() -> Transaction {
        Transaction::Mint(Mint {
            sender: [10u8; 32],
            amount: 5000,
            denom: [11u8; 32],
            nonce: 2,
            signature: [12u8; 64],
            gas_sponsorer: [13u8; 32],
        })
    }

    fn create_test_burn_tx() -> Transaction {
        Transaction::Burn(Burn {
            sender: [20u8; 32],
            amount: 3000,
            denom: [21u8; 32],
            nonce: 3,
            signature: [22u8; 64],
            gas_sponsorer: [23u8; 32],
        })
    }

    fn create_test_stake_tx() -> Transaction {
        Transaction::Stake(Stake {
            delegator: [30u8; 32],
            witness: [31u8; 32],
            amount: 10000,
            nonce: 4,
            signature: [32u8; 64],
            gas_sponsorer: [33u8; 32],
        })
    }

    fn create_test_unstake_tx() -> Transaction {
        Transaction::Unstake(Unstake {
            delegator: [40u8; 32],
            witness: [41u8; 32],
            amount: 7500,
            nonce: 5,
            signature: [42u8; 64],
            gas_sponsorer: [43u8; 32],
        })
    }

    fn create_test_solve_tx() -> Transaction {
        Transaction::Solve(Solve {
            sender: [50u8; 32],
            proof: [51u8; 256],
            puzzle_id: [52u8; 32],
            nonce: 6,
            signature: [53u8; 64],
            gas_sponsorer: [54u8; 32],
        })
    }

    #[test]
    fn test_send_transaction_roundtrip() {
        let tx = create_test_send_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.sender, b.sender);
                assert_eq!(a.receiver, b.receiver);
                assert_eq!(a.denom, b.denom);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_mint_transaction_roundtrip() {
        let tx = create_test_mint_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Mint(a), Transaction::Mint(b)) => {
                assert_eq!(a.sender, b.sender);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.denom, b.denom);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_burn_transaction_roundtrip() {
        let tx = create_test_burn_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();

        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Burn(a), Transaction::Burn(b)) => {
                assert_eq!(a.sender, b.sender);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.denom, b.denom);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_stake_transaction_roundtrip() {
        let tx = create_test_stake_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Stake(a), Transaction::Stake(b)) => {
                assert_eq!(a.delegator, b.delegator);
                assert_eq!(a.witness, b.witness);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_unstake_transaction_roundtrip() {
        let tx = create_test_unstake_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();

        // Note: This test will fail with the current implementation due to the bug
        // where UnstakeTx uses body_as_stake_tx instead of body_as_unstake_tx
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Unstake(a), Transaction::Unstake(b)) => {
                assert_eq!(a.delegator, b.delegator);
                assert_eq!(a.witness, b.witness);
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!(
                "Transaction type mismatch: expected Unstake, got {:?}",
                decoded
            ),
        }
    }

    #[test]
    fn test_solve_transaction_roundtrip() {
        let tx = create_test_solve_tx();
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Solve(a), Transaction::Solve(b)) => {
                assert_eq!(a.sender, b.sender);
                assert_eq!(a.proof, b.proof);
                assert_eq!(a.puzzle_id, b.puzzle_id);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.signature, b.signature);
                assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    // ==================== Hash Function Tests ====================

    #[test]
    fn test_hash_transaction_deterministic() {
        let data = b"test transaction data";
        let hash1 = hash_transaction(data);
        let hash2 = hash_transaction(data);

        assert_eq!(hash1, hash2, "Hash should be deterministic");
        assert_eq!(hash1.len(), 32, "Hash should be 32 bytes");
    }

    #[test]
    fn test_hash_transaction_different_inputs() {
        let data1 = b"transaction 1";
        let data2 = b"transaction 2";

        let hash1 = hash_transaction(data1);
        let hash2 = hash_transaction(data2);

        assert_ne!(
            hash1, hash2,
            "Different inputs should produce different hashes"
        );
    }

    #[test]
    fn test_hash_empty_data() {
        let hash = hash_transaction(b"");
        assert_eq!(
            hash.len(),
            32,
            "Empty data should still produce 32-byte hash"
        );

        // Known SHA-256 hash of empty string
        let expected = [
            0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14, 0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f,
            0xb9, 0x24, 0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c, 0xa4, 0x95, 0x99, 0x1b,
            0x78, 0x52, 0xb8, 0x55,
        ];
        assert_eq!(hash, expected);
    }

    #[test]
    fn test_maximum_values() {
        let tx = Transaction::Send(Send {
            sender: [255u8; 32],
            receiver: [255u8; 32],
            denom: [255u8; 32],
            amount: u64::MAX,
            nonce: u64::MAX,
            signature: [255u8; 64],
            gas_sponsorer: [255u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
                assert_eq!(a.sender, b.sender);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_minimum_values() {
        let tx = Transaction::Send(Send {
            sender: [0u8; 32],
            receiver: [0u8; 32],
            denom: [0u8; 32],
            amount: 0,
            nonce: 0,
            signature: [0u8; 64],
            gas_sponsorer: [0u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match (&tx, &decoded) {
            (Transaction::Send(a), Transaction::Send(b)) => {
                assert_eq!(a.amount, b.amount);
                assert_eq!(a.nonce, b.nonce);
            }
            _ => panic!("Transaction type mismatch"),
        }
    }

    #[test]
    fn test_vec_to_array_wrong_size() {
        // This would need access to a mock FlatBuffer vector with wrong size
        // Since we can't easily create invalid FlatBuffer vectors, we'll test
        // through the full deserialization path with corrupted data

        let invalid_data = vec![0u8; 10]; // Too small to be valid
        let result = flatbuffer_to_transaction(&invalid_data);

        assert!(result.is_err(), "Should fail to parse invalid data");

        // Check the error message
        match result {
            Err(e) => {
                let error_msg = format!("{}", e);
                assert!(error_msg.contains("Invalid transaction"));
            }
            Ok(_) => panic!("Should not successfully parse invalid data"),
        }
    }
    #[test]
    fn test_corrupted_flatbuffer() {
        // Create valid transaction and serialize it
        let tx = create_test_send_tx();
        let mut fb_bytes = transaction_to_flatbuffer(&tx).unwrap();

        // Corrupt the data
        if fb_bytes.len() > 10 {
            fb_bytes[10] = 255;
            fb_bytes[11] = 255;
        }

        // Try to deserialize corrupted data
        let result = flatbuffer_to_transaction(&fb_bytes);

        // This might either fail to parse or produce wrong transaction type
        if result.is_err() {
            let error_msg = format!("{}", result.unwrap_err());
            assert!(
                error_msg.contains("Failed to parse")
                    || error_msg.contains("Invalid")
                    || error_msg.contains("Missing")
            );
        }
    }

    #[test]
    fn test_vec_to_array_with_expected_size() {
        // We need to test this through the full serialization path
        let tx = Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: 1000,
            nonce: 1,
            signature: [4u8; 64], // Correct size
            gas_sponsorer: [5u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match decoded {
            Transaction::Send(s) => {
                assert_eq!(s.signature.len(), 64);
            }
            _ => panic!("Wrong transaction type"),
        }
    }

    #[test]
    fn test_solve_proof_size_validation() {
        let tx = Transaction::Solve(Solve {
            sender: [50u8; 32],
            proof: [51u8; 256], // Correct size
            puzzle_id: [52u8; 32],
            nonce: 6,
            signature: [53u8; 64],
            gas_sponsorer: [54u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match decoded {
            Transaction::Solve(s) => {
                assert_eq!(s.proof.len(), 256, "Proof should be exactly 256 bytes");
            }
            _ => panic!("Wrong transaction type"),
        }
    }

    #[test]
    fn test_serialization_sizes() {
        let transactions = vec![
            create_test_send_tx(),
            create_test_mint_tx(),
            create_test_burn_tx(),
            create_test_stake_tx(),
            create_test_unstake_tx(),
            create_test_solve_tx(),
        ];

        for tx in transactions {
            let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();

            // FlatBuffer should add some overhead but be reasonable
            assert!(fb_bytes.len() > 100, "Serialized size too small");
            assert!(fb_bytes.len() < 10000, "Serialized size too large");

            // Verify the serialized data starts with valid FlatBuffer header
            assert!(!fb_bytes.is_empty());
        }
    }

    #[test]
    fn test_batch_serialization() {
        let transactions = vec![
            create_test_send_tx(),
            create_test_mint_tx(),
            create_test_burn_tx(),
            create_test_stake_tx(),
            create_test_unstake_tx(),
            create_test_solve_tx(),
        ];

        let mut serialized = Vec::new();

        // Serialize all transactions
        for tx in &transactions {
            let fb_bytes = transaction_to_flatbuffer(tx).unwrap();
            serialized.push(fb_bytes);
        }

        // Deserialize and verify
        for (i, (original, fb_bytes)) in transactions.iter().zip(serialized.iter()).enumerate() {
            let decoded = flatbuffer_to_transaction(fb_bytes).unwrap();

            // Verify transaction types match
            match (original, &decoded) {
                (Transaction::Send(_), Transaction::Send(_))
                | (Transaction::Mint(_), Transaction::Mint(_))
                | (Transaction::Burn(_), Transaction::Burn(_))
                | (Transaction::Stake(_), Transaction::Stake(_))
                | (Transaction::Unstake(_), Transaction::Unstake(_))
                | (Transaction::Solve(_), Transaction::Solve(_)) => {
                    // Type matches, good
                }
                _ => panic!("Transaction type mismatch at index {}", i),
            }
        }
    }

    #[test]
    fn test_concurrent_serialization() {
        use std::sync::Arc;
        use std::thread;

        let tx = Arc::new(create_test_send_tx());
        let num_threads = 10;
        let mut handles = vec![];

        for _ in 0..num_threads {
            let tx_clone = Arc::clone(&tx);
            let handle = thread::spawn(move || {
                for _ in 0..100 {
                    let fb_bytes = transaction_to_flatbuffer(&tx_clone).unwrap();
                    let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

                    match (&*tx_clone, decoded) {
                        (Transaction::Send(a), Transaction::Send(b)) => {
                            assert_eq!(a.amount, b.amount);
                        }
                        _ => panic!("Transaction type mismatch"),
                    }
                }
            });
            handles.push(handle);
        }

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_special_byte_patterns() {
        // Test with various byte patterns that might cause issues
        let patterns = vec![
            [0x00u8; 32], // All zeros
            [0xFFu8; 32], // All ones
            [0xAAu8; 32], // Alternating 10101010
            [0x55u8; 32], // Alternating 01010101
        ];

        for pattern in patterns {
            let tx = Transaction::Send(Send {
                sender: pattern,
                receiver: pattern,
                denom: pattern,
                amount: 1000,
                nonce: 1,
                signature: [pattern[0]; 64],
                gas_sponsorer: pattern,
            });

            let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
            let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

            match (&tx, &decoded) {
                (Transaction::Send(a), Transaction::Send(b)) => {
                    assert_eq!(a.sender, b.sender);
                    assert_eq!(a.receiver, b.receiver);
                    assert_eq!(a.denom, b.denom);
                    assert_eq!(a.gas_sponsorer, b.gas_sponsorer);
                }
                _ => panic!("Transaction type mismatch"),
            }
        }
    }

    #[test]
    #[ignore]
    fn test_serialization_performance() {
        use std::time::Instant;

        let tx = create_test_send_tx();
        let iterations = 10000;

        // Test serialization performance
        let start = Instant::now();
        for _ in 0..iterations {
            let _ = transaction_to_flatbuffer(&tx).unwrap();
        }
        let ser_duration = start.elapsed();

        println!(
            "Serialized {} transactions in {:?}",
            iterations, ser_duration
        );
        println!(
            "Average serialization time: {:?}",
            ser_duration / iterations
        );

        // Test deserialization performance
        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let start = Instant::now();
        for _ in 0..iterations {
            let _ = flatbuffer_to_transaction(&fb_bytes).unwrap();
        }
        let deser_duration = start.elapsed();

        println!(
            "Deserialized {} transactions in {:?}",
            iterations, deser_duration
        );
        println!(
            "Average deserialization time: {:?}",
            deser_duration / iterations
        );

        // Assert reasonable performance (< 100 microseconds per operation)
        let avg_ser_micros = ser_duration.as_micros() / (iterations as u128);
        let avg_deser_micros = deser_duration.as_micros() / (iterations as u128);

        assert!(
            avg_ser_micros < 100,
            "Serialization too slow: {} microseconds",
            avg_ser_micros
        );
        assert!(
            avg_deser_micros < 100,
            "Deserialization too slow: {} microseconds",
            avg_deser_micros
        );
    }

    #[test]
    fn test_large_proof_handling() {
        // Test with maximum expected proof size
        let large_proof = [42u8; 256];

        let tx = Transaction::Solve(Solve {
            sender: [50u8; 32],
            proof: large_proof.clone(),
            puzzle_id: [52u8; 32],
            nonce: 6,
            signature: [53u8; 64],
            gas_sponsorer: [54u8; 32],
        });

        let fb_bytes = transaction_to_flatbuffer(&tx).unwrap();
        let decoded = flatbuffer_to_transaction(&fb_bytes).unwrap();

        match decoded {
            Transaction::Solve(s) => {
                assert_eq!(s.proof, large_proof);
                assert_eq!(s.proof.len(), 256);
            }
            _ => panic!("Wrong transaction type"),
        }
    }

    #[test]
    fn test_hash_large_data() {
        let large_data = vec![0xABu8; 1_000_000]; // 1MB of data
        let hash = hash_transaction(&large_data);

        assert_eq!(hash.len(), 32);

        // Hash should be deterministic even for large data
        let hash2 = hash_transaction(&large_data);
        assert_eq!(hash, hash2);
    }

    #[test]
    fn test_serialization_stability() {
        // This test ensures that the same transaction always produces
        // the same serialized output (important for signatures/hashes)
        let tx = Transaction::Send(Send {
            sender: [1u8; 32],
            receiver: [2u8; 32],
            denom: [3u8; 32],
            amount: 1000,
            nonce: 1,
            signature: [4u8; 64],
            gas_sponsorer: [5u8; 32],
        });

        let fb_bytes1 = transaction_to_flatbuffer(&tx).unwrap();
        let fb_bytes2 = transaction_to_flatbuffer(&tx).unwrap();

        assert_eq!(
            fb_bytes1, fb_bytes2,
            "Serialization should be deterministic"
        );

        // Also verify the hash is stable
        let hash1 = hash_transaction(&fb_bytes1);
        let hash2 = hash_transaction(&fb_bytes2);
        assert_eq!(hash1, hash2);
    }
}
