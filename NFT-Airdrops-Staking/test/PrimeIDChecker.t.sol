// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "forge-std/Console2.sol";
import "../src/PrimeNFT.sol";
import "../src/PrimeIDChecker.sol";

contract PrimeIDCheckerTest is Test {
    PrimeNFT public nft;
    PrimeIDChecker idChecker;
    address alice = address(0x1);

    function setUp() public {
        nft = new PrimeNFT();
        idChecker = new PrimeIDChecker(address(nft));

        for (uint256 i = 0; i < 10; i++) {
            vm.prank(alice);
            nft.safeMint(alice);
            console2.log(nft.tokenOfOwnerByIndex(alice, i));
        }
    }
    //      84
    //   50
    //   60
    //   43
    //   75
    //   19
    //   5
    //   49
    //   38
    //   2

    function test_primes() public {
        uint256 numPrimes = idChecker.numberOfPrimeIDs(alice);
        assertEq(numPrimes, 4);
    }
}
