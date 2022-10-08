// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Crownfunding{
    uint public goal;
    uint public deadline;
    uint public balance;
    mapping (address => uint) public contributor;
    address public owner;
    uint public noOfRequests;
    uint public noOfVoters;
    bool public activeVoter;

    mapping (uint => Request) public requests;

    struct Request {
        uint noOfVotes;
        string description;
        uint amount;
        mapping(address => bool) hasVoted;
        bool isRequestLive;
    }




    constructor (uint _goal , uint _deadline){
        goal = _goal;
        deadline = _deadline;
        owner = msg.sender;
    }

    modifier _onlyOwner {
        require(msg.sender == owner,"Not the owner");
        _;
    }

    function _contribute(uint amount) public payable {
         if(contributor[msg.sender] == 0 && msg.sender!=owner){
            noOfVoters++;
        }
        activeVoter = true;
        contributor[msg.sender] += amount;
        balance+=amount;
    }
    
    function _spendingRequest(string memory _description, uint _amount) public _onlyOwner {
        Request storage request = requests[noOfRequests];
        noOfRequests++;

        request.amount = _amount;
        request.description = _description;
    }

    function _vote(uint _index) public {
        require(msg.sender!=owner,"You are the owner");
        require(activeVoter==true,"Not an active voter");
        Request storage request = requests[_index];
        require(request.hasVoted[msg.sender] == false,"already voted");
        request.noOfVotes++;
        request.hasVoted[msg.sender] = true;
    }

    function _claimRequest(uint _index) public payable _onlyOwner {
        Request storage request = requests[_index];
        require(request.isRequestLive == false,"This request has been closed");
        require(request.noOfVotes >= noOfVoters/2,"Not enough votes");
            payable(msg.sender).transfer(request.amount);
            request.isRequestLive = true;
    }

}