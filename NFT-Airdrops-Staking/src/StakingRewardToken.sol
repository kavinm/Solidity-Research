// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title ERC20 Reward Token for Staking
/// @author Kavin Mohan
/// @notice The reward token for staking the KavinNFT
/// @dev Standard ERC20 token but only the owner, which should be the staking contract can mint

contract StakingRewardToken is ERC20, Ownable {
    address stakingContract;
    constructor() ERC20("StakingRewardToken", "SRT") Ownable(msg.sender) {}

    function mintTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
