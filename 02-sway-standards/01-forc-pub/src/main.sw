contract;

use signed_int::i8::*;

abi ForcPubDemo {
    fn use_signed_int() -> I8;
}

impl ForcPubDemo for Contract {
    fn use_signed_int() -> I8 {
        I8::zero()
    }
}
