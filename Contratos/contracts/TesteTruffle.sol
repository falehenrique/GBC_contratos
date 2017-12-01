pragma solidity ^0.4.13;

contract TesteTruffle {
    string public nomeTeste;
    function TesteTruffle() public {
        nomeTeste = "henrique";
    }

    function getNome() public view returns(string) {
        return nomeTeste;
    }
}