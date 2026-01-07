// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {Setup} from "src/advance/double-dipping/Setup.sol";
import {MarketFront} from "src/advance/double-dipping/MarketFront.sol";
import {Inventory} from "src/advance/double-dipping/Inventory.sol";

contract DoubleDippingTest is Test{
    Setup public challSetup;
    MarketFront public MF;
    Inventory public inventory;

    Vm.Wallet deployer = vm.createWallet("deployer");
    Vm.Wallet player = vm.createWallet("player");

    function setUp() public {
        vm.startPrank(deployer.addr, deployer.addr);
        vm.deal(deployer.addr, 1000 ether);
        challSetup = new Setup{value: 1000 ether}();
        MF = challSetup.MF();
        inventory = new Inventory(address(MF));

        // Set Inventory
        MF.setInventory(address(inventory));

        // Inserting Items
        Inventory.Item memory bunnyBear = Inventory.Item({
            name: "Bunny Bear",
            price: 100000000000000000000,
            inStock: 10,
            onSale: true
        });
        inventory.inputItem(bunnyBear);
        Inventory.Item memory alpacanDew = Inventory.Item({
            name: "Alpacan Dew",
            price: 1000000000000000000,
            inStock: 100,
            onSale: true
        });
        inventory.inputItem(alpacanDew);
        vm.stopPrank();
    }

    function testIfSolved() public {
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player.addr, player.addr);
        vm.deal(player.addr, 3 ether);

        // Write Exploit Here
       
        assertEq(challSetup.isSolved(), true);
        vm.stopPrank();
    }

}