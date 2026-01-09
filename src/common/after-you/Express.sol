//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/console2.sol";

contract Express{

    error wrongParty();
    error wrongNumber();

    address public firstToCelebrate;

    constructor() payable {}

    function celebrate(
        string memory _congratulate,
        uint8 _guess
    ) external {
        if(
            keccak256(abi.encodePacked("Happy Birthday Bob!")) != keccak256(abi.encodePacked(_congratulate))
        ) revert wrongParty();
        if(_guess != 79) revert wrongNumber();
        firstToCelebrate = msg.sender;
        console2.log("aaaaaaaaaaaaaa   ", address(firstToCelebrate));
        (bool success, ) = payable(address(firstToCelebrate)).call{value: address(this).balance}("");
        require(success, "Send Failed");
    }

}