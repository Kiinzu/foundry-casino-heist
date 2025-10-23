// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Singularity} from "src/common/singular-identity/Singularity.sol";
import {Setup} from "src/common/singular-identity/Setup.sol";

contract SingularIdentityTest is Test{
    Setup public challSetup;
    Singularity public singularity;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 20 ether}();
        singularity = challSetup.singular();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 5 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}