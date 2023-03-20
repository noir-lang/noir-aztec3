use crate::aztec3;
use crate::aztec3::set::Set;

struct Map {
    base_storage_slot: Field;
}

impl Map {
    fn new(base_storage_slot: Field) -> Map {
        Map { base_storage_slot }
    }

    fn at(self, key: Field) -> Set {
        let derived_storage_slot = pedersen(
            Domains.MappingStorageSlot,
            [self.base_storage_slot, key]
        );

        Set::new(derived_storage_slot)
    }
}
