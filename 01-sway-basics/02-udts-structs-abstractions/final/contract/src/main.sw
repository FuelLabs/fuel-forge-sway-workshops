contract;

struct Count {
    val: u64,
}

impl Count {
    pub fn default() -> Self {
        Self {
            val: 0,
        }
    }

    pub fn inc(ref mut self) {
        self.val += 1;
    }

    pub fn val(self) -> u64 {
        self.val
    }
}

abi Counter {
    #[storage(read, write)]
    fn inc();
    #[storage(read)]
    fn count() -> Count;
}

storage {
    count: Count = Count::default(),
}

impl Counter for Contract {
    #[storage(read, write)]
    fn inc() {
        let mut count = storage.count.read();
        count.inc();
        storage.count.write(count);
    }

    #[storage(read)]
    fn count() -> Count {
        storage.count.read()
    }
}

#[test]
fn initial_count_is_zero() {
    let caller = abi(Counter, CONTRACT_ID);
    assert_eq(caller.count().val(), 0);
}