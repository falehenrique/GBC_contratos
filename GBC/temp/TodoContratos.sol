
pragma solidity ^0.4.17;



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


/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {

  function Destructible() public payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}

pragma solidity ^0.4.18;

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

contract Person is Destructible, ContractReceiver {

    string public name;
    string public document;
    bool public isDocumentValid;
    string public email;
    bool public isEmailValid;
    string public phone;
    bool public isPhoneValid;    
    string public birthDate;
    Validation public validation;
    string public photo;

    event LogValid(address _validatorAddress, address _senderOrigin, address _contractPersonAddress, bool _isValid);
    event LogChangeEmail(string _email, address _contractPerson);
    event LogChangeDocument(string _document, address _contractPerson);
    event LogChangePhone(string _phone, address _contractPerson);
    event LogChangePhoto(string _photo, address _contractPerson);


    function Person (string _name, string _document, string _email, string _birthDate, string _phone) public
    {
        name = _name;
        document = _document;
        email = _email;
        birthDate = _birthDate;
        phone = _phone;
    }

    struct Validation {
        address[] validators;
        uint8 positiveValidators;
        uint8 negativeValidators;
    }

    function changeEmail (string _newEmail) public onlyOwner
    {
        email = _newEmail;
        isEmailValid = false;
        LogChangeEmail(email, this);
    }

    function changeDocument (string _newDocument) public onlyOwner
    {
        document = _newDocument;
        isDocumentValid = false;
        LogChangeDocument(document, this);
    }

    function changePhone (string _newPhone) public onlyOwner
    {
        phone = _newPhone;
        isPhoneValid = false;
        LogChangePhone(phone, this);
    }        

    function changePhoto (string _newPhoto) public onlyOwner
    {
        photo = _newPhoto;
        LogChangePhoto(_newPhoto, this);
    }

    function validate(bool _valid) public
    {
        require(tx.origin != owner);
        validation.validators.push(msg.sender);
        if (_valid){
            validation.positiveValidators += 1;
        } else {
            validation.negativeValidators += 1;
        }
        LogValid(msg.sender, tx.origin, this, _valid);
    }

    function validatePerson(address _contractPerson, bool _valid) public onlyOwner
    {
        Person person = Person(_contractPerson);
        person.validate(_valid);
    }

    function retornaValidacoes() public view returns (uint) {
        return validation.validators.length;
    }
}