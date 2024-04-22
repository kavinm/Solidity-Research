// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
contract KavinNFT is ERC721, ERC721Enumerable, ERC721Royalty {
    // a chunk of data holding the hashed values of all the merkle branches
    bytes32 public immutable merkleRoot;

    //check if a user has claimed their airdrop with bitmaps
    BitMaps.BitMap private _airdropList;

    constructor(bytes32 _merkleRoot) ERC721("KavinNFT", "KNFT") {
        //setting royalty for the entire collection to be 2.5% (numerated in basis points)
        //royalty goes to contract deployer
        _setDefaultRoyalty(msg.sender, 250);
        merkleRoot = _merkleRoot;
    }
    uint256 private _nextTokenId = 0;

    // The mint function is completely free and open

    function safeMint(address to) public payable {
        //Supply of 1000
        require(totalSupply() < 1000, "Tokens have been minted out");
        //cost of 100 gwei
        require(msg.value >= 100 gwei);
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function whiteListMint(
        address to,
        bytes32[] calldata proof,
        uint256 index
    ) public payable {
        //Supply of 1000
        require(totalSupply() < 1000, "Tokens have been minted out");

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
}
