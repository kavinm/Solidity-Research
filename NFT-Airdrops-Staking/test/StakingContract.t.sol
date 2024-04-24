// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../src/KavinNFTStaking.sol";
import "../src/StakingRewardToken.sol";
import "../src/KavinNFT.sol";

contract StakingContractTest is Test {
    KavinNFTStaking staking;
    StakingRewardToken rewardToken;
    KavinNFT nft;
    bytes32 merkleRoot =
        0x90edfb54b4785739d76cbd6f9468ba893e0faeb6c79590ab4cee350d6b5fde2d;

    address public alice = address(0x1);

    function setUp() public {
        nft = new KavinNFT(merkleRoot);
        rewardToken = new StakingRewardToken();
        staking = new KavinNFTStaking(address(nft), rewardToken);
        rewardToken.transferOwnership(address(staking));

        nft.safeMint{value: 100 gwei}(alice);
    }

    function test_canReceiveNFT() public {
        vm.prank(alice);
        nft.safeTransferFrom(alice, address(staking), 0, "0x");
        assertEq(nft.balanceOf(address(staking)), 1);
    }

    function test_canClaimTokens() public {
        vm.prank(alice);
        nft.safeTransferFrom(alice, address(staking), 0, "0x");
        //advance time by 2 days, expect 20 tokens to be claimed
        vm.warp(block.timestamp + 2 days);
        vm.prank(alice);
        staking.claim(0);
        assertEq(rewardToken.balanceOf(alice), 20 ether);
    }

    function test_revertClaimTokens() public {
        vm.prank(alice);
        nft.safeTransferFrom(alice, address(staking), 0, "0x");
        vm.expectRevert();
        staking.claim(0);
    }

    function test_multipleClaims() public {
        vm.prank(alice);
        nft.safeTransferFrom(alice, address(staking), 0, "0x");
        //advance time by 2 days, expect 20 tokens to be claimed
        vm.warp(block.timestamp + 2 days);
        vm.prank(alice);
        staking.claim(0);
        assertEq(rewardToken.balanceOf(alice), 20 ether);
        // claim a couple more times
        vm.prank(alice);
        staking.claim(0);
        vm.prank(alice);
        staking.claim(0);
        assertEq(rewardToken.balanceOf(alice), 20 ether);
    }

    function test_withdraw() public {
        vm.prank(alice);
        nft.safeTransferFrom(alice, address(staking), 0, "0x");
        assertEq(nft.balanceOf(address(staking)), 1);
        vm.prank(alice);
        staking.withdraw(0);
        assertEq(nft.balanceOf(alice), 1);
    }
}
