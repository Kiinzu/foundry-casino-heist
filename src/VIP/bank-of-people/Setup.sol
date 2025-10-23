// SPDX-License-Identifier: NQDU
pragma solidity 0.8.29;

import {BankOfPeople} from "./BankOfPeople.sol";

contract Setup{

    BankOfPeople public bop;

    constructor(
        uint8 _preRegisteredLockedAccount,
        uint8 _preRegisteredIsolatedFund
    ) payable {
        bop = new BankOfPeople{value: 100 ether}(
            100 ether,
            _preRegisteredLockedAccount,
            _preRegisteredIsolatedFund
        );
    }

    function isSolved() public view returns(bool){
        return (address(bop).balance < 10 ether);
    }

}
