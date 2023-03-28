global MAX_ARGS: comptime Field = 3;
global MAX_RETURN_VALUES: comptime Field = 4;
global MAX_LOGS: comptime Field = 1;
global MAX_NEW_COMMITMENTS: comptime Field = 4;
global MAX_NEW_NULLIFIERS: comptime Field = 5;
global MAX_PRIVATE_CALL_STACK : comptime Field = 6;
global MAX_PUBLIC_CALL_STACK: comptime Field = 7;
global MAX_L1_MSG_STACK : comptime Field = 8;

use crate::vec::BoundedVec;

struct PublicInputs {
    call_context : CallContext,

    args : [Field; MAX_ARGS],
    return_values : [Field; MAX_RETURN_VALUES],
    logs : [Field; MAX_LOGS],

    new_commitments: BoundedVec<Field, 5>,//MAX_NEW_COMMITMENTS>,
    new_nullifiers: BoundedVec<Field, 5>,//MAX_NEW_NULLIFIERS>,

    private_call_stack : [Field; MAX_PRIVATE_CALL_STACK],
    public_call_stack : [Field; MAX_PUBLIC_CALL_STACK],
    l1_message_stack : [Field; MAX_L1_MSG_STACK],

    old_private_data_tree_root : Field,
    old_nullifier_tree_root : Field,
    old_contract_tree_root : Field,

    contract_deployment_data: ContractDeploymentData,
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

impl PublicInputs {
    fn empty() -> Self {
        PublicInputs::new(
            CallContext {
                msg_sender: 0,
                storage_contract_address: 0,
                portal_contract_address: 0,
                is_delegate_call: false,
                is_static_call: false,
                is_contract_deployment: false,
            },
            ContractDeploymentData {
                constructor_vk_hash: 0,
                function_tree_root: 0,
                contract_address_salt: 0,
                portal_contract_address: 0,
                hide_private_function_data: false,
            },
            [0,0,0],
        )
    }

    fn new(
        call_context: CallContext,
        contract_deployment_data: ContractDeploymentData,
        args: [Field; MAX_ARGS]
    ) -> PublicInputs {
        PublicInputs {
            call_context,
            contract_deployment_data,
            args,

            return_values: [0; MAX_RETURN_VALUES],
            logs: [0; MAX_LOGS],

            new_commitments: BoundedVec::new(0),
            new_nullifiers: BoundedVec::new(0),

            private_call_stack: [0; MAX_PRIVATE_CALL_STACK],
            public_call_stack: [0; MAX_PUBLIC_CALL_STACK],
            l1_message_stack: [0; MAX_L1_MSG_STACK],

            old_private_data_tree_root: 0,
            old_nullifier_tree_root: 0,
            old_contract_tree_root: 0,
        }
    } 
}
