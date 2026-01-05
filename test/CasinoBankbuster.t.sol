// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {InjuBank} from "src/advance/casino-bankbuster/InjuBank.sol";
import {InjuCasino} from "src/advance/casino-bankbuster/InjuCasino.sol";
import {Setup} from "src/advance/casino-bankbuster/Setup.sol";

contract CasinoBankbusterTest is Test{
    Setup public challSetup;
    InjuCasino public IC;
    InjuBank public IB;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 100 ether);
        challSetup = new Setup{value: 30 ether}();
        IB = challSetup.ibank();
        IC = challSetup.icasino();
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