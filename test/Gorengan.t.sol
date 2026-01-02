// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.29;

import "forge-std/Test.sol";
import "src/common/gorengan/GorenganToken.sol";
import "src/common/gorengan/GorenganVault.sol";
import "src/common/gorengan/Setup.sol";

contract BOPTest is Test{
    Setup public challSetup;
    GorenganToken public token;
    GorenganVault public vault;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        challSetup = new Setup(player.addr);
        token = challSetup.token();
        vault = challSetup.vault();
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 1001 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}
