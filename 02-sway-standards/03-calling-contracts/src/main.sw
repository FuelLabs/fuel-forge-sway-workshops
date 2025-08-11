contract;

use std::identity::Identity;
use std::asset_id::AssetId;
use std::contract_id::ContractId;

struct CallInfo {
    call_frame_ptr: u64,
    caller_is_external: bool,
    caller: Identity,
    asset_id: AssetId,
    amount: u64,
    called_contract_id: ContractId,
    base_asset_id: AssetId,
    contract_default_asset_id: AssetId,
}

impl CallInfo {
    fn this_call() -> Self {
        let call_frame_ptr = std::registers::frame_ptr();
        let call_frame_ptr = asm(ptr: call_frame_ptr) { ptr: u64 };

        Self {
            call_frame_ptr,
            caller_is_external: std::auth::caller_is_external(),
            caller: std::auth::msg_sender().unwrap(),
            asset_id: std::call_frames::msg_asset_id(),
            amount: std::context::msg_amount(),
            called_contract_id: ContractId::this(),
            base_asset_id: AssetId::base(),
            contract_default_asset_id: AssetId::default(),
        }
    }
}

abi CallingContracts {
    fn non_payable_call() -> CallInfo;

    #[payable]
    fn payable_call() -> CallInfo;

    fn mint_default_asset(amount: u64);

    fn call_non_payable_call_on_self() -> CallInfo;
    fn call_payable_call_on_self(coins: u64) -> CallInfo;
    fn call_payable_call_on_self_with_gas_limit(coins: u64, gas: u64) -> CallInfo;
}

impl CallingContracts for Contract {
    fn non_payable_call() -> CallInfo {
        CallInfo::this_call()
    }

    #[payable]
    fn payable_call() -> CallInfo {
        CallInfo::this_call()
    }

    fn mint_default_asset(amount: u64) {
        std::asset::mint(SubId::zero(), amount);
    }

    fn call_non_payable_call_on_self() -> CallInfo {
        let _ = __dbg(CallInfo::this_call());
        let caller = abi(CallingContracts, ContractId::this().bits());
        caller.non_payable_call()
    }

    fn call_payable_call_on_self(coins: u64) -> CallInfo {
        let caller = abi(CallingContracts, ContractId::this().bits());
        caller.payable_call {
            coins,
            asset_id: AssetId::default().bits()
        } ()
    }

    fn call_payable_call_on_self_with_gas_limit(coins: u64, gas: u64) -> CallInfo {
        let caller = abi(CallingContracts, ContractId::this().bits());
        caller.payable_call {
            gas,
            coins,
            asset_id: AssetId::default().bits()
        } ()
    }
}

#[test]
fn non_payable_call() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    let call_info = caller.non_payable_call();
    let _ = __dbg(call_info);
}

#[test]
fn payable_call_for_base_asset_enough_balance() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    // Test infrastructure provides one base asset coin.
    let call_info = caller.payable_call { coins: 1 } ();
    let _ = __dbg(call_info);
}

#[test]
fn failing_payable_call_for_base_asset_not_enough_balance() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    let call_info = caller.payable_call { coins: 42 } ();
    let _ = __dbg(call_info);
}

#[test]
fn failing_payable_call_for_default_contract_asset_not_enough_balance() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), SubId::zero());
    let call_info = caller.payable_call { coins: 42, asset_id: asset_id.into() } ();
    let _ = __dbg(call_info);
}

#[test]
fn call_non_payable_call_on_self() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    let call_info = caller.call_non_payable_call_on_self();
    let _ = __dbg(call_info);
}

#[test]
fn call_payable_call_on_self() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    caller.mint_default_asset(42);
    let call_info = caller.call_payable_call_on_self(24);
    let _ = __dbg(call_info);
}

#[test]
fn failing_call_payable_call_on_self_not_enough_balance() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    caller.mint_default_asset(42);
    let call_info = caller.call_payable_call_on_self(84);
    let _ = __dbg(call_info);
}

#[test]
fn call_payable_call_on_self_with_gas_limit() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    caller.mint_default_asset(42);
    let call_info = caller.call_payable_call_on_self_with_gas_limit(24, 10_000);
    let _ = __dbg(call_info);
}

#[test]
fn failing_call_payable_call_on_self_with_gas_limit_gas_limit_too_low() {
    let caller = abi(CallingContracts, CONTRACT_ID);
    caller.mint_default_asset(42);
    let call_info = caller.call_payable_call_on_self_with_gas_limit(24, 10);
    let _ = __dbg(call_info);
}