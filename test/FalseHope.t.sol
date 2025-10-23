// SPDX-License-Identifier: Kiinzu
pragma solidity 0.8.28;

import { Test, console } from "forge-std/Test.sol";
import { Setup } from "src/advance/false-hope/Setup.sol";
import { Hope } from "src/advance/false-hope/Hope.sol";
import { HopeBeacon } from "src/advance/false-hope/HopeBeacon.sol";

contract HopeTest is Test{

    Setup public challSetup;
    Hope public hopeImplementation;
    HopeBeacon public hopeProxy;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup();
        hopeProxy = challSetup.HB();
        hopeImplementation = challSetup.hope();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player);
        vm.deal(player, 1 ether);

        // Write Exploit Here


        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}