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

    event Buy(address indexed recipient, uint256 amountA, uint256 amountB);
    event Sell(address indexed recipient, uint256 amountA, uint256 amountB);

    //reserve ratio shall be  a percentage denominated in ppm, cannot be greater than a million
    uint32 private constant MAX_RESERVE_RATIO = 1000000;
    //max gas price to prevent frontrunning
    uint256 maxGasPrice = 10000000 wei;
    // supply of sale token stored in contract
    uint256 tokenSupply;

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
    /**
     * @notice the reserve ratio as defined in tbe bancor formula
     *
     */
    uint256 reserveRatio;

    constructor(
        IERC20 _saleToken,
        IERC20 _reserveToken,
        uint256 _reserveRatio
    ) Ownable(msg.sender) {
        saleToken = _saleToken;
        reserveToken = _reserveToken;
        reserveRatio = _reserveRatio;
    }

    function calculatePurchaseReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _buyAmount
    ) external override returns (uint256) {
        //checks for valid inputs
        require(
            _reserveBalance > 0 &&
                reserveRatio > 0 &&
                reserveRatio <= MAX_RESERVE_RATIO
        );

        if (_buyAmount == 0) {
            return 0;
        }

        if (_reserveRatio == MAX_RESERVE_RATIO) {
            return (_supply * _buyAmount) / _reserveBalance;
        }

        uint256 result = _supply *
            ((_buyAmount + _reserveBalance) ** _reserveRatio /
                (_reserveBalance ** _reserveRatio) -
                1);
        return result / MAX_RESERVE_RATIO;
    }

    function calculateSaleReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _sellAmount
    ) external override returns (uint256) {
        require(
            _supply > 0 &&
                _reserveBalance > 0 &&
                _reserveRatio > 0 &&
                _reserveRatio <= MAX_RESERVE_RATIO &&
                _sellAmount <= _supply,
            "Invalid input"
        );

        if (_sellAmount == 0) {
            return 0;
        }

        if (_sellAmount == _supply) {
            return _reserveBalance;
        }

        if (_reserveRatio == MAX_RESERVE_RATIO) {
            return (_reserveBalance * _sellAmount) / _supply;
        }

        uint256 result = _reserveBalance *
            (1 -
                ((_supply - _sellAmount) ** MAX_RESERVE_RATIO /
                    _supply ** MAX_RESERVE_RATIO) **
                    (MAX_RESERVE_RATIO / _reserveRatio));
        return result;
    }
}
