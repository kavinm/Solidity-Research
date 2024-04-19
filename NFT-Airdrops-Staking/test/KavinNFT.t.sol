// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "forge-std/Console2.sol";
import "../src/KavinNFT.sol";

contract KavinNFTTest is Test {
    KavinNFT public nft;
    bytes32 merkleRoot =
        0xa363ce445148603408e6b99e5f58271a80b194bfce04d7270672f0ac98e086f5;
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        vm.prank(alice);
        nft = new KavinNFT(merkleRoot);
    }

    /**
     * @dev Returns the right name
     */
    function test_name() public {
        assertEq(nft.name(), "KavinNFT");
    }

    /**
     * @dev Returns the right symbol
     */
    function test_symbol() public {
        assertEq(nft.symbol(), "KNFT");
    }

    /**
     * @dev Test minting up to 1000;
     */
    function test_maxMint() public {
        for (uint256 i = 0; i < 1000; i++) {
            nft.safeMint{value: 100 gwei}(msg.sender);
        }
        assertEq(nft.balanceOf(msg.sender), 1000);
    }

    /**
     * @dev Test minting over 1000;
     */
    function test_maxMintFailure() public {
        for (uint256 i = 0; i < 1000; i++) {
            nft.safeMint{value: 100 gwei}(msg.sender);
        }
        assertEq(nft.balanceOf(msg.sender), 1000);

        vm.expectRevert();
        nft.safeMint(msg.sender);
    }

    /**
     * @dev Test address and amount for royalty
     */
    function test_Royalty() public {
        nft.safeMint{value: 100 gwei}(msg.sender);
        //given a sale of 1 eth
        (address receiver, uint256 royaltyAmount) = nft.royaltyInfo(1, 1e18);
        assertEq(receiver, alice);
        assertEq(royaltyAmount, 2.5e16);
    }
}
