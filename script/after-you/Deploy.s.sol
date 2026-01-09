// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/common/after-you/Setup.sol";
import {Express} from "src/common/after-you/Express.sol";

contract DeployScript is Script {
    // Deployer (Anvil's default first account)
    uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    // Player (Anvil's default second account)
    uint256 playerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
    // Alice (Anvil's default third account)
    uint256 alicePrivateKey = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
    
    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        
        console2.log("========== DEPLOYING SETUP ==========");
        Setup setup = new Setup{value: 500 ether}();
        console2.log("Setup deployed at:", address(setup));
        console2.log("====================================");
        console2.log("");

        console2.log("========== PLAYER SETUP ==========");
        address player = vm.addr(playerPrivateKey);
        vm.deal(player, 1 ether);
        console2.log("Player Address    : ", player);
        console2.log("Player Private Key: ", playerPrivateKey);
        console2.log("Player Balance    : ", address(player).balance, "ether");
        console2.log("====================================");
        console2.log("");

        console2.log("========== ALICE SETUP ==========");
        address alice = vm.addr(alicePrivateKey);
        vm.deal(alice, 1 ether);
        console2.log("Alice Address : ", alice);
        console2.log("Alice Balabnce: ", address(alice).balance);
        console2.log("====================================");
        console2.log("");

        vm.stopBroadcast();
        
        // Write the setup address to a file for other scripts to use
        string memory setupAddress = vm.toString(address(setup));
        vm.writeFile(".anvil/setup.addr", setupAddress);
        console2.log("Setup address saved to .anvil/setup.addr");
    }

}
