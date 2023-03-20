use globals::{Domains, TREE_HEIGHT};
use execution_context::{ExecutionContext};
// use public_inputs::{PUBLIC_INPUTS};
use note::Note;

// Data returned when getting a note
struct NoteGetterData {
    note: Note,
    leaf_index: Field,
    sibling_path: [Field; TREE_HEIGHT],
    root: Field,
}

struct Set {
    storage_slot: Field,
}

impl Set {
    fn new(storage_slot: Field) -> Set {
        Set { storage_slot }
    }
    
    fn insert(self, mut exec_ctx: ExecutionContext, note: Note) {
        let contract_address = exec_ctx.public_inputs.call_context.storage_contract_address;
        let storage_slot = self.storage_slot;

        let note_hash = note.compute_note_hash();
        let siloed_note_hash = pedersen(
            Domains.NoteStorageSlot,
            [note_hash, storage_slot, contract_address]
        );

        exec_ctx.push_new_note_hash(siloed_note_hash);
        exec_ctx.push_new_note(note);
    }
    
    
    // The `2` in the name is the number of notes returned
    fn get_2(self, mut exec_ctx: ExecutionContext) -> [Note; 2] {
        let contract_address: Field = exec_ctx.public_inputs.call_context.storage_contract_address;
        let storage_slot = self.storage_slot;

        let note_getter_data: [NoteGetterData; 2] = ORACLE::get_2_notes(contract_address, storage_slot);
        
        let note_getter_data: [NoteGetterData; 2] <- 
        
        for i in 0..2 {
            let NoteGetterData { note, leaf_index, sibling_path, root } = note_getter_data[i];

            let note_hash = note.compute_note_hash();
            let siloed_note_hash = pedersen(
                Domains.NoteStorageSlot,
                [note_hash, storage_slot, contract_address]
            );

            // Check existence in tree:
            // (Not sure what methods noir has, we can probably use whatever those are)
            let check_root = compute_merkle_root(
                siloed_note_hash,
                leaf_index,
                sibling_path,
            );

            constrain root == check_root;

            // Set the public input of the 'old private data tree root' to be the computed root (if it hasn't already been set); otherwise constrain equality with the previously-set value.
            if exec_ctx.public_inputs.old_private_data_tree_root == 0 {
                exec_ctx.public_inputs.old_private_data_tree_root = root;
            } else {
                constrain exec_ctx.public_inputs.old_private_data_tree_root == root;
            }
        }

        [note_getter_data[0].note, note_getter_data[1].note]
    }
    
    
    fn remove(self, mut exec_ctx: ExecutionContext, note: Note) {
        let contract_address: Field = exec_ctx.public_inputs.call_context.storage_contract_address;
        let storage_slot = set.storage_slot;

        let note_hash = note.compute_note_hash();
        let siloed_note_hash = pedersen(
            Domains.NoteStorageSlot,
            [note_hash, storage_slot, contract_address]
        );

        let nullifier = note.compute_nullifier(siloed_note_hash);

        exec_ctx.push_new_nullifier(nullifier);
        exec_ctx.push_nullified_note(note);
    }
    
}
