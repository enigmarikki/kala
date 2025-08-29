//! Cryptographic utilities and hash operations

use crate::{
    error::KalaResult,
    types::{Hash, HashExt, PublicKey, PublicKeyExt, Signature, SignatureExt},
};
use sha2::{Digest, Sha256};

/// Cryptographic constants
pub const HASH_SIZE: usize = 32;
pub const PUBKEY_SIZE: usize = 32;
pub const SIGNATURE_SIZE: usize = 64;

/// Central cryptographic utilities
pub struct CryptoUtils;

impl CryptoUtils {
    /// Compute SHA-256 hash of data
    pub fn hash(data: &[u8]) -> Hash {
        let mut hasher = Sha256::new();
        hasher.update(data);
        let result = hasher.finalize();
        result.into()
    }

    /// Compute hash of multiple data chunks
    pub fn hash_multiple(chunks: &[&[u8]]) -> Hash {
        let mut hasher = Sha256::new();
        for chunk in chunks {
            hasher.update(chunk);
        }
        let result = hasher.finalize();
        result.into()
    }

    /// Create hash chain from previous hash and new data
    pub fn hash_chain(previous_hash: &Hash, new_data: &[u8]) -> Hash {
        Self::hash_multiple(&[previous_hash, new_data])
    }

    /// Verify hash integrity
    pub fn verify_hash(data: &[u8], expected_hash: &Hash) -> bool {
        let computed_hash = Self::hash(data);
        computed_hash == *expected_hash
    }

    /// Generate random bytes (for testing/dev purposes)
    #[cfg(feature = "dev")]
    pub fn random_bytes<const N: usize>() -> [u8; N] {
        use rand::RngCore;
        let mut bytes = [0u8; N];
        rand::thread_rng().fill_bytes(&mut bytes);
        bytes
    }

    /// Validate public key format
    pub fn validate_pubkey(pubkey: &PublicKey) -> bool {
        !PublicKeyExt::is_zero(pubkey)
    }

    /// Validate signature format
    pub fn validate_signature(signature: &Signature) -> bool {
        !signature.is_zero()
    }

    /// Convert hex string to hash
    pub fn hex_to_hash(hex_str: &str) -> KalaResult<Hash> {
        if hex_str.len() != HASH_SIZE * 2 {
            return Err(crate::error::KalaError::validation(format!(
                "Invalid hash length: expected {}, got {}",
                HASH_SIZE * 2,
                hex_str.len()
            )));
        }

        let bytes = hex::decode(hex_str)
            .map_err(|e| crate::error::KalaError::validation(format!("Invalid hex: {}", e)))?;

        let mut hash = [0u8; HASH_SIZE];
        hash.copy_from_slice(&bytes);
        Ok(hash)
    }

    /// Convert hash to hex string
    pub fn hash_to_hex(hash: &Hash) -> String {
        hex::encode(hash)
    }
}

/// Merkle tree implementation for batch verification
pub struct MerkleTree {
    leaves: Vec<Hash>,
    nodes: Vec<Hash>,
}

impl MerkleTree {
    /// Build merkle tree from leaf hashes
    pub fn new(leaves: Vec<Hash>) -> Self {
        if leaves.is_empty() {
            return Self {
                leaves: vec![HashExt::zero()],
                nodes: vec![HashExt::zero()],
            };
        }

        let mut nodes = leaves.clone();
        let mut current_level = leaves.len();

        // Build tree bottom-up
        while current_level > 1 {
            let mut next_level = Vec::new();

            for i in (0..current_level).step_by(2) {
                let left = nodes[i];
                let right = if i + 1 < current_level {
                    nodes[i + 1]
                } else {
                    left // Duplicate if odd number
                };

                let parent = CryptoUtils::hash_multiple(&[&left, &right]);
                next_level.push(parent);
            }

            nodes.extend_from_slice(&next_level);
            current_level = next_level.len();
        }

        Self { leaves, nodes }
    }

    /// Get root hash
    pub fn root(&self) -> Hash {
        self.nodes.last().copied().unwrap_or_else(HashExt::zero)
    }

    /// Generate merkle proof for leaf at index
    pub fn proof(&self, index: usize) -> Option<Vec<Hash>> {
        if index >= self.leaves.len() {
            return None;
        }

        let mut proof = Vec::new();
        let mut current_index = index;
        let mut level_size = self.leaves.len();
        let mut level_start = 0;

        while level_size > 1 {
            let sibling_index = if current_index % 2 == 0 {
                current_index + 1
            } else {
                current_index - 1
            };

            if sibling_index < level_size {
                proof.push(self.nodes[level_start + sibling_index]);
            }

            level_start += level_size;
            current_index /= 2;
            level_size = (level_size + 1) / 2;
        }

        Some(proof)
    }

    /// Verify merkle proof
    pub fn verify_proof(leaf: &Hash, proof: &[Hash], root: &Hash, index: usize) -> bool {
        let mut current_hash = *leaf;
        let mut current_index = index;

        for sibling in proof {
            current_hash = if current_index % 2 == 0 {
                CryptoUtils::hash_multiple(&[&current_hash, sibling])
            } else {
                CryptoUtils::hash_multiple(&[sibling, &current_hash])
            };
            current_index /= 2;
        }

        current_hash == *root
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_hash() {
        let data = b"test data";
        let hash1 = CryptoUtils::hash(data);
        let hash2 = CryptoUtils::hash(data);
        assert_eq!(hash1, hash2);
        assert_ne!(hash1, [0u8; 32]);
    }

    #[test]
    fn test_hash_chain() {
        let data1 = b"first";
        let data2 = b"second";

        let hash1 = CryptoUtils::hash(data1);
        let chain_hash = CryptoUtils::hash_chain(&hash1, data2);

        let expected = CryptoUtils::hash_multiple(&[&hash1, data2]);
        assert_eq!(chain_hash, expected);
    }

    #[test]
    fn test_merkle_tree() {
        let leaves = vec![
            CryptoUtils::hash(b"leaf1"),
            CryptoUtils::hash(b"leaf2"),
            CryptoUtils::hash(b"leaf3"),
            CryptoUtils::hash(b"leaf4"),
        ];

        let tree = MerkleTree::new(leaves.clone());
        let root = tree.root();

        // Test proof generation and verification
        for (i, leaf) in leaves.iter().enumerate() {
            let proof = tree.proof(i).unwrap();
            assert!(MerkleTree::verify_proof(leaf, &proof, &root, i));
        }
    }

    #[test]
    fn test_hex_conversion() {
        let original_hash = CryptoUtils::hash(b"test");
        let hex_str = CryptoUtils::hash_to_hex(&original_hash);
        let converted_hash = CryptoUtils::hex_to_hash(&hex_str).unwrap();
        assert_eq!(original_hash, converted_hash);
    }
}
