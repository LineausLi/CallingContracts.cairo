#There are two different ways to call other contracts in Cairo.

#1:
#[starknet::interface]
trait ICallee<TContractState> {
    fn set_val(ref self: TContractState, value: u128) -> u128;

}

#[starknet::contract]
mod Callee {
    #[storage]
    struct Storage {
        val: u128,
    }


    #[abi(embed_v0)]
    impl ICalleeImpl of super::ICallee<ContractState> {
        fn set_value(ref self: ContractState, val: u128) -> u128 {
            self.value.write(val);
            val
        }
    }
}

#2:
use starknet::ContractAddress;

// We need to have the interface of the callee contract defined
// so that we can import the Dispatcher.
#[starknet::interface]
trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128) -> u128;
}

#[starknet::interface]
trait ICaller<TContractState> {
    fn set_value_from_address(ref self: TContractState, addr: ContractAddress, value: u128);
}

#[starknet::contract]
mod Caller {
    // We import the Dispatcher of the called contract
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}



    #[abi(embed_v0)]
    impl ICallerImpl of super::ICaller<ContractState> {
        fn set_value_from_address(ref self: ContractState, addr: ContractAddress, value: u128) {
            ICalleeDispatcher { contract_address: addr }.set_value(value);
        }
    }
}
