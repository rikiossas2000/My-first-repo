// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.3/contracts/token/ERC20/ERC20.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.3/contracts/utils/structs/EnumerableSet.sol";

error TokensClaimed();
error AllTokensClaimed();
error NoTokensHeld();
error QuorumTooHigh(uint quorum);
error AlreadyVoted();
error VotingClosed();

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint public constant maxSupply = 1_000_000;
    mapping(address => bool) private hasClaimed;

    enum Vote { AGAINST, FOR, ABSTAIN }

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    Issue[] private issues;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        issues.push(); // placeholder index 0
    }

    function claim() public {
        if (hasClaimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() + 100 > maxSupply) revert AllTokensClaimed();
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string calldata _issueDesc, uint _quorum)
        external
        returns (uint)
    {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();
        if (_quorum > totalSupply()) revert QuorumTooHigh(_quorum);

        issues.push();
        uint index = issues.length - 1;
        Issue storage isx = issues[index];
        isx.issueDesc = _issueDesc;
        isx.quorum = _quorum;
        return index;
    }

    function getIssue(uint _id) external view returns (ReturnableIssue memory) {
        Issue storage isx = issues[_id];
        return ReturnableIssue({
            voters: isx.voters.values(),
            issueDesc: isx.issueDesc,
            votesFor: isx.votesFor,
            votesAgainst: isx.votesAgainst,
            votesAbstain: isx.votesAbstain,
            totalVotes: isx.totalVotes,
            quorum: isx.quorum,
            passed: isx.passed,
            closed: isx.closed
        });
    }

    function vote(uint _issueId, Vote v) public {
        Issue storage isx = issues[_issueId];
        if (isx.closed) revert VotingClosed();
        if (!isx.voters.add(msg.sender)) revert AlreadyVoted();

        uint weight = balanceOf(msg.sender);
        if (weight == 0) revert NoTokensHeld();

        if (v == Vote.FOR) isx.votesFor += weight;
        else if (v == Vote.AGAINST) isx.votesAgainst += weight;
        else isx.votesAbstain += weight;

        isx.totalVotes += weight;

        if (isx.totalVotes >= isx.quorum) {
            isx.closed = true;
            if (isx.votesFor > isx.votesAgainst) isx.passed = true;
        }
    }

    function numberOfIssues() public view returns (uint) {
        return issues.length;
    }
}
