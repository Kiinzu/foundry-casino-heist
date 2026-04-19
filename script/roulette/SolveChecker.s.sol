// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/common/roulette/Setup.sol";
import {Roulette} from "src/common/roulette/Roulette.sol";

contract SolveChecker is Script {
    // Player (Anvil's default second account)
    uint256 playerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function run() public view returns (bool) {
        string memory setupAddressStr = vm.readFile(".anvil/setup.addr");
        address setupAddress = vm.parseAddress(setupAddressStr);

        Setup setup = Setup(setupAddress);
        Roulette roulette = setup.roulette();
        address player = vm.addr(playerPrivateKey);

        console2.log("========== CHECKING SOLUTION ==========");
        console2.log("Setup at          : ", address(setup));
        console2.log("Roulette at       : ", address(roulette));
        console2.log("wonRoulette       : ", roulette.wonRoulette(player));
        console2.log("Player Balance    : ", address(player).balance / 1e18, "ether");
        console2.log("stolenEnough      : ", roulette.stolenEnough());
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
