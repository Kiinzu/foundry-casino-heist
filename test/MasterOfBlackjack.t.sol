// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Blackjack} from "src/common/master-of-blackjack/Blackjack.sol";
import {Setup} from "src/common/master-of-blackjack/Setup.sol";

contract MasterOfBlackjackTest is Test{
    Setup public challSetup;
    Blackjack public blackjack;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 30 ether}();
        blackjack = challSetup.blackjack();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 1 ether);

        // Write Exploit here
        vm.warp(19); // Feel free to change this to any block.timestamp that satisfy the requirement

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}