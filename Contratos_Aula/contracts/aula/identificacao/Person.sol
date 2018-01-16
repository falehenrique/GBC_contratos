// prama informa a EVM a versão do solidity, 
pragma solidity ^0.4.18;

contract Owner {
    address public owner;
    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }
  function destroir() onlyOwner public {
    selfdestruct(owner);
  }    

  function kill() public onlyOwner {
      selfdestruct(0);
  }  
}

contract IPerson {
    
    function changeEmail(string _newMail) public;
    function sendValidationIdentity(address _addressPerson, bool _isValid) public;
    function validatorIdentity(address _contractPersonValidator, bool isValid) public;
}

contract Person is IPerson, Owner {
    //date of create
    uint public dateCreate;
    uint identificationPerson;

    //name of person
    string public name;

    //variables to be validates
    string public email;
    mapping(bytes32 => bool) public isValidEmail;

    int8 public phone;
    int16 public identificationCellPhone;
    bool public isValidPhone;

    bytes32 public addressIPFSPhoto;
    mapping(address => bool) public isValidAddressIPFSPhoto;

    address[] public listCellPhoneValidator;
    mapping(address => bool) public mapCellPhoneValidator;

    //validator allowed
    mapping (address=>bool) listMapAddressValidator;

    //total personValidator
    int totalPersonValid;
    int totalPersonInvalid;

    //events
    event LogPersonValidator(address _contractPersonValidator, bool _isValid);
    event LogUpdateEmail(address _addressPerson, string _newEmail); 
    event LogUpdatePhoto(address _addressPerson, string _newEmail);
    event LogValidateCellPhone(address _owner, address _contractIdentity, int8 _phone, uint _identificationPerson);
    event LogValidateEmail(address _owner, address _contractIdentity, string _email, uint _identificationPerson);

    // constructor
    function Person(string _name, string _email, int8 _phone) public {
        name = _name;
        email = _email;
        phone = _phone;
        owner = msg.sender;
        dateCreate = now;
        identificationPerson = block.number;
        validateCellPhone(this, phone, identificationPerson);
        validateEmail(this, email, identificationPerson);
    }

    //modifiers to check is the address is a validator
    modifier onlyValidator(address _validator) {
        require(listMapAddressValidator[_validator]);
        _;
    }   

    // change the email
    function changeEmail(string _newMail) public onlyOwner {
        email = _newMail;
        LogUpdateEmail(this, email);
    }

    //add the validator
    function addValidator(address _validator) external onlyOwner {
        require(listMapAddressValidator[_validator]);
        listMapAddressValidator[_validator] = true;
    }
    
    function validateCellPhone(address _contractIdentity, int8 _phone, uint _identificationPerson) private onlyOwner {
        LogValidateCellPhone(owner, _contractIdentity, _phone, _identificationPerson);
    }
        
    function validateEmail(address _contractIdentity, string _email, uint _identificationPerson) private onlyOwner {
        LogValidateEmail(owner, _contractIdentity, _email, _identificationPerson);
    } 
    // set the cellphone identification
    // call in application mobile
    function validateCellPhone(int8 _identicationCellPhone, uint _randonNumber) private view onlyOwner returns(bool) {
        require(_identicationCellPhone > 0);
        require(_randonNumber > 0);
        require(_identicationCellPhone == identificationCellPhone);
        if (identificationPerson == _randonNumber) {
            return true;
        }
        return false;
    }  

    function sendValidationIdentity(address _addressPerson, bool _isValid) public onlyOwner {
        Person person = Person(_addressPerson);
        person.validatorIdentity(this, _isValid);
    }
    
    function validatorIdentity(address _contractPersonValidator, bool isValid) public {
        require(tx.origin != owner);
        require(address(msg.sender) != address(this));

        Person person = Person(_contractPersonValidator);
        require(person.isValidPhone());
        require(person.identificationCellPhone() != identificationCellPhone);

        if (isValid) {
            totalPersonValid++;
        } else {
            totalPersonInvalid++;
        }
        LogPersonValidator(_contractPersonValidator, isValid);
    }
}