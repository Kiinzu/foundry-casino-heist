// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {GearingUp} from "src/basic/gearing-up/GearingUp.sol";
import {Setup} from "src/basic/gearing-up/Setup.sol";

contract GearingUpTest is Test{
    Setup public challSetup;
    GearingUp public GU;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 10 ether);
        challSetup = new Setup{value: 10 ether}();
        GU = challSetup.GU();
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