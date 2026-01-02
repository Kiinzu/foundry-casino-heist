// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract GorenganVault is ERC4626 {
    constructor(IERC20Metadata asset_)
        ERC20("Gorengan Vault Share", "vgORENG")
        ERC4626(asset_)
    {}

    function _convertToShares(uint256 assets, Math.Rounding rounding)
        internal
        view
        override
        returns (uint256)
    {
        uint256 supply = totalSupply();
        if (supply == 0) return assets;

        uint256 assetsNow = totalAssets();
        return Math.mulDiv(assets, supply, assetsNow, rounding);
    }

    function _convertToAssets(uint256 shares, Math.Rounding rounding)
        internal
        view
        override
        returns (uint256)
    {
        uint256 supply = totalSupply();
        if (supply == 0) return shares;

        uint256 assetsNow = totalAssets();
        return Math.mulDiv(shares, assetsNow, supply, rounding);
    }
}
