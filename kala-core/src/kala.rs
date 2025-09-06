use kala_common::prelude::KalaResult;
use kala_common::types::NodeId;
use kala_state::{KalaState, StateManager, TickPhase};
use kala_tick::{CVDFConfig, CVDFStreamer, QuadraticForm};
use std::collections::BTreeMap;
use std::sync::Arc;
use tokio::sync::watch;
use tokio::task::JoinHandle;

//Heres the flow -
//I need to impl the following
//1. the cvdf watcher to advance the clock
//2. update the state accordingly
//3. need to handle the data streams from client too
/// Core handler
pub struct KalaApp {
    pub state_manager: StateManager,
    pub cvdf_streamer: CVDFStreamer,
}

impl KalaApp {
    pub async fn new(db_path:&str, chain_id: NodeId, witness_ids: Vec<NodeId>) -> KalaResult<Self> {
        let state_manager = StateManager::new(db_path, chain_id, witness_ids).await?;
        let cvdf_streamer = CVDFStreamer::new(CVDFConfig::default());
        
        Ok(KalaApp {
            state_manager: state_manager,
            cvdf_streamer: cvdf_streamer,
        })

    }

    pub async fn start_tick(&mut self) -> KalaResult<()> {
        let mut state = self.state_manager.get_state_mut();
        state.cvdf_proof_cache = BTreeMap::new();
        let (tx, rx) = watch::channel(self.cvdf_streamer);

        for i in 1..=state.k_iterations {
            if state.current_iteration == state.collection_phase_end {
                //Get the consensus of witness from other nodes for the txs
                state.current_phase = TickPhase::Consensus;
                //TODO: imo we move all pending txs to new store
            }
            else if state.current_iteration >= state.consensus_phase_end {
                //Move to the decryption phase
                state.current_phase = TickPhase::Decryption;
            }
            else if state.current_iteration > state.consensus_phase_end + state.rsw_hardness + 1000 && state.current_iteration < state.k_iterations{
                //Move to the finalizatino
                state.current_phase = TickPhase::StateUpdate;
            }
            let current_form = state.cvdf_current_form;
            let result = self.cvdf_streamer.compute_single_step(&current_form)?;
            //update the current iteration
            state.current_iteration += 1;
            state.total_iterations += 1;  
            //update the form          
            state.cvdf_current_form = result.output;
            state.cvdf_proof_cache.insert(state.current_iteration, result.proof.proof_data);
        }
        state.current_phase = TickPhase::Finalization;


        Ok(())
    }
}
