use crate::aztec3;
use crate::aztec3::abi;
use crate::aztec3::note::Note;

struct Context {
    public_inputs: abi::PublicInputs,
    new_notes: BoundedVec<Note, abi::MAX_NEW_COMMITMENTS>,
    nullified_notes: BoundedVec<Note, abi::MAX_NEW_NULLIFIERS>,
}

impl Context {
    fn new(public_inputs: abi::PUBLIC_INPUTS) -> Context {
        Context {
            public_inputs,
            new_notes: BoundedVec::new(Note::new_dummy()),
            nullified_notes: BoundedVec::new(Note::new_dummy()),
        }
    }

    fn push_new_note_hash(mut self, note_hash: Field) -> Self {
        self.public_inputs.new_commitments = self.public_inputs.new_commitments.push(note_hash);
        self
    }

    fn push_new_nullifier(mut self, nullifier: Field) -> Self {
        self.public_inputs.new_nullifiers = self.public_inputs.new_nullifiers.push(nullifier);
    }

    fn push_new_note(mut self, note: Note) -> Self {
        self.new_notes = self.new_notes.push(note);
    }

    fn push_nullified_note(mut self, note: Note) -> Self {
        self.nullified_notes = self.nullified_notes.push(note);
    }
}
