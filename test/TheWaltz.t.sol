// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "src/advance/the-waltz/Setup.sol";
import "src/advance/the-waltz/BonusDistributor.sol";
import "src/advance/the-waltz/ParticipantManager.sol";

contract TheWaltzTest is Test{
    Setup public challSetup;
    BonusDistributor public bd;
    ParticipantManager public pm;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        vm.deal(deployer.addr, 100 ether);

        challSetup = new Setup{value: 100 ether}();
        pm = challSetup.pm();
        bd = challSetup.bd();
        vm.stopPrank();
    }   

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 10 ether);

        // Write Exploit Here
        
        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}