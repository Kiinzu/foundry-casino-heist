// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {ChallengeManager} from "src/vip/inju-s-gambit/ChallengeManager.sol";
import {Privileged} from "src/vip/inju-s-gambit/Privileged.sol";
import {Setup} from "src/vip/inju-s-gambit/Setup.sol";

contract InjusGambitTest is Test{
    Setup public challSetup;
    Privileged public priv;
    ChallengeManager public CM;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 200 ether);
        challSetup = new Setup{value: 150 ether}(0x494e4a55494e4a55494e4a5553555045524b45594b45594b45594b45594b4559);
        priv = challSetup.privileged();
        CM = challSetup.challengeManager();
        vm.stopPrank();
    }

    function testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player, player);
        vm.deal(player, 10 ether);

        vm.warp(6); // Change the value to satisfy the value
        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}