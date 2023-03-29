use crate::abi;
use crate::note::Note;
use crate::vec::BoundedVec;

struct Context {
    public_inputs: abi::PublicInputs,
    // new_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_COMMITMENTS
    // nullified_notes: BoundedVec<Note, 5>, // 5 = abi::MAX_NEW_NULLIFIERS

    new_note_values: BoundedVec<Field, 5>,
    new_note_owner_xs: BoundedVec<Field, 5>,
    new_note_owner_ys: BoundedVec<Field, 5>,
    new_note_randomness: BoundedVec<Field, 5>,
    new_note_nonce: BoundedVec<Field, 5>,
    new_note_is_dummies: BoundedVec<bool, 5>,

    nullified_note_values: BoundedVec<Field, 5>,
    nullified_note_owner_xs: BoundedVec<Field, 5>,
    nullified_note_owner_ys: BoundedVec<Field, 5>,
    nullified_note_randomness: BoundedVec<Field, 5>,
    nullified_note_nonce: BoundedVec<Field, 5>,
    nullified_note_is_dummies: BoundedVec<bool, 5>,
}

impl Context {
    fn new(public_inputs: abi::PublicInputs) -> Context {
        Context {
            public_inputs,

            new_note_values: BoundedVec::new(0),
            new_note_owner_xs: BoundedVec::new(0),
            new_note_owner_ys: BoundedVec::new(0),
            new_note_randomness: BoundedVec::new(0),
            new_note_nonce: BoundedVec::new(0),
            new_note_is_dummies: BoundedVec::new(true),

            nullified_note_values: BoundedVec::new(0),
            nullified_note_owner_xs: BoundedVec::new(0),
            nullified_note_owner_ys: BoundedVec::new(0),
            nullified_note_randomness: BoundedVec::new(0),
            nullified_note_nonce: BoundedVec::new(0),
            nullified_note_is_dummies: BoundedVec::new(true),
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
        self.new_note_values = self.new_note_values.push(note.value);
        self.new_note_owner_xs = self.new_note_owner_xs.push(note.owner.x);
        self.new_note_owner_ys = self.new_note_owner_ys.push(note.owner.y);
        self.new_note_randomness = self.new_note_randomness.push(note.randomness);
        self.new_note_nonce = self.new_note_nonce.push(note.nonce);
        self.new_note_is_dummies = self.new_note_is_dummies.push(note.is_dummy);
        self
    }

    fn push_nullified_note(mut self: Self, note: Note) -> Self {
        self.nullified_note_values = self.nullified_note_values.push(note.value);
        self.nullified_note_owner_xs = self.nullified_note_owner_xs.push(note.owner.x);
        self.nullified_note_owner_ys = self.nullified_note_owner_ys.push(note.owner.y);
        self.nullified_note_randomness = self.nullified_note_randomness.push(note.randomness);
        self.nullified_note_nonce = self.nullified_note_nonce.push(note.nonce);
        self.nullified_note_is_dummies = self.nullified_note_is_dummies.push(note.is_dummy);
        self
    }
}
