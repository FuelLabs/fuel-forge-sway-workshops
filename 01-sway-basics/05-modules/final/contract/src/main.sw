contract;

pub mod default;
mod count;

use ::count::*;

abi Counter {
    #[storage(read, write)]
    fn inc();
    #[storage(read, write)]
    fn dec();
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
        match count.inc() {
            Ok(_) => storage.count.write(count.val()),
            Err(err) => panic err,
        }
    }

    #[storage(read, write)]
    fn dec() {
        let mut count = Count::from(storage.count.read());
        match count.dec() {
            Ok(_) => storage.count.write(count.val()),
            Err(err) => panic err,
        }
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

#[test(should_revert)]
fn dec_below_zero_should_revert() {
    let caller = abi(Counter, CONTRACT_ID);
    caller.dec();
}