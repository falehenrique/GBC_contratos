pragma solidity ^0.4.18;

 /* New ERC23 contract interface */
 //https://github.com/ethereum/EIPs/issues/223
contract ERC223 {
  // Get the total token supply
  function totalSupply() public constant returns (uint _supply);

  //Compatibility with ERC20 transfer
  function transfer(address to, uint value) public returns (bool ok);

  //_data can be attached to this token transaction and it will stay in blockchain forever (requires more gas). _data can be empty.
  //function that is always called when someone wants to transfer tokens.
  function transfer(address to, uint value, bytes data) public returns (bool ok);

  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
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

contract ERC223Token is ERC223 {
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
    function totalSupply() public constant returns (uint256 _supply){
        return totalSupply;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool ok){
        require(balancesOf[msg.sender] >= _value);
        balancesOf[msg.sender] -= _value;
        balancesOf[_to] += _value;
        return true;
    }

    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
        require(balancesOf[msg.sender] >= _value);
        if (_to.isContract()){
            transferToContract(_to, _value, _data);
            return true;
        }
        balancesOf[msg.sender] -= _value;
        balancesOf[_to] += _value;

        Transfer(msg.sender, _to, _value, _data);
        return true;
    }
  
    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
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

    function add(address _to, uint256 _value) public {
        totalSupply += _value;
        balancesOf[_to] += _value;

        LogAddTokenEvent(_to, _value);
    }

    function destroy(address _from, uint256 _value) public {
        totalSupply -= _value;
        balancesOf[_from] -= _value;
        LogDestroyEvent(_from, _value);
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