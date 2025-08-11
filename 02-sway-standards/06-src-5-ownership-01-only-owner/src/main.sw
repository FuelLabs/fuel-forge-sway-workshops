contract;

use src5::*;
use ownership::*;

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

abi SomeAbi {
    #[storage(read)]
    fn withdraw_assets();
}

impl SomeAbi for Contract {
    #[storage(read)]
    fn withdraw_assets() {
        only_owner();

        // Withdrawal logic comes here, after the ownership check.
    }
}

#[test]
fn initial_owner_is_not_set_in_test() {
    let caller = abi(SRC5, CONTRACT_ID);
    let owner = caller.owner();
    let _ = __dbg(owner);
}

#[test]
fn withdraw_assets_without_owner_rights() {
    let caller = abi(SomeAbi, CONTRACT_ID);
    caller.withdraw_assets();
}