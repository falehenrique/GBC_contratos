pragma solidity ^0.4.18;

contract AlunoComToken {
    event LogBalance(uint contractBalance, uint userBalance);
    event Deposit(
        address indexed _from,
        uint _value,
        string text
    );    
    function AlunoComToken() public payable {
        require(msg.value > 0 ether);
    }

    function retirada() public {
        LogBalance(this.balance, msg.sender.balance);
        msg.sender.transfer(this.balance);
        LogBalance(this.balance, msg.sender.balance);
    }

    function deposito(string text) public payable {
        Deposit(msg.sender, msg.value, text);
    }    
}
