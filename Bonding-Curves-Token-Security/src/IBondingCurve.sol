// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IBondingCurve {
    function calculatePurchaseReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _buyAmount
    ) external returns (uint256);

    function calculateSaleReturn(
        uint256 _supply,
        uint256 _reserveBalance,
        uint32 _reserveRatio,
        uint256 _sellAmount
    ) external returns (uint256);
}
