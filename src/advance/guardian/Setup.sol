// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Guardian.sol";
import "./AncientVault.sol";

contract Setup{
    Guardian public guardian;
    AncientVault public av;

    constructor() payable {
        guardian = new Guardian{value: 1000 ether}();
        av = guardian.av();
    }

    function isSolved() public view returns(bool){
        return(
            address(av).balance == 0 &&
            msg.sender.code.length == 0
        );
    }

}