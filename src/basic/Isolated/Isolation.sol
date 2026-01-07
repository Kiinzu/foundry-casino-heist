// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Isolation {
    bool public found;

    constructor() {}

    function isFound() public {
        found = true;
    }

}