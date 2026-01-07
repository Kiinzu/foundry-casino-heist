// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./MarketFront.sol";
import "./Inventory.sol";

contract Setup{
    MarketFront public MF;

    address public owner;

    constructor() payable {
        owner = msg.sender;
        MF = new MarketFront{value: 1000 ether}(owner);
    }

    function isSolved() public view returns(bool){
        (, ,uint256 inStock,) = Inventory(MF.inventory()).items(0);
        uint256 mfBalance = address(MF).balance;
        uint256 playerCredit = MF.storeCredit(msg.sender);
        return (
            inStock == 0 && mfBalance >= 1000 ether && playerCredit >= 1000 ether
        );
    }

}