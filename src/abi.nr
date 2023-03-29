global MAX_ARGS: comptime Field = 5;
global MAX_RETURN_VALUES: comptime Field = 5;
global MAX_LOGS: comptime Field = 5;
global MAX_NEW_COMMITMENTS: comptime Field = 5;
global MAX_NEW_NULLIFIERS: comptime Field = 5;
global MAX_PRIVATE_CALL_STACK : comptime Field = 5;
global MAX_PUBLIC_CALL_STACK: comptime Field = 5;
global MAX_L1_MSG_STACK : comptime Field = 5;

use crate::note::Note;
use crate::vec::BoundedVec;

// Inputs are expected to be provided to each contract function
struct Inputs {
    call_context : CallContext,

    old_nullifier_tree_root : Field,
    old_contract_tree_root : Field,

    contract_deployment_data: ContractDeploymentData,
    args: [Field; MAX_ARGS],
}

struct CallContext {
    msg_sender : Field,
    storage_contract_address : Field,
    portal_contract_address : Field,

    is_delegate_call : bool,
    is_static_call : bool,
    is_contract_deployment: bool,
}

struct ContractDeploymentData {
    constructor_vk_hash : Field,
    function_tree_root : Field,
    contract_address_salt : Field,
    portal_contract_address : Field,
    hide_private_function_data : bool,
}

struct Outputs {
    return_values: [Field; MAX_RETURN_VALUES],
    logs: [Field; MAX_LOGS],

    new_commitments: [Field; MAX_NEW_COMMITMENTS],
    new_nullifiers: [Field; MAX_NEW_NULLIFIERS],

    private_call_stack: [Field; MAX_PRIVATE_CALL_STACK],
    public_call_stack: [Field; MAX_PUBLIC_CALL_STACK],
    l1_message_stack: [Field; MAX_L1_MSG_STACK],

    old_private_data_tree_root: Field,

    new_note_values: [Field; 5],
    new_note_owner_xs: [Field; 5],
    new_note_owner_ys: [Field; 5],
    new_note_randomness: [Field; 5],
    new_note_nonce: [Field; 5],
    new_note_is_dummies: [bool; 5],

    nullified_note_values: [Field; 5],
    nullified_note_owner_xs: [Field; 5],
    nullified_note_owner_ys: [Field; 5],
    nullified_note_randomness: [Field; 5],
    nullified_note_nonce: [Field; 5],
    nullified_note_is_dummies: [bool; 5],
}

// Equivalent to Outputs, but uses BoundedVecs instead of arrays to
// make it easier to push onto the ends of the arrays.
// When finished, one can call .finish() to convert back to Outputs
struct IntermediateOutputs {
    return_values : BoundedVec<Field, MAX_RETURN_VALUES>,
    logs : BoundedVec<Field, MAX_LOGS>,

    new_commitments: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_nullifiers: BoundedVec<Field, MAX_NEW_NULLIFIERS>,

    private_call_stack : BoundedVec<Field, MAX_PRIVATE_CALL_STACK>,
    public_call_stack : BoundedVec<Field, MAX_PUBLIC_CALL_STACK>,
    l1_message_stack : BoundedVec<Field, MAX_L1_MSG_STACK>,

    old_private_data_tree_root : Field,

    new_note_values: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_note_owner_xs: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_note_owner_ys: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_note_randomness: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_note_nonce: BoundedVec<Field, MAX_NEW_COMMITMENTS>,
    new_note_is_dummies: BoundedVec<bool, MAX_NEW_COMMITMENTS>,

    nullified_note_values: BoundedVec<Field, MAX_NEW_NULLIFIERS>,
    nullified_note_owner_xs: BoundedVec<Field, MAX_NEW_NULLIFIERS>,
    nullified_note_owner_ys: BoundedVec<Field, MAX_NEW_NULLIFIERS>,
    nullified_note_randomness: BoundedVec<Field, MAX_NEW_NULLIFIERS>,
    nullified_note_nonce: BoundedVec<Field, MAX_NEW_NULLIFIERS>,
    nullified_note_is_dummies: BoundedVec<bool, MAX_NEW_NULLIFIERS>,
}

impl Outputs {
    // We're a bit tricky here in that we return IntermediateOutputs
    // instead of Outputs to hide this implementation detail from users
    fn new() -> IntermediateOutputs {
        IntermediateOutputs::new()
    }
}

impl IntermediateOutputs {
    fn new() -> IntermediateOutputs {
        IntermediateOutputs {
            return_values: BoundedVec::new(0),
            logs: BoundedVec::new(0),

            new_commitments: BoundedVec::new(0),
            new_nullifiers: BoundedVec::new(0),

            private_call_stack: BoundedVec::new(0),
            public_call_stack: BoundedVec::new(0),
            l1_message_stack: BoundedVec::new(0),

            old_private_data_tree_root: 0,

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

    // Convert back to Outputs so it can be returned
    fn finish(self) -> Outputs {
        Outputs {
            return_values: self.return_values.storage,
            logs: self.logs.storage,

            new_commitments: self.new_commitments.storage,
            new_nullifiers: self.new_nullifiers.storage,

            private_call_stack: self.private_call_stack.storage,
            public_call_stack: self.public_call_stack.storage,
            l1_message_stack: self.l1_message_stack.storage,

            old_private_data_tree_root: self.old_private_data_tree_root,

            new_note_values: self.new_note_values.storage,
            new_note_owner_xs: self.new_note_owner_xs.storage,
            new_note_owner_ys: self.new_note_owner_ys.storage,
            new_note_randomness: self.new_note_randomness.storage,
            new_note_nonce: self.new_note_nonce.storage,
            new_note_is_dummies: self.new_note_is_dummies.storage,

            nullified_note_values: self.nullified_note_values.storage,
            nullified_note_owner_xs: self.nullified_note_owner_xs.storage,
            nullified_note_owner_ys: self.nullified_note_owner_ys.storage,
            nullified_note_randomness: self.nullified_note_randomness.storage,
            nullified_note_nonce: self.nullified_note_nonce.storage,
            nullified_note_is_dummies: self.nullified_note_is_dummies.storage,
        }
    }

    fn push_new_note_hash(mut self: Self, note_hash: Field) -> Self {
        self.new_commitments = self.new_commitments.push(note_hash);
        self
    }

    fn push_new_nullifier(mut self: Self, nullifier: Field) -> Self {
        self.new_nullifiers = self.new_nullifiers.push(nullifier);
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
