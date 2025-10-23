// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {BOPLockedAccount} from "./BOPLockedAccount.sol";

contract BOPLockedProxy {
    // OpenZeppelin's _IMPLEMENTATION_SLOT
    // bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(address _lockedAccount) {
        uint256 period = BOPLockedAccount(_lockedAccount).lockedPeriod();
        require(period == 2592000, "BOPIsolatedProxy-001: Wrong Initial Period");
        assembly {
            sstore(_IMPLEMENTATION_SLOT, _lockedAccount)
        }
    }

    fallback() external payable {
         _continue();
    }

    receive() external payable {
        _continue();
    }

    function _continue() private {
        assembly {
            let iacl := sload(_IMPLEMENTATION_SLOT)
            calldatacopy(0, 0, calldatasize())
            let res := delegatecall(gas(), iacl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }


}