pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "src/basic/peek-a-slot/Setup.sol";

contract PeekASlotTest is Test{
    Setup public challSetup;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        bytes32 seed = vm.envBytes32("SEED");
        bytes32 dArrayValue = vm.envBytes32("DARRAY");
        bytes32 tdArrayValue = vm.envBytes32("TDARRAY");
        console.logBytes32(seed);
        // 1d array
        bytes32[] memory dArray = new bytes32[](5);
        dArray[4] = dArrayValue;
        console.logBytes32(dArray[4]);

        // 2d array
        bytes32[][] memory tdArray = new bytes32[][](3);
        tdArray[2] = new bytes32[](4);
        tdArray[2][3] = tdArrayValue;
        console.logBytes32(tdArray[2][3]);

        challSetup = new Setup(seed, dArray, tdArray);
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