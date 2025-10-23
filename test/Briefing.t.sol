// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Briefing} from "src/basic/briefing/Briefing.sol";
import {Setup} from "src/basic/briefing/Setup.sol";

contract BriefingTest is Test{
    Setup public challSetup;
    Briefing public briefing;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 10 ether);
        challSetup = new Setup(0x4e6f77596f754b6e6f7753746f7261676549734e6f7454686174536166652e2e);
        briefing = challSetup.brief();
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 7 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}