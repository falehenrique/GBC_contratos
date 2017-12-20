
pragma solidity ^0.4.18;

pragma solidity ^0.4.18;

 /* New ERC23 contract interface */
 //https://github.com/ethereum/EIPs/issues/223
contract ERC223 {
  // Get the total token supply
  function totalSupply() public view returns (uint _supply);
  // Returns the name of the token
  function name() public view returns (string _name);
  //Returns the symbol of the token
  function symbol() public view returns (string _symbol);
  //Compatibility with ERC20 transfer
  function transfer(address to, uint value) public returns (bool ok);

  //_data can be attached to this token transaction and it will stay in blockchain forever (requires more gas). _data can be empty.
  //function that is always called when someone wants to transfer tokens.
  function transfer(address to, uint value, bytes data) public returns (bool ok);

  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}