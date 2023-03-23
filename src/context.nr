use crate::abi;
use crate::note::Note;
use crate::vec::BoundedVec;

struct Context {
    public_inputs: abi::PublicInputs,
    new_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_COMMITMENTS
    nullified_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_NULLIFIERS
}

impl Context {
    fn new(public_inputs: abi::PublicInputs) -> Context {
        Context {
            public_inputs,
            new_notes: BoundedVec::new(Note::dummy()),
            nullified_notes: BoundedVec::new(Note::dummy()),
        }
    }

    fn push_new_note_hash(mut self: Self, note_hash: Field) -> Self {
        self.public_inputs.new_commitments = self.public_inputs.new_commitments.push(note_hash);
        self
    }

    fn push_new_nullifier(mut self: Self, nullifier: Field) -> Self {
        self.public_inputs.new_nullifiers = self.public_inputs.new_nullifiers.push(nullifier);
        self
    }

    fn push_new_note(mut self: Self, note: Note) -> Self {
        self.new_notes = self.new_notes.push(note);
        self
    }

    fn push_nullified_note(mut self: Self, note: Note) -> Self {
        self.nullified_notes = self.nullified_notes.push(note);
        self
    }
}
