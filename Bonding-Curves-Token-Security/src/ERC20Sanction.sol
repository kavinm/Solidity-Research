// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SanctionedToken is ERC20 {
    address public _admin;
    mapping(address => bool) _blacklist;
    /**
     * @dev Init constructor for setting token name and symbol
     */
    constructor() ERC20("Sanctioned Token", "SNT") {
        _admin = msg.sender;
        _mint(_admin, 1000);
    }

    function addAddressToBlacklist(address _toBeBlacklisted) public {
        require(msg.sender == _admin);
        _blacklist[_toBeBlacklisted] = true;
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        ERC20._update(from, to, value);
        require(_blacklist[from] == false && _blacklist[to] == false);
    }
}
