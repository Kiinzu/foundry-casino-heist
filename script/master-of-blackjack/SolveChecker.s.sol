// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/common/master-of-blackjack/Setup.sol";
import {Blackjack} from "src/common/master-of-blackjack/Blackjack.sol";

contract SolveChecker is Script {
    function run() public view returns (bool) {
        string memory setupAddressStr = vm.readFile(".anvil/setup.addr");
        address setupAddress = vm.parseAddress(setupAddressStr);

        Setup setup = Setup(setupAddress);
        Blackjack blackjack = setup.blackjack();

        console2.log("========== CHECKING SOLUTION ==========");
        console2.log("Setup at          : ", address(setup));
        console2.log("Blackjack at      : ", address(blackjack));
        console2.log("playerMoved       : ", blackjack.playerMoved());
        console2.log("dealerMoved       : ", blackjack.dealerMoved());
        console2.log("dealerWon         : ", blackjack.dealerWon());
        console2.log("playerWon         : ", blackjack.playerWon());
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
