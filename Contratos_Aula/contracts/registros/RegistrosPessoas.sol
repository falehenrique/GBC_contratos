pragma solidity ^0.4.16;

contract RegistrosPessoas {
    address[] public listaContaPessoas;
    mapping(address => address) mapaPessoas;
    event LogPersonSalvaNoRegistro(address _contaPessoa, address _contaContratoPessoa); 

    function salvaPessoas(address enderecoContratoPessoa) public returns(bool) {
        listaContaPessoas.push(msg.sender);
        mapaPessoas[msg.sender] = enderecoContratoPessoa;  
        LogPersonSalvaNoRegistro(msg.sender, this);
    }
}