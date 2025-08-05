contract;

pub mod default;
mod count;

use ::count::*;
use std::storage::storage_vec::*;

abi Counter {
    /// Creates a new counter and returns its index.
    #[storage(read, write)]
    fn new() -> u64;
    #[storage(read)]
    fn num_of_counters() -> u64;

    #[storage(read, write)]
    fn inc(index: u64);
    #[storage(read, write)]
    fn dec(index: u64);
    #[storage(read)]
    fn count(index: u64) -> u64;
}

storage {
    counts: StorageVec<u64> = StorageVec {},
}

struct NonExistingCounter {
    requested_index: u64,
    max_index: u64,
}

#[error_type]
enum CounterError {
    #[error(m = "Counter ")]
    NonExistingCounter: NonExistingCounter,
}

impl Counter for Contract {
    #[storage(read, write)]
    fn new() -> u64 {
        storage.counts.push(0);
        storage.counts.len()
    }

    #[storage(read)]
    fn num_of_counters() -> u64 {
        storage.counts.len()
    }

    #[storage(read, write)]
    fn inc(index: u64) {
        let mut count = get_count_at_index(index);
        match count.inc() {
            Ok(_) => storage.counts.set(index, count.val()),
            Err(err) => panic err,
        }
    }

    #[storage(read, write)]
    fn dec(index: u64) {
        let mut count = get_count_at_index(index);
        match count.dec() {
            Ok(_) => storage.counts.set(index, count.val()),
            Err(err) => panic err,
        }
    }

    #[storage(read)]
    fn count(index: u64) -> u64 {
        let count = get_count_at_index(index);
        count.val()
    }
}

#[storage(read)]
fn get_count_at_index(index: u64) -> Count {
    match storage.counts.get(index) {
        Some(val) => Count::from(val.read()),
        None => {
            panic CounterError::NonExistingCounter(NonExistingCounter {
                requested_index: index,
                max_index: storage.counts.len()
            });
        }
    }
}

#[test]
fn initial_count_is_zero() {
    let caller = abi(Counter, CONTRACT_ID);
    let _ = caller.new();
    assert_eq(caller.count(0), 0);
}

#[test(should_revert)]
fn dec_below_zero_should_revert() {
    let caller = abi(Counter, CONTRACT_ID);
    let _ = caller.new();
    caller.dec(0);
}