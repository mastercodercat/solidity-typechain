// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract Incrementor {
    uint256 public y;
    uint256 public z;
    uint256 public x;

    function incrementX() external {
        x++;
    }

    function incrementY() external {
        y++;
    }

    function incrementZ() external {
        z++;
    }
}