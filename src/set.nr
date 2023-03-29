use crate::abi::Inputs;
use crate::abi::IntermediateOutputs;
use crate::note::Note;
use crate::note::Point;

// Data returned when getting a note
struct NoteGetterData {
    note: Note,
    leaf_index: Field,
    sibling_path: [Field; crate::TREE_HEIGHT],
    root: Field,
}

struct Set {
    storage_slot: Field,
}

impl Set {
    fn new(storage_slot: Field) -> Set {
        Set { storage_slot }
    }

    fn insert(self, inputs: Inputs, mut outputs: IntermediateOutputs, note: Note) -> IntermediateOutputs {
        let contract_address = inputs.call_context.storage_contract_address;
        let storage_slot = self.storage_slot;

        let note_hash = note.compute_note_hash();
        let siloed_note_hash = dep::std::hash::pedersen([
            crate::NoteStorageSlot,
            note_hash, 
            storage_slot, 
            contract_address,
        ])[0];

        outputs = outputs.push_new_note_hash(siloed_note_hash);
        outputs.push_new_note(note)
    }

    // The `2` in the name is the number of notes returned
    fn get_2(self, inputs: Inputs, mut outputs: IntermediateOutputs) -> (IntermediateOutputs, [Note; 2]) {
        let contract_address = inputs.call_context.storage_contract_address;
        let storage_slot = self.storage_slot;

        // let note_getter_data: [NoteGetterData; 2] = ORACLE::get_2_notes(contract_address, storage_slot);
        let note_getter_data = [
            NoteGetterData { note: Note::dummy(), leaf_index: 0, sibling_path: [1, 2, 3, 4, 5], root: 1 },
            NoteGetterData { note: Note::dummy(), leaf_index: 1, sibling_path: [1, 2, 3, 4, 5], root: 1 },
        ];

        for data in note_getter_data {
            let NoteGetterData { note, leaf_index, sibling_path, root } = data;
            let _ignored = sibling_path;

            let note_hash = note.compute_note_hash();
            let siloed_note_hash = dep::std::hash::pedersen([
                crate::NoteStorageSlot,
                note_hash, 
                storage_slot, 
                contract_address
            ])[0];

            // Check existence in tree:
            // (Not sure what methods noir has, we can probably use whatever those are)
            // let check_root = compute_merkle_root(
            //     siloed_note_hash,
            //     leaf_index,
            //     sibling_path,
            // );
            let check_root = siloed_note_hash + leaf_index;

            constrain root == check_root;

            // Set the public input of the 'old private data tree root' to be the computed root (if it hasn't already been set); otherwise constrain equality with the previously-set value.
            if outputs.old_private_data_tree_root == 0 {
                outputs.old_private_data_tree_root = root;
            } else {
                constrain outputs.old_private_data_tree_root == root;
            }
        }

        let notes = note_getter_data.map(|data: NoteGetterData| data.note);
        (outputs, notes)
    }


    fn remove(self, inputs: Inputs, mut outputs: IntermediateOutputs, note: Note) -> IntermediateOutputs {
        let contract_address = inputs.call_context.storage_contract_address;
        let storage_slot = self.storage_slot;

        let note_hash = note.compute_note_hash();
        let siloed_note_hash = dep::std::hash::pedersen([
            crate::NoteStorageSlot,
            note_hash,
            storage_slot,
            contract_address,
        ])[0];

        let nullifier = note.compute_nullifier(siloed_note_hash);

        outputs = outputs.push_new_nullifier(nullifier);
        outputs.push_nullified_note(note)
    }
}
