pragma solidity ^0.4.18;

import "../../zeppelin/lifecycle/Destructible.sol";
import "../teacher/Teacher.sol";

contract Student is Destructible {
    address addressStudent;
    Certificate[] public certificates;
    event LogEventReceiveCertificate(address addressTeacher, int codeCourse);

    struct Certificate {
        address addressTeacher;
        int codeCourse;
        int8 qtdHours;
        string nameCourse;
    }

    function Student(address _addressPersonStudent) public {
        addressStudent = _addressPersonStudent;
    }

    function subscribeCourse(address _addressTeacher, int _codeCourse) public {
        // instanciar o contrato e realizar a inscrição no curso
        Teacher teacher = Teacher(_addressTeacher);
        teacher.subscribeCourse(this, _codeCourse);        
    }

    function sendReputation(address _addressTeacher, int _codeCourse, int8 _reputation, string _comments) public {
        Teacher teacher = Teacher(_addressTeacher);
        teacher.sendReputation(this, _codeCourse, _reputation, _comments);
    }  

    // function gerarCertificado(address _enderecoProfessor, int codigoCurso, string nomeCurso, int8 qtdHoras) public {
    //     certificados.push (
    //         Certificados ({
    //             enderecoContratoProfessor: _enderecoProfessor,
    //             codigoCurso: codigoCurso,
    //             qtdHoras: qtdHoras,
    //             nomeCurso: nomeCurso
    //         })
    //     );
    //     LogEventCertificado(_enderecoProfessor, codigoCurso);
    // }
    
    // function enviarReputacaoCurso(address _enderecoContratoProfessor, int _codigoCurso, uint8 _reputacao, string _comentarios) public {
    //     Professor prof = Professor(_enderecoContratoProfessor);
    //     prof.receberReputacao(this, _reputacao, _codigoCurso, _comentarios, true);
    // }    
}

