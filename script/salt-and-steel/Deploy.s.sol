// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/advance/salt-and-steel/Setup.sol";
import {SteelFactory} from "src/advance/salt-and-steel/SteelFactory.sol";
import {Steel} from "src/advance/salt-and-steel/Steel.sol";

contract DeployScript is Script {
    // Anvil's default first account
    uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    // Anvil's default second account
    uint256 playerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    
    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        
        console2.log("========== DEPLOYING SETUP ==========");
        Setup setup = new Setup(vm.addr(playerPrivateKey));
        console2.log("Setup deployed at:", address(setup));
        console2.log("====================================");
        console2.log("");

        console2.log("========== PLAYER SETUP ==========");
        console2.log("Player Address    : ", vm.addr(playerPrivateKey));
        console2.log("Player Private Key: ", playerPrivateKey);
        console2.log("====================================");
        console2.log("");
        
        vm.stopBroadcast();
        
        // Write the setup address to a file for other scripts to use
        string memory setupAddress = vm.toString(address(setup));
        vm.writeFile(".anvil/setup.addr", setupAddress);
        console2.log("Setup address saved to .anvil/setup.addr");
    }

}