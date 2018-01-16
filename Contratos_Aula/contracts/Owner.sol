pragma solidity ^0.4.18;

contract Owner {
    //atributos
    address public owner;
    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }
  function destroir() onlyOwner public {
    selfdestruct(owner);
  }    

  function kill() public onlyOwner {
      selfdestruct(0);
  }  
}