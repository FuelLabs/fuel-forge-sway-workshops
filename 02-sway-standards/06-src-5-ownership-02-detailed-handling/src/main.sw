contract;

use ownership::{_owner, initialize_ownership, only_owner, renounce_ownership, transfer_ownership};
use src5::{SRC5, State};

configurable {
    INITIAL_OWNER: Identity = Identity::Address(Address::zero()),
}

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

abi OwnershipHandlingDemo {
    #[storage(read, write)]
    fn initialize();
    #[storage(read, write)]
    fn change_owner(new_owner: Identity);
    #[storage(read, write)]
    fn revoke_ownership();
}

impl OwnershipHandlingDemo for Contract {
    #[storage(read, write)]
    fn initialize() {
        initialize_ownership(INITIAL_OWNER);
    }

    #[storage(read, write)]
    fn change_owner(new_owner: Identity) {
        transfer_ownership(new_owner);
    }

    #[storage(read, write)]
    fn revoke_ownership() {
        renounce_ownership();
    }
}