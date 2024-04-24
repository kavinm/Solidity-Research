// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {StakingRewardToken} from "./StakingRewardToken.sol";
import {KavinNFT} from "./KavinNFT.sol";

contract KavinNFTStaking is IERC721Receiver {
    //store address of deployed kavinNFT collection
    KavinNFT kavinNFT;
    StakingRewardToken stakingToken;

    //10 tokens
    uint256 constant DAILY_REWARD_AMOUNT = 10 ether;

    struct Stake {
        address originalOwner;
        uint256 timeSinceClaimed;
    }
    mapping(uint256 tokenID => Stake stake) public originalOwners;

    event TokensClaimed(address indexed claimer, uint256 amount);
    event Staked(uint256 indexed tokenID);
    event Withdraw(uint256 indexed tokenID);

    constructor(address _kavinNFT, StakingRewardToken _stakingToken) {
        kavinNFT = KavinNFT(_kavinNFT);
        stakingToken = _stakingToken;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external returns (bytes4) {
        //make sure only the OG nft contract calls this
        require(msg.sender == address(kavinNFT), "Not authorized");

        //store the original owner and block timestamp at time of deposit in the nft in mapping
        originalOwners[id] = Stake(from, block.timestamp);
        emit Staked(id);
        return IERC721Receiver.onERC721Received.selector;
    }

    function withdraw(uint256 id) external {
        address originalOwner = originalOwners[id].originalOwner;
        require(msg.sender == originalOwner, "Wrong depositor");
        kavinNFT.safeTransferFrom(address(this), originalOwner, id);
    }

    function claim(uint256 id) external {
        address originalOwner = originalOwners[id].originalOwner;
        require(
            msg.sender == originalOwners[id].originalOwner,
            "Wrong depositor"
        );
        uint256 daysElapsed = (block.timestamp -
            originalOwners[id].timeSinceClaimed) / 1 days;

        stakingToken.mintTokens(
            originalOwner,
            daysElapsed * DAILY_REWARD_AMOUNT
        );

        //set the current time as they have now claimed
        originalOwners[id].timeSinceClaimed = block.timestamp;
        emit TokensClaimed(originalOwner, daysElapsed * DAILY_REWARD_AMOUNT);
    }
}
