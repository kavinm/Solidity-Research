// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "forge-std/Console2.sol";
import "../src/PrimeNFT.sol";

contract PrimeNFTest is Test {
    PrimeNFT public nft;
    address alice = address(0x1);

    function setUp() public {
        vm.prank(alice);
        nft = new PrimeNFT();
    }

    /**
     * @dev Returns the right name
     */
    function test_name() public {
        assertEq(nft.name(), "PrimeNFT");
    }

    /**
     * @dev Returns the right symbol
     */
    function test_symbol() public {
        assertEq(nft.symbol(), "PNFT");
    }

    /**
     * @dev Test minting up to 1000;
     */
    function test_maxMint() public {
        for (uint256 i = 0; i < 20; i++) {
            nft.safeMint(msg.sender);
            vm.warp(12369420);
        }
        assertEq(nft.balanceOf(msg.sender), 20);
    }

    /**
     * @dev Test minting over 1000;
     */
    function test_maxMintFailure() public {
        for (uint256 i = 0; i < 20; i++) {
            nft.safeMint(msg.sender);
            vm.warp(12369420);
        }
        assertEq(nft.balanceOf(msg.sender), 20);

        vm.expectRevert();
        nft.safeMint(msg.sender);
    }
}
