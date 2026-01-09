//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Express.sol";

contract Setup{
    Express public express;

    constructor() payable {
        require(msg.value == 500 ether);
        express = new Express{value: 500 ether}();
    }

    function isSolved() public view returns(bool){
        return (
            address(express).balance == 0 &&
            address(express.firstToCelebrate()) == 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
    }

}