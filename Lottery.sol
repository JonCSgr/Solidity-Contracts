// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
   address public owner;
   address payable[] public players;

    constructor(){
        owner = msg.sender;
    }

   receive() payable external {
       require(msg.value == 0.1 ether);
       players.push(payable(msg.sender));
   }

   function getBalance() public view returns(uint){
       return address(this).balance;
   }

   function getTotalPlayers() public view returns(uint){
       return players.length;
   }

   function drawWinner() public {
       require(owner == msg.sender);
       require(players.length >= 3);
       
       uint index = random() % players.length;
       address payable winnerAddress = players[index];
       winnerAddress.transfer(getBalance());
       players = new address payable[](0);
   }

    function random() internal  view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty,block.timestamp,players.length)));
    }


}
