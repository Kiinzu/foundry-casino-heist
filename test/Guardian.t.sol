// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "src/advance/guardian/Setup.sol";
import "src/advance/guardian/Guardian.sol";
import "src/advance/guardian/AncientVault.sol";

contract GuardianTest is Test{
    Setup public challSetup;
    Guardian public guardian;
    AncientVault public av;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        vm.deal(deployer.addr, 1000 ether);
        challSetup = new Setup{value: 1000 ether}();
        guardian = challSetup.guardian();
        av = challSetup.av();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 1 ether);

        // Write Exploit Here


        assertEq(challSetup.isSolved(), true);
        vm.stopPrank();
        
    }

}