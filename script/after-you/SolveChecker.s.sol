// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/common/after-you/Setup.sol";
import {Express} from "src/common/after-you/Express.sol";

contract SolveChecker is Script {
    function run() public view returns (bool) {
        // Read setup address from file
        string memory setupAddressStr = vm.readFile(".anvil/setup.addr");
        address setupAddress = vm.parseAddress(setupAddressStr);
        
        Setup setup = Setup(setupAddress);
        Express express = setup.express();
        
        console2.log("========== CHECKING SOLUTION ==========");
        console2.log("Setup at          : ", address(setup));
        console2.log("First Celebrator  : ", address(express.firstToCelebrate()));
        console2.log("Balance of Express: ", address(express).balance);
        bool solved = setup.isSolved();
        
        if (solved) {
            console2.log("STATUS: SOLVED!");
        } else {
            console2.log("STATUS: NOT SOLVED");
        }
        console2.log("========================================");
        
        return solved;
    }
}