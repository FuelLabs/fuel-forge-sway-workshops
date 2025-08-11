contract;

abi ConfigurablesDemo {
    fn demo() -> bool;
}

const CONST: b256 = b256::zero();

configurable {
    CONF: b256 = b256::zero(),
}

impl ConfigurablesDemo for Contract {
    fn demo() -> bool {
        CONST == CONF
    }
}

#[test]
fn call_demo() {
    let caller = abi(ConfigurablesDemo, CONTRACT_ID);
    let res = caller.demo();
    let _ = __dbg(res);
}
