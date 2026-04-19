// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Setup} from "src/basic/briefing/Setup.sol";
import {Briefing} from "src/basic/briefing/Briefing.sol";

contract SolveChecker is Script {
    function run() public view returns (bool) {
        string memory setupAddressStr = vm.readFile(".anvil/setup.addr");
        address setupAddress = vm.parseAddress(setupAddressStr);

        Setup setup = Setup(setupAddress);
        Briefing brief = setup.brief();

        console2.log("========== CHECKING SOLUTION ==========");
        console2.log("Setup at          : ", address(setup));
        console2.log("Briefing at       : ", address(brief));
        console2.log("completedCall     : ", brief.completedCall());
        console2.log("completedInputation:", brief.completedInputation());
        console2.log("completedTransfer : ", brief.completedTransfer());
        console2.log("completedDeposit  : ", brief.completedDeposit());
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
