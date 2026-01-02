// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/common/take-my-money/Setup.sol";
import "src/common/take-my-money/Bouncer.sol";

contract TakeMyMoneyTest is Test {
    Setup public challSetup;
    Bouncer public bouncer;

    address public deployer = makeAddr("deployer");
    address public  player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer, deployer);
        challSetup = new Setup();
        bouncer = challSetup.bouncer();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 1 ether);

        // Write Exploit Here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}