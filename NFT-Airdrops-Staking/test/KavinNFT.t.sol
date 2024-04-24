// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "forge-std/Console2.sol";
import "../src/KavinNFT.sol";

contract KavinNFTTest is Test {
    KavinNFT public nft;
    bytes32 merkleRoot =
        0x90edfb54b4785739d76cbd6f9468ba893e0faeb6c79590ab4cee350d6b5fde2d;
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

    /**
     * @dev Test whitelist Mint
     */
    function test_whiteListMint() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[
            0
        ] = 0x2fc7941cecc943bf2000c5d7068f2b8c8e9a29be62acd583fe9e6e90489a8c82;
        proof[
            1
        ] = 0x9feccf6caa602894c8105bdda7f81b2a7bb7de7dba1f18af92d8d057b708cb41;
        vm.prank(alice);
        nft.whiteListMint(alice, proof, 0);
        assertEq(nft.balanceOf(alice), 1);
    }

    /**
     * @dev  should revert if the same user mints tries to whitelist mint twice
     */
    function test_whiteListMintOnlyOnce() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[
            0
        ] = 0x2fc7941cecc943bf2000c5d7068f2b8c8e9a29be62acd583fe9e6e90489a8c82;
        proof[
            1
        ] = 0x9feccf6caa602894c8105bdda7f81b2a7bb7de7dba1f18af92d8d057b708cb41;
        vm.prank(alice);
        nft.whiteListMint(alice, proof, 0);
        assertEq(nft.balanceOf(alice), 1);

        vm.prank(alice);
        vm.expectRevert();
        nft.whiteListMint(alice, proof, 0);
        assertEq(nft.balanceOf(alice), 1);
    }

    /**
     * @dev  should revert if a non whitelisted user tries to mint
     */
    function test_whiteListMintRevert() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[
            0
        ] = 0x2fc7941cecc943bf2000c5d7068f2b8c8e9a29be62acd583fe9e6e90489a8c82;
        proof[
            1
        ] = 0x9feccf6caa602894c8105bdda7f81b2a7bb7de7dba1f18af92d8d057b708cb41;

        vm.expectRevert();
        nft.whiteListMint(msg.sender, proof, 0);
        assertEq(nft.balanceOf(msg.sender), 0);
    }

    /**
     * @dev deployer can withdraw nft sale funds
     */
    function test_withdrawFunds() public {
        for (uint256 i = 0; i < 1000; i++) {
            nft.safeMint{value: 100 gwei}(msg.sender);
        }
        assertEq(alice.balance, 0);
        vm.prank(alice);
        nft.withdrawFunds(alice);
        //100000000000000
        assertEq(alice.balance, 100000 gwei);
    }

    /**
     * @dev no one else can withdraw
     */
    function test_revertWithdrawFunds() public {
        for (uint256 i = 0; i < 1000; i++) {
            nft.safeMint{value: 100 gwei}(msg.sender);
        }
        assertEq(alice.balance, 0);
        vm.expectRevert();
        nft.withdrawFunds(alice);
        //100000000000000
    }
}
