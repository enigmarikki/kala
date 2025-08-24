use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use std::sync::{Arc, Mutex, Once};
use tick::{init, nudupl_form_inplace, Reducer, VdfForm};

static INIT: Once = Once::new();

/// Initialize VDF library
pub fn initialize_vdf() {
    INIT.call_once(|| {
        init();
    });
}

/// Thread-safe wrapper for VDF internals
struct VdfInternals {
    current_form: VdfForm,
    reducer: Reducer,
}
unsafe impl Send for VdfInternals {}
unsafe impl Sync for VdfInternals {}

/// Represents data timestamped at a specific iteration
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TimestampedData {
    pub iteration: u64,
    pub data: Vec<u8>,
    pub data_hash: [u8; 32], // H(data) for efficiency
}

/// Merkle tree node for efficient proofs
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct MerkleNode {
    pub left: [u8; 32],
    pub right: [u8; 32],
    pub hash: [u8; 32],
}

/// Tick certificate - stored every k iterations
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TickCertificate {
    pub tick_number: u64,     // i = iteration / k
    pub start_iteration: u64, // i * k
    pub end_iteration: u64,   // (i + 1) * k
    pub form_a: String,       // VDF state at end
    pub form_b: String,
    pub form_c: String,
    pub hash_chain: [u8; 32],              // h_(i+1)k
    pub data_merkle_root: [u8; 32],        // Root of all data in this tick
    pub wesolowski_proof: Option<Vec<u8>>, // π for efficient verification ommited for brevity for now need to efficiently generate wesolowski's
}

/// The eternal VDF computation state
#[derive(Clone)]
pub struct EternalVDF {
    // Current iteration i
    iteration: u64,
    // VDF internals containing fi ∈ G
    internals: Arc<Mutex<VdfInternals>>,
    // Hash chain value hi ∈ {0,1}^256
    hash_chain: [u8; 32],
    // Discriminant D
    discriminant: String,
    // Tick size k (default 65536)
    tick_size: u64,

    // Production storage:
    // Only store tick certificates, not full history
    tick_certificates: Arc<Mutex<HashMap<u64, TickCertificate>>>,
    // Current tick's data (cleared after tick completes)
    current_tick_data: Arc<Mutex<Vec<TimestampedData>>>,
    // For important data, store with Merkle proofs
    important_timestamps: Arc<Mutex<HashMap<u64, (TimestampedData, Vec<[u8; 32]>)>>>,
}

impl EternalVDF {
    /// Initialize with f0 ← g, h0 ← H("genesis")
    pub fn new(discriminant: &str) -> Self {
        Self::with_tick_size(discriminant, 65536)
    }

    pub fn with_tick_size(discriminant: &str, tick_size: u64) -> Self {
        initialize_vdf();

        // h0 ← H("genesis")
        let mut hasher = Sha256::new();
        hasher.update(b"genesis");
        let genesis_hash = hasher.finalize().into();

        // f0 ← g (generator)
        let form = VdfForm::generator(discriminant);

        let internals = VdfInternals {
            current_form: form,
            reducer: Reducer::new(),
        };

        Self {
            iteration: 0,
            internals: Arc::new(Mutex::new(internals)),
            hash_chain: genesis_hash,
            discriminant: discriminant.to_string(),
            tick_size,
            tick_certificates: Arc::new(Mutex::new(HashMap::new())),
            current_tick_data: Arc::new(Mutex::new(Vec::new())),
            important_timestamps: Arc::new(Mutex::new(HashMap::new())),
        }
    }

    /// Load from a checkpoint (tick boundary)
    pub fn from_checkpoint(checkpoint: &VDFCheckpoint) -> Result<Self, String> {
        initialize_vdf();

        let mut form = VdfForm::new();
        form.set_a(&checkpoint.form_a);
        form.set_b(&checkpoint.form_b);
        form.set_c(&checkpoint.form_c);

        let internals = VdfInternals {
            current_form: form,
            reducer: Reducer::new(),
        };

        let mut tick_certs = HashMap::new();
        for cert in &checkpoint.tick_certificates {
            tick_certs.insert(cert.tick_number, cert.clone());
        }

        Ok(Self {
            iteration: checkpoint.iteration,
            internals: Arc::new(Mutex::new(internals)),
            hash_chain: checkpoint.hash_chain,
            discriminant: checkpoint.discriminant.clone(),
            tick_size: checkpoint.tick_size,
            tick_certificates: Arc::new(Mutex::new(tick_certs)),
            current_tick_data: Arc::new(Mutex::new(Vec::new())),
            important_timestamps: Arc::new(Mutex::new(HashMap::new())),
        })
    }

    /// Core computation step following Algorithm 1
    pub fn step(&mut self, data_to_timestamp: Option<Vec<u8>>) {
        let mut internals = self.internals.lock().unwrap();

        // fi ← fi-1^2 (mod D) - VDF step
        nudupl_form_inplace(&mut internals.current_form, &self.discriminant);

        // Reduce the form
        {
            let VdfInternals {
                current_form,
                reducer,
            } = &mut *internals;
            reducer.reduce(current_form);
        }

        // Increment iteration
        self.iteration += 1;

        // Get current form values
        let (form_a, form_b, form_c) = internals.current_form.get_values();

        // Drop lock before computing hash
        drop(internals);

        // hi ← H(i ∥ fi ∥ hi-1 ∥ di)
        let mut hasher = Sha256::new();
        hasher.update(&self.iteration.to_le_bytes());
        hasher.update(form_a.as_bytes());
        hasher.update(form_b.as_bytes());
        hasher.update(form_c.as_bytes());
        hasher.update(&self.hash_chain);

        // If we have data to timestamp
        if let Some(data) = data_to_timestamp {
            hasher.update(&data);

            // Store in current tick's data
            let data_hash = Sha256::digest(&data).into();
            let ts_data = TimestampedData {
                iteration: self.iteration,
                data,
                data_hash,
            };

            let mut tick_data = self.current_tick_data.lock().unwrap();
            tick_data.push(ts_data);
        }

        self.hash_chain = hasher.finalize().into();

        // Check if we completed a tick (finalize after k iterations, not at boundary)
        if self.iteration > 0 && self.iteration % self.tick_size == 0 {
            self.finalize_tick();
        }
    }

    /// Finalize a tick and create certificate
    fn finalize_tick(&self) {
        let tick_number = (self.iteration - 1) / self.tick_size;
        let start_iter = tick_number * self.tick_size;
        let end_iter = self.iteration;

        // Get current VDF state
        let internals = self.internals.lock().unwrap();
        let (form_a, form_b, form_c) = internals.current_form.get_values();
        drop(internals);

        // Calculate Merkle root of tick's data
        let mut tick_data = self.current_tick_data.lock().unwrap();
        let merkle_root = if tick_data.is_empty() {
            [0u8; 32]
        } else {
            Self::compute_merkle_root(&tick_data)
        };

        // Create tick certificate
        let certificate = TickCertificate {
            tick_number,
            start_iteration: start_iter,
            end_iteration: end_iter,
            form_a,
            form_b,
            form_c,
            hash_chain: self.hash_chain,
            data_merkle_root: merkle_root,
            wesolowski_proof: None, // Would compute In multinode setup
        };

        // Store certificate
        let mut certs = self.tick_certificates.lock().unwrap();
        certs.insert(tick_number, certificate);

        // Clear current tick data (already in Merkle tree)
        tick_data.clear();
    }

    /// Compute Merkle root of timestamped data
    fn compute_merkle_root(data: &[TimestampedData]) -> [u8; 32] {
        if data.is_empty() {
            return [0u8; 32];
        }

        // Leaf nodes are H(iteration || data_hash)
        let mut hashes: Vec<[u8; 32]> = data
            .iter()
            .map(|ts| {
                let mut hasher = Sha256::new();
                hasher.update(&ts.iteration.to_le_bytes());
                hasher.update(&ts.data_hash);
                hasher.finalize().into()
            })
            .collect();

        // Build tree bottom-up
        while hashes.len() > 1 {
            let mut next_level = Vec::new();

            for chunk in hashes.chunks(2) {
                let mut hasher = Sha256::new();
                hasher.update(&chunk[0]);
                if chunk.len() > 1 {
                    hasher.update(&chunk[1]);
                } else {
                    hasher.update(&chunk[0]); // Duplicate for odd number
                }
                next_level.push(hasher.finalize().into());
            }

            hashes = next_level;
        }

        hashes[0]
    }

    /// Advance without timestamping data
    pub fn advance(&mut self, iterations: u64) {
        for _ in 0..iterations {
            self.step(None);
        }
    }

    /// Timestamp data at the next iteration
    pub fn timestamp_data(&mut self, data: Vec<u8>) {
        self.step(Some(data));
    }

    /// Get current iteration
    pub fn get_iteration(&self) -> u64 {
        self.iteration
    }

    /// Get current form values
    pub fn get_form_values(&self) -> (String, String, String) {
        let checkpoint = self.checkpoint();
        (checkpoint.form_a, checkpoint.form_b, checkpoint.form_c)
    }

    /// Get current hash chain value
    pub fn get_hash_chain(&self) -> [u8; 32] {
        self.hash_chain
    }

    /// Get current tick number
    pub fn get_current_tick(&self) -> u64 {
        self.iteration / self.tick_size
    }

    /// Get tick certificate
    pub fn get_tick_certificate(&self, tick_number: u64) -> Option<TickCertificate> {
        let certs = self.tick_certificates.lock().unwrap();
        certs.get(&tick_number).cloned()
    }

    /// Get all tick certificates (for checkpoint)
    pub fn get_all_certificates(&self) -> Vec<TickCertificate> {
        let certs = self.tick_certificates.lock().unwrap();
        let mut all_certs: Vec<_> = certs.values().cloned().collect();
        all_certs.sort_by_key(|c| c.tick_number);
        all_certs
    }

    /// Store important data with Merkle proof for long-term verification
    pub fn timestamp_important_data(&mut self, data: Vec<u8>) -> TimestampProof {
        // First timestamp it normally
        self.step(Some(data.clone()));

        // Create proof that can be verified later
        let data_hash = Sha256::digest(&data).into();
        let ts_data = TimestampedData {
            iteration: self.iteration,
            data: data.clone(),
            data_hash,
        };

        // In multinode setup, we'd compute the Merkle path
        // For now, just store it
        let mut important = self.important_timestamps.lock().unwrap();
        important.insert(self.iteration, (ts_data.clone(), vec![]));

        TimestampProof {
            iteration: self.iteration,
            tick_number: self.iteration / self.tick_size,
            data,
            data_hash,
            hash_at_timestamp: self.hash_chain,
            merkle_path: vec![], // Would include actual path
        }
    }

    /// Create a checkpoint for persistence
    pub fn checkpoint(&self) -> VDFCheckpoint {
        let internals = self.internals.lock().unwrap();
        let (a, b, c) = internals.current_form.get_values();

        VDFCheckpoint {
            iteration: self.iteration,
            form_a: a,
            form_b: b,
            form_c: c,
            hash_chain: self.hash_chain,
            discriminant: self.discriminant.clone(),
            tick_size: self.tick_size,
            tick_certificates: self.get_all_certificates(),
        }
    }

    /// Verify a timestamp proof using tick certificates
    pub fn verify_timestamp_proof(&self, proof: &TimestampProof) -> bool {
        // Get the tick certificate for this proof
        let tick_num = proof.tick_number;
        let certs = self.tick_certificates.lock().unwrap();

        if let Some(cert) = certs.get(&tick_num) {
            // In multinode setup, verify:
            // 1. The Merkle path from data to cert.data_merkle_root
            // 2. The VDF proof if needed
            // 3. The iteration is within the tick range

            proof.iteration >= cert.start_iteration && proof.iteration < cert.end_iteration
        } else {
            false
        }
    }
}

/// Checkpoint structure for persistence
#[derive(Serialize, Deserialize, Clone)]
pub struct VDFCheckpoint {
    pub iteration: u64,
    pub form_a: String,
    pub form_b: String,
    pub form_c: String,
    pub hash_chain: [u8; 32],
    pub discriminant: String,
    pub tick_size: u64,
    pub tick_certificates: Vec<TickCertificate>,
}

/// Timestamp proof that can be verified efficiently
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct TimestampProof {
    pub iteration: u64,
    pub tick_number: u64,
    pub data: Vec<u8>,
    pub data_hash: [u8; 32],
    pub hash_at_timestamp: [u8; 32],
    pub merkle_path: Vec<[u8; 32]>, // Path to tick's Merkle root
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_vdf_with_tick_certificates() {
        let tick_size = 10; // Small for testing
        let mut vdf = EternalVDF::with_tick_size(
            "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679",
            tick_size
        );

        // Advance to iteration 5
        vdf.advance(5);
        assert_eq!(vdf.get_iteration(), 5);

        // Timestamp data (this will advance to iteration 6)
        vdf.timestamp_data(b"Data in tick 0".to_vec());
        assert_eq!(vdf.get_iteration(), 6);

        // Advance to complete tick 0 (need to reach iteration 10)
        vdf.advance(4);
        assert_eq!(vdf.get_iteration(), 10);
        assert_eq!(vdf.get_current_tick(), 1);

        // Verify tick 0 certificate exists
        let cert = vdf.get_tick_certificate(0).unwrap();
        assert_eq!(cert.tick_number, 0);
        assert_eq!(cert.start_iteration, 0);
        assert_eq!(cert.end_iteration, 10);
        assert_ne!(cert.data_merkle_root, [0u8; 32]); // Should have data
    }

    #[test]
    fn test_checkpoint_and_restore() {
        let tick_size = 5;
        let mut vdf = EternalVDF::with_tick_size(
            "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679",
            tick_size
        );

        // Create some ticks
        vdf.advance(5); // Complete tick 0
        vdf.timestamp_data(b"Tick 1 data".to_vec());
        vdf.advance(4); // Complete tick 1

        // Checkpoint
        let checkpoint = vdf.checkpoint();
        assert_eq!(checkpoint.iteration, 10);
        assert_eq!(checkpoint.tick_certificates.len(), 2);

        // Restore
        let vdf2 = EternalVDF::from_checkpoint(&checkpoint).unwrap();
        assert_eq!(vdf2.get_iteration(), 10);
        assert_eq!(vdf2.get_current_tick(), 2);

        // Verify certificates survived
        assert!(vdf2.get_tick_certificate(0).is_some());
        assert!(vdf2.get_tick_certificate(1).is_some());
    }

    #[test]
    fn test_important_timestamp_proof() {
        let mut vdf = EternalVDF::with_tick_size(
            "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679",
            20
        );

        // Advance to middle of tick
        vdf.advance(15);

        // Timestamp important data
        let proof = vdf.timestamp_important_data(b"Critical document".to_vec());
        assert_eq!(proof.iteration, 16);
        assert_eq!(proof.tick_number, 0);
        assert_eq!(proof.data, b"Critical document");

        // Complete the tick
        vdf.advance(4);

        // Verify the proof
        assert!(vdf.verify_timestamp_proof(&proof));
    }

    #[test]
    fn test_merkle_root_computation() {
        let data = vec![
            TimestampedData {
                iteration: 1,
                data: b"first".to_vec(),
                data_hash: Sha256::digest(b"first").into(),
            },
            TimestampedData {
                iteration: 2,
                data: b"second".to_vec(),
                data_hash: Sha256::digest(b"second").into(),
            },
        ];

        let root1 = EternalVDF::compute_merkle_root(&data);
        let root2 = EternalVDF::compute_merkle_root(&data);
        assert_eq!(root1, root2); // Deterministic

        // Different data should give different root
        let data2 = vec![TimestampedData {
            iteration: 1,
            data: b"different".to_vec(),
            data_hash: Sha256::digest(b"different").into(),
        }];
        let root3 = EternalVDF::compute_merkle_root(&data2);
        assert_ne!(root1, root3);
    }

    #[test]
    fn test_vdf_thread_safety() {
        let vdf = EternalVDF::new("-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679");
        std::thread::spawn(move || {
            let _ = vdf.get_iteration();
        });
    }
}
