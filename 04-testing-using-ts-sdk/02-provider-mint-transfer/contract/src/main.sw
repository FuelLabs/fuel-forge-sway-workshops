contract;

use std::identity::Identity;
use std::asset_id::AssetId;

abi MintAndTransfer {
    fn mint_default_asset(amount: u64);
    fn transfer_default_asset_to(identity: Identity, amount: u64);
}

impl MintAndTransfer for Contract {
    fn mint_default_asset(amount: u64) {
        std::asset::mint(SubId::zero(), amount);
    }

    fn transfer_default_asset_to(identity: Identity, amount: u64) {
        std::asset::transfer(identity, AssetId::default(), amount);
    }
}
