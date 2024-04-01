// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Sanctioned Token
/// @author Kavin
/// @notice Allows the deployer to blacklist addresses from sending or receiving tokens
/// @dev The update function is edited to check the blacklist mapping before taking any action

contract SanctionedToken is ERC20 {
    // state vars
    address public _admin;
    mapping(address => bool) _blacklist;
    /**
     * @dev Init constructor
     */
    constructor() ERC20("Sanctioned Token", "SNT") {
        _admin = msg.sender;
        _mint(_admin, 1000);
    }

    /// @notice Add an address to blacklist
    /// @dev reverts if the token is not allowlisted
    /// @dev reverts if the contract is not approved by the ERC20
    /// @param _toBeBlacklisted The address of the account to be blacklisted

    function addAddressToBlacklist(address _toBeBlacklisted) public {
        require(msg.sender == _admin);
        _blacklist[_toBeBlacklisted] = true;
    }

    /// @notice Override of update function to check
    /// @dev reverts if the address is in the blacklist mapping as true

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        ERC20._update(from, to, value);
        require(
            _blacklist[from] == false && _blacklist[to] == false,
            "Cannot transfer to or from a blacklisted address"
        );
    }
}
