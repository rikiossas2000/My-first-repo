// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
======================================================
 DEPLOY INSTRUCTIONS
======================================================
 1️⃣ Deploy `Salesperson` contract
    - Select `Salesperson` from dropdown
    - Click Deploy
    - Copy address

 2️⃣ Deploy `EngineeringManager` contract
    - Select `EngineeringManager` from dropdown
    - Click Deploy
    - Copy address

 3️⃣ Deploy `InheritanceSubmission` contract
    - Select `InheritanceSubmission` from dropdown
    - Input both addresses from Step 1 & 2
    - Click Deploy
    - Submit this contract’s address to Base.org
======================================================
*/

// 1️⃣ Abstract Employee Contract
abstract contract Employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint256);
}

// 2️⃣ Salaried Contract
contract Salaried is Employee {
    uint256 public annualSalary;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _annualSalary)
        Employee(_idNumber, _managerId)
    {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view virtual override returns (uint256) {
        return annualSalary;
    }
}

// 3️⃣ Hourly Contract
contract Hourly is Employee {
    uint256 public hourlyRate;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _hourlyRate)
        Employee(_idNumber, _managerId)
    {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view virtual override returns (uint256) {
        // 40 jam per minggu × 52 minggu = 2080 jam per tahun
        return hourlyRate * 2080;
    }
}

// 4️⃣ Manager Contract
contract Manager {
    uint256[] public employeeIds;

    function addReport(uint256 _employeeId) public {
        employeeIds.push(_employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }

    function getReports() public view returns (uint256[] memory) {
        return employeeIds;
    }
}

// 5️⃣ Salesperson Contract (DEPLOY INI DULU)
contract Salesperson is Hourly {
    constructor() Hourly(55555, 12345, 20) {}
}

// 6️⃣ EngineeringManager Contract (DEPLOY KEDUA)
contract EngineeringManager is Salaried, Manager {
    constructor() Salaried(54321, 11111, 200000) {}
}

// 7️⃣ InheritanceSubmission Contract (UNTUK SUBMIT PIN)
contract InheritanceSubmission {
    address public salesperson;
    address public engineeringManager;

    constructor(address _salesperson, address _engineeringManager) {
        salesperson = _salesperson;
        engineeringManager = _engineeringManager;
    }
}
