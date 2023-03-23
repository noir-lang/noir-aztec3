use crate::set::Set;

struct Map {
    base_storage_slot: Field,
}

impl Map {
    fn new(base_storage_slot: Field) -> Map {
        Map { base_storage_slot }
    }

    fn at(self, key: Field) -> Set {
        let derived_storage_slot = dep::std::hash::pedersen([
            crate::MappingStorageSlot, 
            self.base_storage_slot, 
            key
        ])[0];

        Set::new(derived_storage_slot)
    }
}
