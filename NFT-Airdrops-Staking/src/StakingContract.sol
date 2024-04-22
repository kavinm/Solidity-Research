// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract KavinNFTStaking is IERC721Receiver {
    //store address of deployed kavinNFT collection
    address kavinNFT;

    struct Stake {
        uint256 tokenId;
        uint256 startStakingTime;
    }
    mapping(uint256 id => address originalOwner) public originalOwners;

    constructor(address _kavinNFT) {
        kavinNFT = _kavinNFT;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external returns (bytes4) {
        //make sure only the OG nft contract calls this
        require(msg.sender == kavinNFT, "Not authorized");

        //store the original owner of the nft in mapping
        originalOwners[id] = from;
        return IERC721Receiver.onERC721Received.selector;
    }

    function withdraw(uint256 id) external {
        address originalOwner = originalOwners[id];
    }
}
