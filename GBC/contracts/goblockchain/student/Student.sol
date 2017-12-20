pragma solidity ^0.4.18;

import "../../zeppelin/lifecycle/Destructible.sol";
import "./StudentInterface.sol";
import "../teacher/Teacher.sol";

contract Student is StudentInterface, Destructible {

    function subscribeCourse(address _addressTeacher, int64 _codeCourse) public {
        // instanciar o contrato e realizar a inscrição no curso
        Professor teacher = Professor(_addressTeacher);
        teacher.subscribeCourse(this, _codeCourse);        
    }

    function sendReputationCourse(address _addressTeacher, int64 _codeCourse, int8 _reputation) public apenasDono {
        Teacher teacher = Teacher(_addressTeacher);
        teacher.sendReputation(this, _codeCourse, _reputation);
    }

    function receiveCertificate(address _addressTeacher, int64 _codeCourse, string _nameCourse) public {
        certificates.push (
            Certificate ({
                addressTeacher: _addressTeacher,
                codeCourse: _codeCourse,
                nameCourse: _nameCourse
            })
        );
        LogEventReceiveCertificate(_addressTeacher, _codeCourse, _nameCourse);
    }
       
}