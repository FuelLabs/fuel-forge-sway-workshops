// Additional exercises:
// - Implement a `dec` and `reset` contract methods for decreasing and resetting the counter to zero, respectively.
// - Implement additional test cases. E.g., `inc_increases_counter_for_one`.

contract;

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
        let count = storage.count.read() + 1;
        storage.count.write(count);
    }

    #[storage(read)]
    fn count() -> u64 {
        storage.count.read()
    }
}

#[test]
fn initial_count_is_zero() {
    let caller = abi(Counter, CONTRACT_ID);
    assert_eq(caller.count(), 0);
}