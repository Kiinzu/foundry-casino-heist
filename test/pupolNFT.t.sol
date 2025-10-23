// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Manager} from "src/vip/pupol-nft/Manager.sol";
import {PupolMain} from "src/vip/pupol-nft/PupolMain.sol";
import {Setup} from "src/vip/pupol-nft/Setup.sol";

contract PupolTest is Test{
    Setup public challSetup;
    Manager public manager;
    PupolMain public pupol;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer, deployer);
        vm.deal(deployer, 2000 ether);

        challSetup = new Setup{value: 1500 ether}();
        pupol = PupolMain(challSetup.pupol());
        manager = Manager(challSetup.manager());
        
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player, player);
        vm.deal(player, 10.01 ether);
    
        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}