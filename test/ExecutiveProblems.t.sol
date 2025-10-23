// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Crain} from "src/vip/executive-problems/Crain.sol";
import {CrainExecutive} from "src/vip/executive-problems/CrainExecutive.sol";
import {Setup} from "src/vip/executive-problems/Setup.sol";

contract ExecutiveProblemsTest is Test{
    Setup public challSetup;
    Crain public crain;
    CrainExecutive public CE;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 50 ether}();
        crain = challSetup.crain();
        CE = challSetup.cexe();
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player, player);
        vm.deal(player, 7 ether);

        // Write Exploit here
 

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}