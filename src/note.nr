use crate::aztec3;

global KEY_GENERATOR = Point { x: 1234, y: 5678 }; // would need to be some valid generator point.

struct Note {
    value: Field,
    owner: Point,
    randomness: Field,
    nonce: Field,
    is_dummy: bool
}

impl Note {
    fn new(value: Field, owner: Point) -> Note {
        let randomness = ORACLE::rand(); // ORACLE CALL
        let nonce = ORACLE::rand(); // ORACLE CALL (nonce not secure: would need to be better in production).

        Note {
            value,
            owner,
            randomness,
            nonce,
            is_dummy: false,
        }
    }

    fn compute_note_hash(self) -> Field {
        pedersen([
            aztec3::NoteHash,
            self.value, 
            self.owner.x, 
            self.owner.y,
            self.randomness, 
            self.nonce, 
            self.is_dummy.to_field()
        ])
    }

    fn compute_nullifier(self, note_hash: Field) -> Field {
        let secret_key = ORACLE::get_secret_key(self.owner); // ORACLE CALL - retrieves the secret key for a given public key.
        let check_public_key = scalar_mul(secret_key, KEY_GENERATOR); // (function not show in this doc: just assumed to exist in noir's stdlib)

        constrain check_public_key == self.owner;

        pedersen([aztec3::Nullifier, note_hash, secret_key])
    }
}
