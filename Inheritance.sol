// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
 Final Inheritance solution for Base exercises.
 - Do NOT deploy Employee, Salaried, Hourly, or Manager directly.
 - Deploy order:
   1) Salesperson
   2) EngineeringManager
   3) InheritanceSubmission (pass addresses from 1 & 2)
*/

// --------------------
// Base abstract contract
// --------------------
abstract contract Employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    // Abstract function (must be implemented by concrete children)
    function getAnnualCost() public view virtual returns (uint256);
}

// --------------------
// Salaried (concrete, initializes Employee)
// --------------------
contract Salaried is Employee {
    uint256 public annualSalary;

    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view virtual override returns (uint256) {
        return annualSalary;
    }
}

// --------------------
// Hourly (concrete, initializes Employee)
// ---------------
