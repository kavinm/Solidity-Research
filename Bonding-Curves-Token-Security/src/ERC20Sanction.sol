// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;
import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
