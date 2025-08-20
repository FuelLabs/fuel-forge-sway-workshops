contract;

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
        let new_count = storage.counts.get(sender).try_read().unwrap_or(0) + 1;
        storage.counts.insert(sender, new_count);
    }

    #[storage(read, write)]
    fn dec() {
        let sender = msg_sender().unwrap();
        let new_count = storage.counts.get(sender).try_read().unwrap_or(0) - 1;
        storage.counts.insert(sender, new_count);
    }

    #[storage(read)]
    fn count() -> u64 {
        let sender = msg_sender().unwrap();
        storage.counts.get(sender).try_read().unwrap_or(0)
    }
}
