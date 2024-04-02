// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title God Token
/// @author Kavin
/// @notice Allows the deployer to transfer tokens between addresses at will
/// @dev TransferFrom function is overriden and allowances are not checked if god address

contract GodModeToken is ERC20 {
    // state vars
    address public _god;

    /**
     * @dev Init constructor
     */
    constructor() ERC20("GodMode Token", "GMT") {
        _god = msg.sender;
        _mint(_god, 1000);
    }

    /// @notice Override of transferFrom function to allow transfers at will
    /// @dev Allows transfers to 0 address and otherwise bypasses

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        if (msg.sender == _god) {
            _transfer(from, to, value);
            return true;
        }
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }
}
