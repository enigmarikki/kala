use crate::classgroup::ClassGroup;
use crate::discriminant::Discriminant;
use crate::form::QuadraticForm;
use crate::types::CVDFError;
use blake3::Hasher;
use rug::integer::Order;
use rug::Integer;
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use std::sync::{Arc, RwLock};

/// Pietrzak proof for a single VDF evaluation
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct PietrzakProof {
    /// Intermediate values μ_i for each round
    pub mu_values: Vec<QuadraticForm>,
}

impl PietrzakProof {
    /// Generate a Pietrzak proof for g^(2^T) = y
    pub fn generate(
        class_group: &ClassGroup,
        discriminant: &Discriminant,
        g: &QuadraticForm,
        y: &QuadraticForm,
        t: usize,
    ) -> Result<Self, CVDFError> {
        if t == 0 {
            return Ok(PietrzakProof { mu_values: vec![] });
        }

        let mut mu_values = Vec::new();
        let mut x = g.clone();
        let mut y_cur = y.clone();
        let mut t_cur = t;

        while t_cur > 0 {
            // Compute μ = x^(2^(T/2))
            let half_t = t_cur / 2;
            let mu = class_group.repeated_squaring(&x, half_t)?;
            mu_values.push(mu.clone());

            // Generate challenge using Fiat-Shamir
            let r = Self::generate_challenge(&x, &y_cur, &mu, discriminant);

            // Update for next round: x' = x^r * μ, y' = μ^r * y
            let x_r = class_group.pow(&x, &r)?;
            let mu_r = class_group.pow(&mu, &r)?;
            x = class_group.compose(&x_r, &mu)?;
            y_cur = class_group.compose(&mu_r, &y_cur)?;

            t_cur = half_t;
        }

        Ok(PietrzakProof { mu_values })
    }

    /// Verify a Pietrzak proof
    pub fn verify(
        &self,
        class_group: &ClassGroup,
        discriminant: &Discriminant,
        g: &QuadraticForm,
        y: &QuadraticForm,
        t: usize,
    ) -> Result<bool, CVDFError> {
        if t == 0 {
            return Ok(g == y);
        }

        let mut x = g.clone();
        let mut y_cur = y.clone();
        let mut t_cur = t;

        for mu in &self.mu_values {
            if t_cur == 0 {
                break;
            }

            // Generate same challenge
            let r = Self::generate_challenge(&x, &y_cur, mu, discriminant);

            // Update x and y
            let x_r = class_group.pow(&x, &r)?;
            let mu_r = class_group.pow(mu, &r)?;
            x = class_group.compose(&x_r, mu)?;
            y_cur = class_group.compose(&mu_r, &y_cur)?;

            t_cur /= 2;
        }

        // Final check: x^2 should equal y
        let x_squared = class_group.square(&x)?;
        Ok(x_squared == y_cur)
    }

    fn generate_challenge(
        x: &QuadraticForm,
        y: &QuadraticForm,
        mu: &QuadraticForm,
        discriminant: &Discriminant,
    ) -> Integer {
        let mut hasher = Hasher::new();
        
        // Hash x
        hasher.update(&x.a.to_digits(Order::MsfBe));
        hasher.update(&x.b.to_digits(Order::MsfBe));
        hasher.update(&x.c.to_digits(Order::MsfBe));
        
        // Hash y
        hasher.update(&y.a.to_digits(Order::MsfBe));
        hasher.update(&y.b.to_digits(Order::MsfBe));
        hasher.update(&y.c.to_digits(Order::MsfBe));
        
        // Hash μ
        hasher.update(&mu.a.to_digits(Order::MsfBe));
        hasher.update(&mu.b.to_digits(Order::MsfBe));
        hasher.update(&mu.c.to_digits(Order::MsfBe));
        
        // Hash discriminant
        hasher.update(&discriminant.value.to_digits(Order::MsfBe));
        
        let hash = hasher.finalize();
        let challenge = Integer::from_digits(hash.as_bytes(), Order::MsfBe);
        
        // Ensure non-zero and bounded
        let max = Integer::from(1) << 256;
        (challenge.modulo(&max)).abs() + Integer::from(1)
    }
}

/// A node in the CVDF tree with proof
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ProofNode {
    /// The output value at this node
    pub value: QuadraticForm,
    /// For leaves: Pietrzak proof that value = prev_value^(2^T)
    /// For internal nodes: None (verified via children)
    pub vdf_proof: Option<PietrzakProof>,
    /// Time when this node was computed (for leaves)
    pub time: usize,
}

/// A complete proof for a CVDF evaluation
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct CVDFProof {
    /// The claimed output after t steps
    pub output: QuadraticForm,
    /// Total time steps claimed
    pub total_time: usize,
    /// Tree arity used
    pub arity: usize,
    /// Proof nodes forming the authentication path
    /// Maps (level, index) -> ProofNode
    pub proof_path: BTreeMap<(usize, usize), ProofNode>,
}

impl CVDFProof {
    /// Verify this proof is valid
    pub fn verify(
        &self,
        class_group: &ClassGroup,
        discriminant: &Discriminant,
        starting_value: &QuadraticForm,
        base_difficulty: usize,
        security_param: usize,
    ) -> Result<bool, CVDFError> {
        // First, verify all VDF proofs for leaves
        for ((level, _idx), node) in &self.proof_path {
            if *level == 0 {
                if let Some(proof) = &node.vdf_proof {
                    // Get previous leaf or starting value
                    let prev_value = if node.time == 0 {
                        starting_value.clone()
                    } else {
                        // Find previous leaf in proof path
                        self.proof_path
                            .get(&(0, node.time - 1))
                            .map(|n| n.value.clone())
                            .unwrap_or_else(|| starting_value.clone())
                    };
                    
                    // Verify VDF proof
                    if !proof.verify(class_group, discriminant, &prev_value, &node.value, base_difficulty)? {
                        return Ok(false);
                    }
                }
            }
        }

        // Verify aggregations at higher levels
        for ((level, idx), node) in &self.proof_path {
            if *level > 0 {
                // Find the k children that should aggregate to this node
                let first_child_idx = idx * self.arity;
                let mut aggregate = QuadraticForm::identity(discriminant);
                
                for i in 0..self.arity {
                    let child_idx = first_child_idx + i;
                    if let Some(child) = self.proof_path.get(&(level - 1, child_idx)) {
                        // Generate Fiat-Shamir challenge
                        let challenge = Self::generate_node_challenge(child, *level - 1, child_idx, discriminant, security_param);
                        let powered = class_group.pow(&child.value, &challenge)?;
                        aggregate = class_group.compose(&aggregate, &powered)?;
                    } else {
                        return Ok(false); // Missing child
                    }
                }
                
                if aggregate.reduce() != node.value {
                    return Ok(false);
                }
            }
        }

        // Verify the claimed output is in the proof path
        let output_found = self.proof_path.values().any(|n| n.value == self.output);
        
        Ok(output_found)
    }

    fn generate_node_challenge(
        node: &ProofNode,
        level: usize,
        index: usize,
        discriminant: &Discriminant,
        security_param: usize,
    ) -> Integer {
        let mut hasher = Hasher::new();
        
        hasher.update(&node.value.a.to_digits(Order::MsfBe));
        hasher.update(&node.value.b.to_digits(Order::MsfBe));
        hasher.update(&node.value.c.to_digits(Order::MsfBe));
        hasher.update(&level.to_be_bytes());
        hasher.update(&index.to_be_bytes());
        hasher.update(&node.time.to_be_bytes());
        hasher.update(&discriminant.value.to_digits(Order::MsfBe));
        
        let hash = hasher.finalize();
        let challenge = Integer::from_digits(hash.as_bytes(), Order::MsfBe);
        let max = Integer::from(1) << security_param;
        (challenge.modulo(&max)).abs() + Integer::from(1)
    }
}

/// The CVDF frontier state
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct CVDFFrontier {
    pub discriminant: Discriminant,
    pub arity: usize,
    pub security_param: usize,
    pub base_difficulty: usize,
    pub starting_value: QuadraticForm,
    pub current_time: usize,
    /// All nodes we need to keep for proofs
    pub nodes: BTreeMap<(usize, usize), ProofNode>,
}

impl CVDFFrontier {
    pub fn new(
        discriminant: Discriminant,
        arity: usize,
        security_param: usize,
        base_difficulty: usize,
        starting_value: QuadraticForm,
    ) -> Self {
        CVDFFrontier {
            discriminant,
            arity,
            security_param,
            base_difficulty,
            starting_value,
            current_time: 0,
            nodes: BTreeMap::new(),
        }
    }

    /// Generate a proof for the current state
    pub fn generate_proof(&self) -> CVDFProof {
        // Find the highest value (rightmost at highest level)
        let output = self.nodes
            .values()
            .max_by_key(|n| n.time)
            .map(|n| n.value.clone())
            .unwrap_or_else(|| self.starting_value.clone());

        CVDFProof {
            output,
            total_time: self.current_time,
            arity: self.arity,
            proof_path: self.nodes.clone(),
        }
    }

    pub fn checkpoint(&self) -> Result<Vec<u8>, CVDFError> {
        bincode::serialize(self).map_err(|e| CVDFError::SerializationError(e.to_string()))
    }

    pub fn from_checkpoint(data: &[u8]) -> Result<Self, CVDFError> {
        bincode::deserialize(data).map_err(|e| CVDFError::DeserializationError(e.to_string()))
    }
}

/// Configuration
#[derive(Clone, Debug)]
pub struct CVDFConfig {
    pub discriminant: Discriminant,
    pub security_param: usize,
    pub tree_arity: usize,
    pub base_difficulty: usize,
}

impl Default for CVDFConfig {
    fn default() -> Self {
        CVDFConfig {
            discriminant: Discriminant::generate(1024).unwrap(),
            security_param: 256,
            tree_arity: 256, // λ for optimal security
            base_difficulty: 20, // 2^20 squarings per step
        }
    }
}

/// Main CVDF implementation with proof generation
pub struct CVDFStreamer {
    config: Arc<CVDFConfig>,
    frontier: Arc<RwLock<CVDFFrontier>>,
    class_group: ClassGroup,
}

impl CVDFStreamer {
    pub fn new(config: CVDFConfig) -> Self {
        let class_group = ClassGroup::new(config.discriminant.clone());
        let starting_value = QuadraticForm::identity(&config.discriminant);
        
        let frontier = CVDFFrontier::new(
            config.discriminant.clone(),
            config.tree_arity,
            config.security_param,
            config.base_difficulty,
            starting_value,
        );

        CVDFStreamer {
            frontier: Arc::new(RwLock::new(frontier)),
            class_group,
            config: Arc::new(config),
        }
    }

    /// Initialize with a specific starting value
    pub fn initialize(&mut self, start_form: QuadraticForm) -> Result<(), CVDFError> {
        if !start_form.is_valid(&self.config.discriminant) {
            return Err(CVDFError::InvalidElement);
        }

        let mut frontier = self.frontier.write()?;
        frontier.starting_value = start_form.reduce();
        frontier.current_time = 0;
        frontier.nodes.clear();
        
        Ok(())
    }

    /// Compute the next step with proof
    pub fn compute_next_step(&mut self) -> Result<ProofNode, CVDFError> {
        // First, compute the new leaf node
        let (leaf, needs_aggregation) = {
            let mut frontier = self.frontier.write()?;
            
            // Get previous value
            let prev_value = if frontier.current_time == 0 {
                frontier.starting_value.clone()
            } else {
                frontier.nodes
                    .get(&(0, frontier.current_time - 1))
                    .map(|n| n.value.clone())
                    .unwrap_or_else(|| frontier.starting_value.clone())
            };
            
            // Compute VDF output
            let next_value = self.class_group.repeated_squaring(
                &prev_value,
                frontier.base_difficulty,
            )?;
            
            // Generate Pietrzak proof
            let vdf_proof = PietrzakProof::generate(
                &self.class_group,
                &frontier.discriminant,
                &prev_value,
                &next_value,
                frontier.base_difficulty,
            )?;
            
            // Create leaf node with proof
            let current_time = frontier.current_time;
            let leaf = ProofNode {
                value: next_value,
                vdf_proof: Some(vdf_proof),
                time: current_time,
            };
            
            // Add to frontier
            frontier.nodes.insert((0, current_time), leaf.clone());
            frontier.current_time += 1;
            
            (leaf, true)
        }; // frontier lock is released here
        
        // Now aggregate without holding the lock
        if needs_aggregation {
            self.perform_aggregation(0)?;
        }
        
        Ok(leaf)
    }
    
    /// Perform aggregation starting from a level
    fn perform_aggregation(&self, start_level: usize) -> Result<(), CVDFError> {
        let mut frontier = self.frontier.write()?;
        Self::try_aggregate_internal(&self.class_group, &self.config, &mut frontier, start_level)
    }

    /// Internal aggregation logic (doesn't need self)
    fn try_aggregate_internal(
        class_group: &ClassGroup,
        config: &Arc<CVDFConfig>,
        frontier: &mut CVDFFrontier,
        level: usize,
    ) -> Result<(), CVDFError> {
        let k = frontier.arity;
        let mut start_index = 0;
        let mut parents_to_add = Vec::new();
        
        loop {
            // Check if we have k consecutive nodes
            let mut has_all = true;
            for i in 0..k {
                if !frontier.nodes.contains_key(&(level, start_index + i)) {
                    has_all = false;
                    break;
                }
            }
            
            if !has_all {
                break;
            }
            
            // Collect children
            let mut children = Vec::new();
            for i in 0..k {
                let child = frontier.nodes
                    .get(&(level, start_index + i))
                    .ok_or(CVDFError::InvalidStateTransition)?
                    .clone();
                children.push(child);
            }
            
            // Compute aggregate
            let mut aggregate = QuadraticForm::identity(&config.discriminant);
            for (i, child) in children.iter().enumerate() {
                let challenge = CVDFProof::generate_node_challenge(
                    &child,
                    level,
                    start_index + i,
                    &config.discriminant,
                    config.security_param,
                );
                let powered = class_group.pow(&child.value, &challenge)?;
                aggregate = class_group.compose(&aggregate, &powered)?;
            }
            
            // Create parent node (no VDF proof needed for internal nodes)
            let parent = ProofNode {
                value: aggregate.reduce(),
                vdf_proof: None,
                time: children[0].time,
            };
            
            // Store parent to add later
            let parent_index = start_index / k;
            parents_to_add.push(((level + 1, parent_index), parent));
            
            start_index += k;
        }
        
        // Add all parents at once
        for ((l, idx), parent) in parents_to_add {
            frontier.nodes.insert((l, idx), parent);
        }
        
        // Recursively aggregate higher levels
        if start_index > 0 && level < 20 {
            Self::try_aggregate_internal(class_group, config, frontier, level + 1)?;
        }
        
        Ok(())
    }

    /// Generate a verifiable proof for the current computation
    pub fn generate_proof(&self) -> Result<CVDFProof, CVDFError> {
        let frontier = self.frontier.read()?;
        Ok(frontier.generate_proof())
    }

    /// Verify a proof (static method)
    pub fn verify_proof(
        proof: &CVDFProof,
        config: &CVDFConfig,
        starting_value: &QuadraticForm,
    ) -> Result<bool, CVDFError> {
        let class_group = ClassGroup::new(config.discriminant.clone());
        proof.verify(
            &class_group,
            &config.discriminant,
            starting_value,
            config.base_difficulty,
            config.security_param,
        )
    }

    /// Stream computation
    pub fn stream_computation(&mut self, steps: usize) -> Result<Vec<ProofNode>, CVDFError> {
        let mut results = Vec::new();
        for _ in 0..steps {
            let node = self.compute_next_step()?;
            results.push(node);
        }
        Ok(results)
    }

    /// Get progress
    pub fn get_progress(&self) -> Result<(usize, usize), CVDFError> {
        let frontier = self.frontier.read()?;
        Ok((frontier.current_time, frontier.nodes.len()))
    }

    /// Export/import for handoff
    pub fn export_state(&self) -> Result<Vec<u8>, CVDFError> {
        let frontier = self.frontier.read()?;
        frontier.checkpoint()
    }

    pub fn import_state(&mut self, data: &[u8]) -> Result<(), CVDFError> {
        let imported = CVDFFrontier::from_checkpoint(data)?;
        let mut frontier = self.frontier.write()?;
        *frontier = imported;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_proof_generation_and_verification() {
        let config = CVDFConfig {
            tree_arity: 2,
            base_difficulty: 2,
            ..CVDFConfig::default()
        };
        
        let mut streamer = CVDFStreamer::new(config.clone());
        let starting = QuadraticForm::identity(&config.discriminant);
        streamer.initialize(starting.clone()).unwrap();
        
        // Compute some steps
        streamer.stream_computation(4).unwrap();
        
        // Generate proof
        let proof = streamer.generate_proof().unwrap();
        assert_eq!(proof.total_time, 4);
        
        // Verify proof
        let is_valid = CVDFStreamer::verify_proof(&proof, &config, &starting).unwrap();
        assert!(is_valid, "Proof should be valid");
    }

    #[test]
    fn test_pietrzak_proof() {
        let disc = Discriminant::generate(256).unwrap();
        let cg = ClassGroup::new(disc.clone());
        let g = QuadraticForm::identity(&disc);
        
        // Compute y = g^(2^8)
        let y = cg.repeated_squaring(&g, 8).unwrap();
        
        // Generate and verify proof
        let proof = PietrzakProof::generate(&cg, &disc, &g, &y, 8).unwrap();
        let is_valid = proof.verify(&cg, &disc, &g, &y, 8).unwrap();
        assert!(is_valid, "Pietrzak proof should be valid");
    }

    #[test]
    fn test_aggregation_verification() {
        let config = CVDFConfig {
            tree_arity: 4,
            base_difficulty: 2,
            ..CVDFConfig::default()
        };
        
        let mut streamer = CVDFStreamer::new(config.clone());
        let starting = QuadraticForm::identity(&config.discriminant);
        
        // Compute enough for aggregation
        streamer.stream_computation(8).unwrap();
        
        let proof = streamer.generate_proof().unwrap();
        
        // Should have nodes at multiple levels
        let max_level = proof.proof_path.keys()
            .map(|(l, _)| *l)
            .max()
            .unwrap_or(0);
        assert!(max_level >= 1, "Should have aggregated to higher levels");
        
        // Verify the aggregated proof
        let is_valid = CVDFStreamer::verify_proof(&proof, &config, &starting).unwrap();
        assert!(is_valid, "Aggregated proof should be valid");
    }
}