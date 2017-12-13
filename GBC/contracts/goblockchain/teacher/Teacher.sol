pragma solidity ^0.4.16;

import "../../zeppelin/ownership/Ownable.sol";

contract Teacher is Ownable {
    address addressTeacherPerson;
    uint16 public score;
    string public description;
    
    mapping(int => Course) public courses;
    Course[] public codeCourses;

    event LogCourseCreated(int codeCourse);
    event LogStudentRegistered(address addressStudent, int codeCourse, uint256 value);

    struct Course {
        int code;
        int8 qtdPersonLimit;
        string name;
        string description;
        uint8 qtdHours;
        int8 score;        
        int8[] votes;
        address[] addressStudent;
        uint256 price;
        mapping(address => bool) mapStudent;
        mapping(int => string) comments;
    }

    function Teacher(address _addressTeacherPerson, string _description) public {
        addressTeacherPerson = _addressTeacherPerson;
        description = _description;
    }

    function createCourse(int _codeCourse, int8 _qtdPersonLimit,
        string _name, string _description,
        uint8 _qtdHours, uint256 _price) public onlyOwner
    {

       courses[_codeCourse] = Course ({
            code: _codeCourse,
            qtdPersonLimit: _qtdPersonLimit,
            name: _name,
            description: _description,
            qtdHours: _qtdHours,
            score: 0,
            votes: new int8[](0),
            addressStudent: new address[](0),
            price: _price
        });

    }

    function subscribeCourse(address _addressStudent, int _codeCourse) public payable returns (bool) {
        require(courses[_codeCourse].qtdHours > 0);
        if (msg.value == courses[_codeCourse].price) {
            owner.transfer(msg.value);
            courses[_codeCourse].addressStudent.push(_addressStudent);
            LogStudentRegistered(_addressStudent, _codeCourse, msg.value);
            return true;
        } else {
            return false;
        }
    }

    function getTotalStudentByCourse(int _codeCourse) public view onlyOwner returns(uint256) {
        return courses[_codeCourse].addressStudent.length;
    }

    function getTotalCourses() public view onlyOwner returns(uint256) {
        return codeCourses.length;
    }

    function getNumVotos(int _codigoCurso) public view returns(uint256) {
        return courses[_codigoCurso].votes.length;
    }

    event LogEventReceiveReputation(address addressStudent, int8 _reputation);


    function sendReputation(address _addressStudent, int _codeCourse, int8 _reputation, string comments)
        public
        {
        courses[_codeCourse].comments[_reputation] = comments;
        courses[_codeCourse].votes.push(_reputation);
        courses[_codeCourse].mapStudent[_addressStudent] = true;

        LogEventReceiveReputation(_addressStudent, _reputation);

        // if (receberCertificado) {
        //     Aluno aluno = Aluno(enderecoAluno);
        //     aluno.gerarCertificado(this, listaCursos[codigoCurso].codigoCurso, listaCursos[codigoCurso].nomeCurso, listaCursos[codigoCurso].qtdHoras);
        // }
    }

}