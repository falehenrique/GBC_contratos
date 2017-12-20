// prama informa a EVM a versão do solidity, 
pragma solidity ^0.4.18;

contract Pessoa {
    //variável do tipo string
    string public nome;
    string public email;
    address public dono;
    
    //lista de validadores
    address[] public listaValidadores;
    int8 public totalValidos;

    //eventos
    event LogPersonEmailAlterado(address _pessoa, string emailAlterado); 
    event LogPersonNomeAlterado(address _pessoa, string nomeAlterado); 

    // construtor
    function Pessoa(string _nome, string _email) public {
        nome = _nome;
        email = _email;
        dono = msg.sender;
    }
    
    function validarPessoa(address _enderecoPessoa, bool _valido) public {
        Pessoa pessoa = Pessoa(_enderecoPessoa);
        pessoa.receberValidacao(this, _valido);
    }
    
    event LogContratoPessoaValidado(address contratoValidador, bool validado);
    function receberValidacao(address contratoValidador, bool validado) public {
        if (validado) {
            listaValidadores.push(contratoValidador);
            totalValidos++;
        }
        LogContratoPessoaValidado(contratoValidador, validado);
    }

    modifier apenasDono(){
        assert(msg.sender == dono);
        _;
    }

    // função com modificador
    function mudarEmail(string _newMail) public apenasDono(){
        email = _newMail;
        LogPersonEmailAlterado(this,email);
    }

    // função com modificador
    function mudarNome(string _newNome) public {
       nome = _newNome;
       LogPersonNomeAlterado(this, nome);
    }
    //function (<parameter types>) {internal|external|public|private} [constant{pure, view}] [modificador] [returns (<return types>)]

}