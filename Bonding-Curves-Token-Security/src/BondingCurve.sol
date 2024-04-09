// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IBondingCurve} from "./IBondingCurve.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LinearBondingCurve is IBondingCurve, Pausable, Ownable2Step {
    using SafeERC20 for IERC20;

    /**
     * @notice the ERC20 token sale for bonding curve
     *
     */
    IERC20 saleToken;

    /**
     * @notice the reserve token for bonding curve
     *
     */
    IERC20 reserveToken;

    constructor(IERC20 _saleToken, IERC20 _reserveToken) Ownable(msg.sender) {
        saleToken = _saleToken;
        reserveToken = _reserveToken;
    }

    function calculatePurchaseReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _buyAmount
    ) external override returns (uint256) {}

    function calculateSaleReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _sellAmount
    ) external override returns (uint256) {}
}
