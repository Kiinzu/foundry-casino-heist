// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import {Setup} from "src/basic/bulls-eye/Setup.sol";
import {Range} from "src/basic/bulls-eye/Range.sol";

contract BullsEyeTest is Test{
    Setup public challSetup;
    Range public range;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        vm.deal(deployer.addr, 10 ether);
        challSetup = new Setup{value: 10 ether}();
        range = challSetup.range();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 1e18 + 2);

        // Write Exploit Here
        

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}