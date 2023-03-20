use crate::aztec3;
use crate::aztec3::abi;
use crate::aztec3::note::Note;

struct Context {
    public_inputs: abi::PublicInputs,
    new_notes: [Note, abi::MAX_NEW_COMMITMENTS],
    nullified_notes: [Note, abi::MAX_NEW_NULLIFIERS],
}

impl Context {
    fn new(public_inputs: abi::PUBLIC_INPUTS) -> Context {
        Context {
            public_inputs,
            new_notes: [Note::zeroed(); abi::MAX_NEW_COMMITMENTS],
            nullified_notes: [Note::zeroed(); abi::MAX_NEW_NULLIFIERS],
        }
    }
    
    fn push_new_note_hash(self, note_hash: Field) -> () {
        self.public_inputs.new_commitments.push(note_hash);
    }

    fn push_new_nullifier(self, nullifier: Field) -> () {
        self.public_inputs.new_nullifiers.push(nullifier);
    }

    fn push_new_note(self, note: Note) {
        self.new_notes.push(note);
    }

    fn push_nullified_note(self, note: Note) -> () {
        self.nullified_notes.push(note);
    }
}
