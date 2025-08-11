contract;

use std::execution::run_external;
use src14::{SRC14, SRC14_TARGET_STORAGE};

storage {
    SRC14 {
        target in SRC14_TARGET_STORAGE: ContractId = ContractId::zero(),
    },
}

impl SRC14 for Contract {
    #[storage(read, write)]
    fn set_proxy_target(new_target: ContractId) {
        storage::SRC14.target.write(new_target);
    }

    #[storage(read)]
    fn proxy_target() -> Option<ContractId> {
        storage::SRC14.target.try_read()
    }
}

#[fallback]
#[storage(read)]
fn fallback() {
    run_external(storage::SRC14.target.read())
}
