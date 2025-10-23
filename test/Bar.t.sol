// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Bar} from "src/common/bar/Bar.sol";
import {Setup} from "src/common/bar/Setup.sol";

contract BarTest is Test{
    Setup public challSetup;
    Bar public bar;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 10 ether);
        challSetup = new Setup();
        bar = challSetup.bar();
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player, player);
        vm.deal(player, 2 ether);

        // Write Exploit here
        
        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}