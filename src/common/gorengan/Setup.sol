// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {GorenganToken} from "./GorenganToken.sol";
import {GorenganVault} from "./GorenganVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Setup {
    address public immutable player;

    GorenganToken public immutable token;
    GorenganVault public immutable vault;

    uint256 public INSTITUTION_DEPOSIT_AMOUNT = 1000 ether;

    bool public institutionDeposited;
    bool public solved;

    constructor(address _player) {
        player = _player;
        token = new GorenganToken();
        vault = new GorenganVault(token);
        token.mint(address(this), INSTITUTION_DEPOSIT_AMOUNT);
        IERC20(address(token)).approve(address(vault), type(uint256).max);
    }

    function buyGorenganSlot() public payable{
        require(msg.value > 0, "It require money to buy GORENGAN");
        token.mint(address(msg.sender), msg.value);
    }

    function _institutionDeposit() external {
        require(!institutionDeposited, "Institution has Accumulate a Large Amount of GORENGAN");
        institutionDeposited = true;
        vault.deposit(INSTITUTION_DEPOSIT_AMOUNT, address(this));
    }

    function isSolved() external returns (bool) {
        if (!solved){
            try this._institutionDeposit() {
                uint256 institutionShares = vault.balanceOf(address(this));
                if (institutionShares > 0) {
                    return false;
                }
                solved = true;
                return true;
            } catch {
                return false;
            }
        }
        return true;
    }
}
