// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {PrizePoolBattle} from "src/common/voting-frenzy/PrizePool.sol";
import {Participant1, Participant2, Participant3} from "src/common/voting-frenzy/Participants.sol";
import {Setup} from "src/common/voting-frenzy/Setup.sol";

contract VotingFrenzyTest is Test{
    Setup public challSetup;
    PrizePoolBattle public PZ;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public {
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 9 ether}();
        PZ = challSetup.prizepool();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 1.4 ether);

        // Write Exploit here


        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}