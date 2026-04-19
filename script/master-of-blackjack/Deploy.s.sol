// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/common/master-of-blackjack/Setup.sol";
import {Blackjack} from "src/common/master-of-blackjack/Blackjack.sol";

contract DeployScript is Script {
    // Deployer (Anvil's default first account)
    uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    // Player (Anvil's default second account)
    uint256 playerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        console2.log("========== DEPLOYING SETUP ==========");
        Setup setup = new Setup{value: 30 ether}();
        console2.log("Setup deployed at    :", address(setup));
        console2.log("Blackjack deployed at:", address(setup.blackjack()));
        console2.log("====================================");
        console2.log("");

        console2.log("========== PLAYER SETUP ==========");
        address player = vm.addr(playerPrivateKey);
        console2.log("Player Address    : ", player);
        console2.log("Player Private Key: ", playerPrivateKey);
        console2.log("Player Balance    : ", address(player).balance / 1e18, "ether");
        console2.log("====================================");
        console2.log("");

        vm.stopBroadcast();

        string memory setupAddress = vm.toString(address(setup));
        vm.writeFile(".anvil/setup.addr", setupAddress);
        console2.log("Setup address saved to .anvil/setup.addr");
    }
}
