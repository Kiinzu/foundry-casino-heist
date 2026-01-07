// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Guardian.sol";

contract AncientVault {

    Guardian public guardian;

    bool public vaultTreasureClaimed;

    error notGuardian();

    modifier onlyGuardian(){
        if(msg.sender != address(guardian)) revert notGuardian();
        _;
    }

    constructor() payable {
        guardian = Guardian(msg.sender);
    }

    function claimTreasure(address _explorer) public onlyGuardian{
        (bool claimed, ) = payable(address(_explorer)).call{value: address(this).balance}("");
        require(claimed, "All Treasure Remain here-");
    }

}