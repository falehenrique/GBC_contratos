
pragma solidity ^0.4.18;

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