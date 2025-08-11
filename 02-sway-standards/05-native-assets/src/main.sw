contract;

use std::asset::*;
use std::identity::Identity;

abi NativeAssetsDemo {
    fn mint_default_asset(amount: u64);
    fn burn_default_asset(amount: u64);
    fn mint_other_asset(amount: u64);
    fn burn_other_asset(amount: u64);
    fn get_balances() -> (u64, u64);
    fn transfer_default_asset(to: Identity);
}

const OTHER_ASSET_SUB_ID: SubId = 0x1d5d97005e41cae2187a895fd8eab0506111e0e2f3331cd3912c15c24e3c1d82;

impl NativeAssetsDemo for Contract {
    fn mint_default_asset(amount: u64) {
        mint(SubId::zero(), amount);
    }

    fn burn_default_asset(amount: u64) {
        burn(SubId::zero(), amount);
    }

    fn mint_other_asset(amount: u64) {
        mint(OTHER_ASSET_SUB_ID, amount);
    }

    fn burn_other_asset(amount: u64) {
        burn(OTHER_ASSET_SUB_ID, amount);
    }

    fn get_balances() -> (u64, u64) {
        let default_asset_balance = std::context::this_balance(AssetId::default());
        let other_asset_balance = std::context::this_balance(AssetId::new(ContractId::this(), OTHER_ASSET_SUB_ID));

        (default_asset_balance, other_asset_balance)
    }

    fn transfer_default_asset(to: Identity) {
        let default_asset_balance = std::context::this_balance(AssetId::default());
        if default_asset_balance > 1 {
            transfer(to, AssetId::default(), 1);
        }
    }
}

#[test]
fn mint_and_burn_default_asset() {
    let caller = abi(NativeAssetsDemo, CONTRACT_ID);

    caller.mint_default_asset(42);

    let balances = caller.get_balances();

    assert_eq(balances, (42, 0));

    caller.burn_default_asset(10);

    let balances = caller.get_balances();

    assert_eq(balances, (32, 0));
}

#[test]
fn transfer_default_asset_to_self() {
    let caller = abi(NativeAssetsDemo, CONTRACT_ID);

    caller.mint_default_asset(42);

    let balances = caller.get_balances();

    assert_eq(balances, (42, 0));

    caller.transfer_default_asset(Identity::ContractId(ContractId::from(CONTRACT_ID)));

    let balances = caller.get_balances();

    assert_eq(balances, (42, 0));
}
