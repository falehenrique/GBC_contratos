pragma solidity ^0.4.18;



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

library Util {
    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _addr) internal view returns (bool) {
        uint length;
        assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return (length>0);
    }
}

 /*
 * Contract that is working with ERC223 tokens
 */ 
 contract ContractReceiver {
     
    struct TKN {
        address sender;
        uint value;
        bytes data;
        bytes4 sig;
    }
    
    function tokenFallback(address _from, uint _value, bytes _data) public pure {
      TKN memory tkn;
      tkn.sender = _from;
      tkn.value = _value;
      tkn.data = _data;
      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
      tkn.sig = bytes4(u);
      
      /* tkn variable is analogue of msg variable of Ether transaction
      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
      *  tkn.value the number of tokens that were sent   (analogue of msg.value)
      *  tkn.data is data of token transaction   (analogue of msg.data)
      *  tkn.sig is 4 bytes signature of function
      *  if data of token transaction is a function execution
      */
    }
}

 /* New ERC23 contract interface */
 //https://github.com/ethereum/EIPs/issues/223
contract ERC223 {
  uint public totalSupply;
  // Get the account balance of another account with address _owner
  function balanceOf(address who) public constant returns (uint);
  // Returns the name of the token
  function name() public constant returns (string _name);
  //Returns the symbol of the token
  function symbol() public constant returns (string _symbol);
  // Returns the uint8 number of decimals the token uses,
   //e.g.2 means to divide the token amount by 10^2 (100)
  function decimals() public constant returns (uint8 _decimals);
  // Get the total token supply
  function totalSupply() public constant returns (uint256 _supply);
  //Compatibility with ERC20 transfer
  function transfer(address to, uint value) public returns (bool ok);
  //_data can be attached to this token transaction and it will stay in blockchain forever (requires more gas). _data can be empty.
  //function that is always called when someone wants to transfer tokens.
  function transfer(address to, uint value, bytes data) public returns (bool ok);

  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract ERC223Token is ERC223, Ownable {
    using SafeMath for uint256;
    using Util for address;
    string public name = "GoBlockchain Token";
    uint8 public decimals = 0;
    string public symbol = "GBC";
    string public version = "GBC 1.0";
    uint256 public totalSupply = 100000;

    mapping(address => uint) balances;
    event LogAddTokenEvent(address indexed to, uint value);
    event LogDestroyEvent(address indexed from, uint value);

    // Constructor
    function ERC223Token(uint256 _totalSupply) public {
        owner = msg.sender;
        totalSupply = _totalSupply;
        balances[owner] = _totalSupply;
    }

    // Function to access total supply of tokens .
    function totalSupply() public view returns (uint256 _totalSupply) {
        return totalSupply;
    }

    //function that is called when transaction target is an address
    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
        //if (balanceOf(msg.sender) < _value) throw;
        assert (balanceOf(msg.sender) < _value);
        if (_to.isContract()){
            transferToContract(_to, _value, _data);
            return true;
        }
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
    function add(address _to, uint256 _value) public onlyOwner {
        totalSupply = totalSupply.add(_value);
        balances[_to] = balances[_to].add(_value);

        LogAddTokenEvent(_to, _value);
    }

    function destroy(address _from, uint256 _value) public onlyOwner {
        totalSupply = totalSupply.sub(_value);
        balances[_from] = balances[_from].sub(_value);

        LogDestroyEvent(_from, _value);
    } 
}