// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract StakingRewardToken is ERC20, Ownable2Step {
    address stakingContract;
    constructor() ERC20("StakingRewardToken", "SRT") Ownable(msg.sender) {}

    function mintTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
