pragma solidity ^0.4.18;

contract RegistroContratos {
    address donoContrato;
    address[] public enderecoValidacao;
    mapping (address=>bool) contratoValido;
    function RegistroContratos() public {
        donoContrato = msg.sender;
    }

    modifier apenasDono() {
        require(msg.sender == donoContrato);
        _;
    }

    function getEnderecoContrato() returns(address) {
        return enderecoValidacao[enderecoValidacao.length];
    }

    function alterarContratoValidacao(address _novoEndereco) public apenasDono() {
        enderecoValidacao.push(_novoEndereco);
        address contratoAnterior = enderecoValidacao[enderecoValidacao.length - 1];
        contratoValido[_novoEndereco] = true;
        contratoValido[contratoAnterior] = false;
    }

}

contract ValidadorCPF {
    event LogValidarCPF(address _pessoa, uint cpf); 

    function validaMeuCPF(uint cpf, address contratoPessoa) public {
        LogValidarCPF(contratoPessoa, cpf);
    }

    function cpfValidado(address contratoPessoa, bool cpfValidado) public {
        Pessoa pessoa = Pessoa(contratoPessoa);
        pessoa.cpfValidado(cpfValidado);
    }
}
        