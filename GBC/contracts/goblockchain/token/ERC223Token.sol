pragma solidity ^0.4.18;

import "../lib/Util.sol";
import "./ERC223.sol";
import "./ContractReceiver.sol";
import "../../zeppelin/math/SafeMath.sol";
import "../../zeppelin/ownership/Ownable.sol";

contract ERC223Token is ERC223, Ownable {
    using Util for address;
    string public name = "GoBlockchain Token";
    uint8 public decimals = 0;
    string public symbol = "GBC";
    string public version = "GBC 1.0";
    uint256 public totalSupply;
    mapping(address => uint) balancesOf;
    event LogAddTokenEvent(address indexed to, uint value);
    event LogDestroyEvent(address indexed from, uint value);

    function ERC223Token(uint256 _totalSupply) public {
        totalSupply = _totalSupply;
        balancesOf[msg.sender] = _totalSupply;
    }

    // Get the total token supply
    function totalSupply() public view returns (uint256 _supply) {
        return totalSupply;
    }

    // Returns the name of the token
    function name() public view returns (string _name) {
        return name;
    }
    //Returns the symbol of the token
    function symbol() public view returns (string _symbol) {
        return symbol;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public onlyOwner returns (bool ok) {
        require(balancesOf[msg.sender] >= _value);
        balancesOf[msg.sender] -= _value;
        balancesOf[_to] += _value;
        return true;
    }

    function transfer(address _to, uint _value, bytes _data) public onlyOwner returns (bool success) {
        require(balancesOf[msg.sender] >= _value);
        if (_to.isContract()) {
            transferToContract(_to, _value, _data);
            return true;
        }
        balancesOf[msg.sender] -= _value;
        balancesOf[_to] += _value;

        Transfer(msg.sender, _to, _value, _data);
        return true;
    }
  
    function transferToContract(address _to, uint _value, bytes _data) private onlyOwner returns (bool success) {
        // if (balanceOf(msg.sender) < _value) throw;
        require(balancesOf[msg.sender] >= _value);
        
        balancesOf[msg.sender] -= _value;
        balancesOf[_to] += _value;
        ContractReceiver receiver = ContractReceiver(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
        Transfer(msg.sender, _to, _value, _data);
        return true;
    }

    function balanceOf(address who) public view returns (uint balance) {
        return balancesOf[who];
    }

    function add(address _to, uint256 _value) public onlyOwner {
        totalSupply += _value;
        balancesOf[_to] += _value;

        LogAddTokenEvent(_to, _value);
    }

    function destroy(address _from, uint256 _value) public onlyOwner {
        totalSupply -= _value;
        balancesOf[_from] -= _value;
        LogDestroyEvent(_from, _value);
    }
}