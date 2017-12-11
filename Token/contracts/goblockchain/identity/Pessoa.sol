
pragma solidity ^0.4.16;

import "../../zeppelin/lifecycle/Destructible.sol";
import "../token/ContractReceiver.sol";

contract Pessoa is Destructible, ContractReceiver {

    string public name;
    string public document;
    bool public isDocumentValid;
    string public email;
    bool public isEmailValid;
    string public phone;
    bool public isPhoneValid;    
    string public birthDate;
    address[] public validators;
    uint8 public positiveValidators;
    uint8 public negativeValidators;

    event LogValid(address _validatorAddress);
    event LogChangeEmail(string _email, address _contractPerson);
    event LogChangeDocument(string _document, address _contractPerson);
    event LogChangePhone(string _phone, address _contractPerson);


    function Pessoa (string _name, string _document, string _email, string _birthDate, string _phone) public
    {
        name = _name;
        document = _document;
        email = _email;
        birthDate = birthDate;
        phone = _phone;
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

    function validatePerson() internal {

    }

    function validatePerson(address contractPerson, bool valid) public onlyOwner
    {
        validadores.push(msg.sender);
        validacoes += 1;
        validado(msg.sender);
    }

    function retornaValidacoes() public view returns (uint8) {
        return validacoes;
    }
}

