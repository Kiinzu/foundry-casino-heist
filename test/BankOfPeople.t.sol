// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.29;

import "forge-std/Test.sol";
import "src/vip/bank-of-people/BankOfPeople.sol";
import "src/vip/bank-of-people/Setup.sol";

contract BOPTest is Test{
    Setup public challSetup;
    BankOfPeople public bop;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        vm.deal(deployer.addr, 10000 ether);
        challSetup = new Setup{value: 100 ether}(2, 2);
        bop = challSetup.bop();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player to prevent confusion
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 100 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}