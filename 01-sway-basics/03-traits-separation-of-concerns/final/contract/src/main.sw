contract;

trait Default {
    fn default() -> Self;
}

struct Count {
    val: u64,
}

impl Count {
    pub fn inc(ref mut self) {
        self.val += 1;
    }

    pub fn val(self) -> u64 {
        self.val
    }
}

impl Default for Count {
    fn default() -> Self {
        Self {
            val: 0,
        }
    }
}

impl From<u64> for Count {
    fn from(val: u64) -> Self {
        Self {
            val,
        }
    }
}

abi Counter {
    #[storage(read, write)]
    fn inc();
    #[storage(read)]
    fn count() -> u64;
}

storage {
    count: u64 = 0,
}

impl Counter for Contract {
    #[storage(read, write)]
    fn inc() {
        let mut count = Count::from(storage.count.read());
        count.inc();
        storage.count.write(count.val());
    }

    #[storage(read)]
    fn count() -> u64 {
        let count = Count::from(storage.count.read());
        count.val()
    }
}

#[test]
fn initial_count_is_zero() {
    let caller = abi(Counter, CONTRACT_ID);
    assert_eq(caller.count(), 0);
}