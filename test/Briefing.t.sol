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
        bytes32 secretPhrase = vm.envBytes32("SECRET_PHRASE");
        challSetup = new Setup(secretPhrase);
        briefing = challSetup.brief();
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 7 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}