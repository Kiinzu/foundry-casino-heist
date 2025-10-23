// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract BOPLockedAccount is Initializable, UUPSUpgradeable {
    bytes32 private constant _AUTHORIZED_MANAGER = // bytes32(uint256(keccak256("eip1967.proxy.isolatedManager")) - 1);
        0x01b59fb07e57058136b20d1b8f8664747fd4bf1d0d1698a3d4fe4de774daab14;

    uint256 public lockedAmount;
    uint256 public lockedPeriod;
    
    modifier onlyManager() {
        require(msg.sender == _managerAddress(), "");
        _;
    }

    constructor(uint256 _lockedPeriod) {
        lockedPeriod = _lockedPeriod;
    }

    function initialize() external initializer onlyProxy {
        address manager = msg.sender;
        assembly {
            sstore(_AUTHORIZED_MANAGER, manager)
        }
    }

    function accountStatus() external view onlyProxy returns (bool) {
        return (
            _managerAddress() != address(0) && lockedAmount >= 0
        );
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyManager onlyProxy {}
    
    function _managerAddress() internal view onlyProxy returns (address managerAddr) {
        assembly {  
            managerAddr := sload(_AUTHORIZED_MANAGER) 
        }
    }

}
