// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Capitol} from "src/common/cheap-glitch/Capitol.sol";
import {Setup} from "src/common/cheap-glitch/Setup.sol";

contract CheapGlitchTest is Test{
    Setup public challSetup;
    Capitol public capitol;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 10 ether);
        challSetup = new Setup();
        capitol = challSetup.capitol();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 1 ether);

        //Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }


}