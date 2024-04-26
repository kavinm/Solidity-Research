// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721Enumerable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/// @title Standard NFT that generates pseudo random token IDs from 1-100 inclusive
/// @author Kavin Mohan
/// @notice The reason it's called prime is because I am using for the prime checker contract
/// @dev has gas intensive mints as it randomly looks for a token id
contract PrimeNFT is ERC721Enumerable {
    constructor() ERC721("PrimeNFT", "PNFT") {}

    uint8 MAX_TOKEN_SUPPLY = 20;

    /// @notice Free mint
    /// @dev emits a Mint event
    /// @dev reverts if the total supply has been hit
    /// @param to The address to mint the 721 token to
    function safeMint(address to) public payable {
        //Supply of 20
        require(
            totalSupply() < MAX_TOKEN_SUPPLY,
            "Tokens have been minted out"
        );

        uint256 tokenId = generateRandomTokenID(to);
        _safeMint(to, tokenId);
    }

    function balanceOfTokens(address owner) public view returns (uint256) {
        return balanceOf(owner);
    }

    /// @notice generates random token id, 1-100 inclusive

    /// @param minter uses address as seed for pseudorandomness
    function generateRandomTokenID(address minter) internal returns (uint256) {
        uint256 tokenId;
        uint256 attempts = 0;
        do {
            tokenId =
                (uint256(
                    keccak256(
                        abi.encodePacked(minter, block.timestamp, attempts)
                    )
                ) % 100) +
                1;
            attempts++;
        } while (_ownerOf(tokenId) != address(0) && attempts < 100);
        require(attempts < 100, "Failed to generate unique token ID");
        return tokenId;
    }
}
