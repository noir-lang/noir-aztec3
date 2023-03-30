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

    new_notes: [Note; 5],
    nullified_notes: [Note; 5],
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

    new_notes: BoundedVec<Note, MAX_NEW_COMMITMENTS>,
    nullified_notes: BoundedVec<Note, MAX_NEW_NULLIFIERS>,
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
            return_values: BoundedVec::new(),
            logs: BoundedVec::new(),

            new_commitments: BoundedVec::new(),
            new_nullifiers: BoundedVec::new(),

            private_call_stack: BoundedVec::new(),
            public_call_stack: BoundedVec::new(),
            l1_message_stack: BoundedVec::new(),

            old_private_data_tree_root: 0,

            new_notes: BoundedVec::new(),
            nullified_notes: BoundedVec::new(),
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

            new_notes: self.new_notes.storage,
            nullified_notes: self.nullified_notes.storage,
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
        self.new_notes = self.new_notes.push(note);
        self
    }

    fn push_nullified_note(mut self: Self, note: Note) -> Self {
        self.nullified_notes = self.nullified_notes.push(note);
        self
    }
}
