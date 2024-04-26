// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title NFT Token for Whitelist + Bitmap Implementation
/// @author Kavin Mohan
/// @notice Only use if you have a need for a whitelist mint with a merkle root
/// @dev The Whitelist mint will only proceed if the user is in the merkleroot

contract KavinNFT is ERC721, ERC721Enumerable, ERC721Royalty, Ownable2Step {
    // a chunk of data holding the hashed values of all the merkle branches
    bytes32 public immutable merkleRoot;

    //check if a user has claimed their airdrop with bitmaps
    BitMaps.BitMap private _airdropList;

    //royalty, denoted in basis points
    uint96 constant ROYALTY = 250;
    // mint price
    uint256 constant MINT_PRICE = 100 gwei;
    // max supply
    uint256 constant MAX_SUPPLY = 1000;

    constructor(
        bytes32 _merkleRoot
    ) ERC721("KavinNFT", "KNFT") Ownable(msg.sender) {
        //setting royalty for the entire collection to be 2.5% (numerated in basis points)
        //royalty goes to contract deployer
        _setDefaultRoyalty(msg.sender, ROYALTY);
        merkleRoot = _merkleRoot;
    }
    uint256 private _nextTokenId = 0;

    /// @notice Mint at a small cost, denoted by mint fee constant
    /// @dev emits a Mint event
    /// @dev reverts if correct amount is not sent
    /// @dev reverts if the total supply has been hit
    /// @param to The address to mint the 721 token to

    function safeMint(address to) public payable {
        //Supply of 1000
        require(totalSupply() < MAX_SUPPLY, "Tokens have been minted out");
        //cost of 100 gwei
        require(msg.value >= MINT_PRICE);
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    /// @notice Whitelist mint, requires no fee
    /// @dev emits a Mint event
    /// @dev reverts if user is not on the whitelist
    /// @param to The address to mint the 721 token to

    function whiteListMint(
        address to,
        bytes32[] calldata proof,
        uint256 index
    ) public payable {
        //Supply of 1000
        require(totalSupply() < MAX_SUPPLY, "Tokens have been minted out");

        //check to see user has only whitelist minted once
        require(
            !BitMaps.get(_airdropList, index),
            "Address has already claimed"
        );

        //if address is whitelisted, free mint
        _verifyProof(proof, index, msg.sender);
        //set to true that user has claimed
        BitMaps.setTo(_airdropList, index, true);
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function withdrawFunds(address to) external onlyOwner {
        uint256 etherAmount = address(this).balance;
        (bool sent, bytes memory data) = to.call{value: etherAmount}("");
        require(sent, "failed to withdraw");
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function _verifyProof(
        bytes32[] memory proof,
        uint256 index,
        address addr
    ) private view {
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(addr, index)))
        );
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof");
    }
}
