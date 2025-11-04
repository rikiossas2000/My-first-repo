// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Storage Exercise - Base Academy
 * Covers:
 *  - Storage slots
 *  - Variable packing
 *  - Read/write to storage
 */

contract EmployeeStorage {
    // ✅ STORAGE PACKING:
    // shares (2 bytes) + salary (4 bytes) packed in slot 0 (total 6 bytes)
    uint16 private shares;   // (0 - 5000 max)
    uint32 private salary;   // (0 - 1,000,000 max)
    // ✅ Next slots
    string public name;      // slot 1 (dynamic)
    uint256 public idNumber; // slot 2

    // Custom error example
    error TooManyShares(uint256 newTotalShares);

    constructor(
        uint16 _shares,
        string memory _name,
        uint32 _salary,
        uint256 _idNumber
    ) {
        require(_shares <= 5000, "Invalid: shares > 5000");
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    /**
     * ============= READ FUNCTIONS =============
     */
    function viewShares() public view returns (uint16) {
        return shares;
    }

    function viewSalary() public view returns (uint32) {
        return salary;
    }

    /**
     * ============= UPDATE FUNCTIONS =============
     */
    function grantShares(uint16 _newShares) public {
        // Validate single update doesn't exceed 5000
        if (_newShares > 5000) {
            revert("Too many shares");
        }

        // Validate total shares <= 5000
        uint256 newTotal = shares + _newShares;
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }

        shares += _newShares;
    }

    /**
     * ============= DEBUG + TEST FUNCTIONS =============
     * Base Academy test uses this to inspect storage layout
     */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    // Quick reset function for testing behavior
    function debugResetShares() public {
        shares = 1000;
    }
}
