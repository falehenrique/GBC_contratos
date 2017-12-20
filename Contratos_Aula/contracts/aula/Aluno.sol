pragma solidity ^0.4.18;

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

contract Professor is Owner {
    string public description;
    
    mapping(int64 => Course) public courses;
    int8 public totalCourses;

    event LogCourseCreated(int64 codeCourse);
    event LogStudentRegistered(address addressStudent, int64 codeCourse);
    event LogEventReceiveReputation(address addressStudent, int8 reputation);
    event LogEventCertificadoGerado(address addressStudent, int64 codeCourse);

    struct Course {
        int64 code;
        string name;
        int8 score;        
        int8[] votes;
        address[] addressStudent;
        mapping(address => bool) mapStudent;
    }

    function Professor(string _description) public {
        description = _description;
        dono = msg.sender;
    }

    function createCourse(int64 _codeCourse, string _name) public apenasDono {
       courses[_codeCourse] = Course ({
            code: _codeCourse,
            name: _name,
            score: 0,
            votes: new int8[](0),
            addressStudent: new address[](0)
        });
        totalCourses++;

        LogCourseCreated(_codeCourse);
    }

    function subscribeCourse(address _addressStudent, int64 _codeCourse) public {
        courses[_codeCourse].addressStudent.push(_addressStudent);
        courses[_codeCourse].mapStudent[_addressStudent] = true;
        LogStudentRegistered(_addressStudent, _codeCourse);
    }

    function subscriptionConfirmed(address _addressStudent, int64 _codeCourse) public view returns (bool) {
        return bool(courses[_codeCourse].mapStudent[_addressStudent]);
    }

    function getTotalStudentByCourse(int64 _codeCourse) public view apenasDono returns(uint256) {
        return courses[_codeCourse].addressStudent.length;
    }

    function getNumVotos(int64 _codigoCurso) public view returns(uint256) {
        return courses[_codigoCurso].votes.length;
    }

    event LogEventDebug(string _textoLog);
    function sendReputation(address _addressStudent, int64 _codeCourse, int8 _reputation)
        public
        {
        assert(subscriptionConfirmed(_addressStudent, _codeCourse));

        Student student = Student(_addressStudent);
        student.gerarCertificado(this, _codeCourse, courses[_codeCourse].name);
        LogEventCertificadoGerado(_addressStudent, _codeCourse);

        courses[_codeCourse].votes.push(_reputation);
        LogEventReceiveReputation(_addressStudent, _reputation);
    }

    function getScoreCourse(int64 codeCourse) public view returns(int8 score, bool finish, uint256 totalStudent) {
        Course storage course = courses[codeCourse];
        int8 scoreCourse = 0;
        for (uint256 i = 0; i < course.votes.length; i++) {
            scoreCourse += course.votes[i];
        }
        bool finishVotation = false;
        if (course.votes.length == course.addressStudent.length) {
            finishVotation = true;
        }
        return ((scoreCourse / int8(course.votes.length)), finishVotation, course.addressStudent.length);
    }
}

contract Student is Owner {
    Certificate[] public certificates;
    event LogEventReceiveCertificate(address addressTeacher, int64 codeCourse, string _nameCourse);

    struct Certificate {
        address addressTeacher;
        int64 codeCourse;
        string nameCourse;
    }

    function Student() public {
        dono = msg.sender;
    }

    function subscribeCourse(address _addressTeacher, int64 _codeCourse) public {
        // instanciar o contrato e realizar a inscrição no curso
        Professor teacher = Professor(_addressTeacher);
        teacher.subscribeCourse(this, _codeCourse);        
    }

    function sendReputationCourse(address _addressTeacher, int64 _codeCourse, int8 _reputation) public apenasDono {
        Professor teacher = Professor(_addressTeacher);
        teacher.sendReputation(this, _codeCourse, _reputation);
    }

    function gerarCertificado(address _addressTeacher, int64 _codeCourse, string _nameCourse) public {
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