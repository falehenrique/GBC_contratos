
pragma solidity ^0.4.16;

import "../../zeppelin/lifecycle/Destructible.sol";
import "../token/ContractReceiver.sol";

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

    function validatePerson(bool _valid) public
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
        person.validatePerson(_valid);
    }

    function retornaValidacoes() public view returns (uint) {
        return validation.validators.length;
    }
}

