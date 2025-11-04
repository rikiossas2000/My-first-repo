// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BasicMath {

    function adder(uint256 a, uint256 b) public pure returns (uint256) {
        unchecked {
            uint256 result = a + b;
            if (result < a) {
                return 0;
            }
            return result;
        }
    }

    function subtractor(uint256 a, uint256 b) public pure returns (uint256) {
        if (b > a) {
            return 0;
        }
        return a - b;
    }

    function multiplier(uint256 a, uint256 b) public pure returns (uint256) {
        unchecked {
            if (a == 0 || b == 0) {
                return 0;
            }
            uint256 result = a * b;
            if (result / a != b) {
                return 0;
            }
            return result;
        }
    }

    function divider(uint256 a, uint256 b) public pure returns (uint256) {
        if (b == 0) {
            return 0;
        }
        return a / b;
    }
}
