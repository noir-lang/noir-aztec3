mod abi;
mod map;
mod note;
mod set;
mod vec; //This can/should be moved out into another library

global Nonce = 1;
global NoteHash = 2;
global NoteStorageSlot = 3;
global MappingStorageSlot = 4;
global Nullifier = 5;

global TREE_HEIGHT: comptime Field = 5;



#[builtin(rand)]
fn rand() -> Field {}

#[builtin(get_2_notes)]
fn get_2_notes_inner() -> [Field; 2] {} // 26 fields

#[builtin(get_n_notes)]
fn get_n_notes_inner<N>() -> [Field; N] {} // N * 13



fn make_note_getter_data(fields: [Field], start: comptime Field) -> set::NoteGetterData {
    set::NoteGetterData {
        note: note::Note {
            value: fields[start],
            owner: note::Point::new(fields[start + 1], fields[start + 2]),
            randomness: fields[start + 3],
            nonce: fields[start + 4],
            is_dummy: fields[start + 5] as bool,
        },
        leaf_index: fields[start + 6],
        // sibling_path: [Field; 5],
        sibling_path0: fields[start + 7],
        sibling_path1: fields[start + 8],
        sibling_path2: fields[start + 9],
        sibling_path3: fields[start + 10],
        sibling_path4: fields[start + 11],
        root: fields[start + 12],
    }
}

fn get_2_notes() -> (set::NoteGetterData, set::NoteGetterData) {
    let fields = get_2_notes_inner();
    let data1 = make_note_getter_data(fields, 0);
    let data2 = make_note_getter_data(fields, 13);
    (data1, data2)
}

fn get_n_notes<N>() -> [set::NoteGetterData; N] {
    let mut index = 0;
    let fields: [Field; 13 * 1024] = get_n_notes_inner();
    
    let first = make_note_getter_data(fields, 0);
    let mut array = [first; N];

    for i in 0 .. N {
        let data = make_note_getter_data(fields, index);
        array[i] = data;
    }

    array
}
