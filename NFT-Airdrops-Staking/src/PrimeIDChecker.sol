// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {PrimeNFT} from "./PrimeNFT.sol";

contract PrimeIDChecker {
    PrimeNFT private primeNFT;

    constructor(address _primeNFTAddress) {
        primeNFT = PrimeNFT(_primeNFTAddress);
    }
    function numberOfPrimeIDs(address owner) public view returns (uint256) {
        //max collection of 100
        uint8 numPrimes = 0;
        uint256[] memory ownedTokens = getOwnedTokens(owner);
        if (ownedTokens.length == 0) {
            return 0;
        } else {
            for (uint8 i = 0; i <= ownedTokens.length - 1; i++) {
                if (isPrime(ownedTokens[i])) {
                    numPrimes++;
                }
            }
        }
        return numPrimes;
    }

    function isPrime(uint256 num) public pure returns (bool) {
        if (num <= 1) {
            return false;
        }
        if (num <= 3) {
            return true;
        }
        if (num % 2 == 0 || num % 3 == 0) {
            return false;
        }
        for (uint256 i = 5; i * i <= num; i += 6) {
            if (num % i == 0 || num % (i + 2) == 0) {
                return false;
            }
        }
        return true;
    }

    function getOwnedTokens(
        address owner
    ) public view returns (uint256[] memory) {
        uint256 tokenCount = primeNFT.balanceOf(owner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            for (uint256 i = 0; i < tokenCount; i++) {
                result[i] = primeNFT.tokenOfOwnerByIndex(owner, i);
            }
            return result;
        }
    }
}
