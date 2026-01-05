// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Roulette} from "src/common/roulette/Roulette.sol";
import {Setup} from "src/common/roulette/Setup.sol";

contract RouletteTest is Test{
    Setup public challSetup;
    Roulette public roulette;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 30 ether}();
        roulette = challSetup.roulette();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 1 ether);

        // Write Exploit here
        vm.warp(7777); // Feel free to change this to any block.timestamp that satisfy the requirement
        

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}