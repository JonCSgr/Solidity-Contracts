// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auction{
    address payable owner;
    enum State  {started, runnimg , ended, canceled}
    State public currentState;
    uint public highestBid;
    uint public realBid;
    uint public currentBid;
    uint public refund;
    address payable highestBidder;
    mapping(address => uint) public bids;

   constructor() {
       owner = payable (msg.sender);
       currentState = State.runnimg;
   }

    function placeBid() public payable {
        require(currentState == State.runnimg);
        currentBid = bids[msg.sender] + msg.value;
        require( currentBid > highestBid);
        
        bids[msg.sender] = currentBid;
        highestBid = currentBid;
        highestBidder = payable(msg.sender);
    }

    function auctionEnd() public onlyOwner {
        currentState= State.ended;
    }

    function refundIfLose() public payable winner {
        address payable recipient = payable(msg.sender);
        recipient.transfer(bids[msg.sender]);
        bids[msg.sender] = 0;
    }

    function refundWinner() public payable {
        require(currentState == State.ended);
        require(msg.sender == highestBidder);
        address payable temp = payable(msg.sender);
        refund = highestBid - currentBid;
        temp.transfer(refund);
        bids[msg.sender] = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier winner() {
        require(msg.sender != highestBidder);
        _;
    }

}
