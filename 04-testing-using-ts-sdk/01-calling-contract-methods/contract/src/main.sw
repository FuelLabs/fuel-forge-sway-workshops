contract;

use std::identity::Identity;
use std::asset_id::AssetId;
use std::contract_id::ContractId;

struct CallInfo {
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
        Self {
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
}

impl CallingContracts for Contract {
    fn non_payable_call() -> CallInfo {
        CallInfo::this_call()
    }

    #[payable]
    fn payable_call() -> CallInfo {
        CallInfo::this_call()
    }
}
