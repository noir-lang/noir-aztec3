
struct BoundedVec<T, MaxLen> {
    storage: [T; MaxLen],
    len: Field,
}

impl<T, MaxLen> BoundedVec<T, MaxLen> {
    fn new(initial_value: T) -> Self {
        BoundedVec { storage: [initial_value; MaxLen] }
    }

    fn get(self, index: Field) -> T {
        constrain index < self.len;
        self.storage[index]
    }

    fn push(mut self, elem: T) -> Self {
        constrain self.len < MaxLen;

        self.storage[self.len] = elem;
        self.len += 1;
        self
    }

    fn pop(mut self) -> (Self, T) {
        constrain self.len > 0;

        let elem = self.storage[self.len - 1];
        self.len -= 1;
        (self, elem)
    }
}
