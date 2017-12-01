pragma solidity ^0.4.16;

contract Owner {
    //atributos
    address public dono;
    modifier apenasDono() {
        require (msg.sender == dono);
        _;
    }
}