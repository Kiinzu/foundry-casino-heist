// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {VVVIP} from "src/common/vvvip-member/VVVIP.sol";
import {Setup} from "src/common/vvvip-member/Setup.sol";


contract VVVIPMemberTest is Test{
    Setup public challSetup;
    VVVIP public vvvip;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 15 ether}();
        vvvip = challSetup.vvvip();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 7 ether);

        // Write Exploit here


        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}