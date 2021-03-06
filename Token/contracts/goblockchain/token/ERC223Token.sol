pragma solidity ^0.4.18;

import "./ERC223.sol";
import "./ContractReceiver.sol";
import "../../zeppelin/math/SafeMath.sol";

contract ERC223Token is ERC223 {
    using SafeMath for uint256;

    string public name = "GoBlockchain Token";
    uint8 public decimals = 0;
    string public symbol = "GBC";
    string public version = "GBC 1.0";
    uint256 public totalSupply;

    mapping(address => uint) balances;

    // Function to access total supply of tokens .
    function totalSupply() public view returns (uint256 _totalSupply) {
        return totalSupply;
    }

    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _addr) private view returns (bool) {
        uint length;
        assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return (length>0);
    }

    //function that is called when transaction target is an address
    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
        //if (balanceOf(msg.sender) < _value) throw;
        assert (balanceOf(msg.sender) < _value);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        Transfer(msg.sender, _to, _value, _data);
        return true;
    }
  
    //function that is called when transaction target is a contract
    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
        // if (balanceOf(msg.sender) < _value) throw;
        assert (balanceOf(msg.sender) < _value);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        ContractReceiver receiver = ContractReceiver(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
        Transfer(msg.sender, _to, _value, _data);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }    

}