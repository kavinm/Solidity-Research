// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/// @title Sale Token
/// @author Kavin
/// @notice Token can be freely minted by the owner, will set it to the bonding curve contract
/// @dev Allows for token to be minted only by owner

contract SaleToken is ERC20, Ownable, ERC20Permit {
    /**
     * @dev Init constructor
     */
    constructor()
        ERC20("Bonding Curve Token", "BST")
        Ownable(msg.sender)
        ERC20Permit("Bonding Curve Token")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
