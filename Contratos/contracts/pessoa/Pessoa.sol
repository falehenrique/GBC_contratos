
pragma solidity ^0.4.16;

import "../registros/RegistrosPessoas.sol";
import "../Owner.sol";

contract Pessoa is Owner {
    string public nome;
    string public email;
    bool email_valido;
    int cpf;
    string dataNascimento;
    
    event LogPersonEmailAlterado(address _pessoa, string emailAlterado); 

    function Pessoa(string _nome, string _email, int _cpf, string _dataNascimento, address _enderecoRegistroPessoas) public {
        nome = _nome;
        email = _email;
        cpf = _cpf;
        dataNascimento = _dataNascimento;
        dono = msg.sender;
        RegistroPessoas(_enderecoRegistroPessoas).salvaPessoas(this);
    }
    
    function mudarEmail(string _newMail) public apenasDono {
       email = _newMail;
    }
}