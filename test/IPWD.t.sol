// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Setup} from "src/vip/ipwd/Setup.sol";
import {IPWD} from "src/vip/ipwd/IPWD.sol";
import {IPWDAdministrator} from "src/vip/ipwd/IPWDAdministrator.sol";
import {Validator} from "src/vip/ipwd/Validator.sol";
import {ValidatorInterface} from "src/vip/ipwd/ValidatorInterface.sol";

contract IPWDTest is Test{
    Setup public challSetup;
    IPWD public ipwd;
    IPWDAdministrator public ipwdAdmin;
    Validator public validator;
    ValidatorInterface public vi;

    address public deployer = makeAddr("deployer");
    address public player = makeAddr("player");

    bytes32[] public referralCodes;
    bytes[] public payloads;
    address[] public helper;

    function setUp() public{
        vm.startPrank(deployer);
        vm.deal(deployer, 3000 ether);

        // Referral Generator
        bytes32 REF1 = vm.envBytes32("REF1");
        bytes32 REF2 = vm.envBytes32("REF2");
        bytes32 REF3 = vm.envBytes32("REF3");
        bytes32 REF4 = vm.envBytes32("REF4");
        bytes32 REF5 = vm.envBytes32("REF5");

        referralCodes = [
            REF1,
            REF2,
            REF3,
            REF4,
            REF5
        ];
        challSetup = new Setup{value: 2000 ether}(referralCodes);
        ipwd = challSetup.ipwd();
        ipwdAdmin = challSetup.ipwdAdmin();
        vi = challSetup.vi();
        validator = challSetup.validator();

        vm.stopPrank();
    }

    function test_testIfSolved() public{
        // Setup for Player, set msg.sender and tx.origin to player
        vm.startPrank(player, player);
        vm.deal(player, 2.2 ether);

        // Write Exploit here

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }

}