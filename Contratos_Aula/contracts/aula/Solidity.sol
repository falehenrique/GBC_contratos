
// prama informa a EVM a versão do solidity, 
pragma solidity ^0.4.18;

contract Solidity {
    //variável do tipo string
    string public nome;
    string public email;
    //variável do tipo int8, pode ir ate 256 bits
    int8 public validacoesPositivas;
    int8 public validacoesNegativas;

    //variável do tipo address 20 bits - membros internos balance e transfer
    //dono.balance e dono.transfer
    address public dono;

    // array de address
    address[] public validacoes;

    //variável do tipo struct 
    Documento public documento;

    //variável do tipo mapping, armazena chave e valor
    mapping(address => bool) public pessoaValidada;

    //struct
    // Define un nuevo tipo con dos campos.
    struct Documento {
        uint8 tipo;
        bytes64 addressImage;
    }

    //bool, uint, bytes1....bytes32, uint128()


    //eventos
    event LogPersonEmailAlterado(address _pessoa, string emailAlterado); 
    
    // mofidicarod que é executado antes de entrar na função
    //<=, <, ==, !=, >=, >
    modifier apenasDono(){
        require(msg.sender == dono)
        _;
    }

    // construtor
    function Pessoa(string _nome, string _email) public {
        nome = _nome;
        email = _email;
        dono = msg.sender;
    }
    
//function (<parameter types>) {internal|external|public|private} [constant{pure, view}] [modificador] [returns (<return types>)]

    // função com modificador
    function mudarEmail(string _newMail) public apenasDono {
       email = _newMail;
    }

    // função com pure, não altera e não acessa nenhuma variável da classe
    function nome() public view returns(string nome) {
       return nome;
    }

    // função com pure, não altera e não acessa nenhuma variável da classe
    function nome(string _email) public pure returns(bool emailValido) {
        bytes memory emailBytes = bytes(_email);
        if(emailBytes.length > 0) {
            return true;
        } else {
            return false;
        }
    }    

    // função com pure, não altera e não acessa nenhuma variável da classe
    function nomeEmail() public view returns(string nome, string email) {
       return (nome, email);
    }
}
