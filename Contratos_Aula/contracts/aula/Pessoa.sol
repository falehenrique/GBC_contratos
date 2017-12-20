
pragma solidity ^0.4.18;

// import "../Owner.sol";

contract Owner {
    //atributos
    address public dono;
    modifier apenasDono() {
        require (msg.sender == dono);
        _;
    }
  function destroir() apenasDono public {
    selfdestruct(dono);
  }       
}
contract Pessoa is Owner {
    string public nome;
    string public email;
    int8 public validacoesPositivas;
    int8 public validacoesNegativas;
    address[] public validacoes;
    
    event LogPersonEmailAlterado(address _pessoa, string emailAlterado); 
    event LogValid(address _enderecoValidador, address _enderecoContaValidador, address _enderecoContrato, bool valido);
    
    function Pessoa(string _nome, string _email) public {
        nome = _nome;
        email = _email;
        dono = msg.sender;
    }
    
    function mudarEmail(string _newMail) public apenasDono {
       email = _newMail;
    }

    function validar(bool _valido) public
    {
        require(tx.origin != dono);
        validacoes.push(msg.sender);
        if (_valido) {
            validacoesPositivas += 1;
        } else {
            validacoesNegativas += 1;
        }
        LogValid(msg.sender, tx.origin, this, _valido);
    }

    function validarPessoa(address _contratoPessoa, bool _valido) public apenasDono
    {
        Pessoa person = Pessoa(_contratoPessoa);
        person.validar(_valido);
    }

    function retornaValidacoes() public view returns (uint) {
        return validacoes.length;
    }

}