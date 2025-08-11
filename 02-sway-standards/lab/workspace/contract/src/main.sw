contract;

use count::count::*;
use std::storage::storage_map::*;

abi Counter {
    #[storage(read, write)]
    fn inc();
    #[storage(read, write)]
    fn dec();
    #[storage(read)]
    fn count() -> u64;
}

storage {
    counts: StorageMap<Identity, u64> = StorageMap {},
}

impl Counter for Contract {
    #[storage(read, write)]
    fn inc() {
        let sender = msg_sender().unwrap();
        let mut count = Count::from(storage.counts.get(sender).try_read().unwrap_or(0));
        match count.inc() {
            Ok(_) => storage.counts.insert(sender, count.val()),
            Err(err) => panic err,
        }
    }

    #[storage(read, write)]
    fn dec() {
        let sender = msg_sender().unwrap();
        let mut count = Count::from(storage.counts.get(sender).try_read().unwrap_or(0));
        match count.dec() {
            Ok(_) => storage.counts.insert(sender, count.val()),
            Err(err) => panic err,
        }
    }

    #[storage(read)]
    fn count() -> u64 {
        let sender = msg_sender().unwrap();
        let count = Count::from(storage.counts.get(sender).try_read().unwrap_or(0));
        count.val()
    }
}

#[test]
fn initial_count_is_zero() {
    let caller = abi(Counter, CONTRACT_ID);
    assert_eq(caller.count(), 0);
}

#[test]
fn inc_two_times() {
    let caller = abi(Counter, CONTRACT_ID);
    caller.inc();
    caller.inc();
    assert_eq(caller.count(), 2);
}

#[test]
fn inc_and_dec() {
    let caller = abi(Counter, CONTRACT_ID);
    caller.inc();
    caller.dec();
    assert_eq(caller.count(), 0);
}
