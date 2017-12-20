pragma solidity ^0.4.18;


contract ContratoB {
    event LogContratoA(string log, address _contratoA);

    function chamarContratoA(address _contratoA) public {
        LogContratoA("entrou no contrato A", _contratoA);
        ContratoA contratoA = ContratoA(_contratoA);
        contratoA.eventoDisparadoPeloA("ola");
    }
}

contract ContratoA {
    event LogContratoA(string log);

    function execContratoB(address _contratoB) public {
        ContratoB contratoB = ContratoB(_contratoB);
        contratoB.chamarContratoA(this);
    }

    function eventoDisparadoPeloA(string _message) public {
        LogContratoA(_message);
    }
}