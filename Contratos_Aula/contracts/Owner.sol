pragma solidity ^0.4.18;

contract Owner {
    //atributos
    address public dono;
    modifier apenasDono() {
        require (msg.sender == dono);
        _;
    }
  function destroir() apenasDono public {
    selfdestruct(dono);
  }    
}