// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./ParticipantManager.sol";

contract BonusDistributor{

    ParticipantManager public pm;

    modifier onlyManager(){
        if(msg.sender != address(pm)) revert NotManager();
        _;
    }

    error NotManager();
    error DistributionFailed();

    constructor() payable {
        pm = ParticipantManager(msg.sender);
    }

    function distributeBonus(uint256 _bonus, address _receiver) external onlyManager returns(bool){
        (bool success, ) = payable(address(_receiver)).call{value: _bonus}("");
        if(!success) revert DistributionFailed();
        return true;
    }
}