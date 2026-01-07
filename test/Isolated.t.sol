// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "src/basic/Isolated/Setup.sol";
import "src/basic/Isolated/Isolation.sol";

contract IsolatedTest is Test{
    Setup public challSetup;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        challSetup = new Setup();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 1 ether);

        // Write Exploit Here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }


}