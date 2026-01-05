// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Noble} from "src/common/symbol-of-noble/Noble.sol";
import {Administrator} from "src/common/symbol-of-noble/Administrator.sol";
import {Setup} from "src/common/symbol-of-noble/Setup.sol";

contract SymboleOfNobleTest is Test{
    Setup public challSetup;
    Noble public noble;
    Administrator public admin;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup();
        noble = challSetup.noble();
        admin = challSetup.admin();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 12 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}