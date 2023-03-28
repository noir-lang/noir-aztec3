use crate::abi;
use crate::note::Note;
use crate::vec::BoundedVec;

struct Context {
    public_inputs: abi::PublicInputs,
    // new_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_COMMITMENTS
    // nullified_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_NULLIFIERS

    new_note_values: BoundedVec<Field, 5>,
    new_note_owners: BoundedVec<Field, 5>,
    new_note_randomness: BoundedVec<Field, 5>,
    new_note_nonce: BoundedVec<Field, 5>,
    new_note_is_dummies: BoundedVec<Field, 5>,

    nullified_note_values: BoundedVec<Field, 5>,
    nullified_note_owners: BoundedVec<Field, 5>,
    nullified_note_randomness: BoundedVec<Field, 5>,
    nullified_note_nonce: BoundedVec<Field, 5>,
    nullified_note_is_dummies: BoundedVec<Field, 5>,
}

impl Context {
    fn new(public_inputs: abi::PublicInputs) -> Context {
        Context {
            public_inputs,

            new_note_values: BoundedVec::new(0),
            new_note_owners: BoundedVec::new(0),
            new_note_randomness: BoundedVec::new(0),
            new_note_nonce: BoundedVec::new(0),
            new_note_is_dummies: BoundedVec::new(0),

            nullified_note_values: BoundedVec::new(0),
            nullified_note_owners: BoundedVec::new(0),
            nullified_note_randomness: BoundedVec::new(0),
            nullified_note_nonce: BoundedVec::new(0),
            nullified_note_is_dummies: BoundedVec::new(0),
        }
    }

    fn push_new_note_hash(mut self: Self, _note_hash: Field) -> Self {
        // self.public_inputs.new_commitments = self.public_inputs.new_commitments.push(note_hash);
        self
    }

    fn push_new_nullifier(mut self: Self, _nullifier: Field) -> Self {
        // self.public_inputs.new_nullifiers = self.public_inputs.new_nullifiers.push(nullifier);
        self
    }

    fn push_new_note(mut self: Self, _note: Note) -> Self {
        // self.new_notes = self.new_notes.push(note);
        self
    }

    fn push_nullified_note(mut self: Self, _note: Note) -> Self {
        // self.nullified_notes = self.nullified_notes.push(note);
        self
    }
}
