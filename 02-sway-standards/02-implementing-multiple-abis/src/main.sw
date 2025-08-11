contract;

abi First {
    fn first();
}

abi Second {
    fn second();
}

impl First for Contract {
    fn first() {
        log("first");
    }
}

impl Second for Contract {
    fn second() {
        log("second");
    }
}

#[test]
fn call_all_contract_methods() {
    let caller = abi(First, CONTRACT_ID);
    caller.first();

    let caller = abi(Second, CONTRACT_ID);
    caller.second();
}