// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./ParticipantManager.sol";
import "./BonusDistributor.sol";

contract Setup {
    ParticipantManager public pm;
    BonusDistributor public bd;

    constructor() payable {
        pm = new ParticipantManager{value: 100 ether}();
        bd = pm.bd();
    }

    function isSolved() public view returns(bool){
        return address(bd).balance == 0;
    }
}