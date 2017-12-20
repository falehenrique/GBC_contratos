pragma solidity ^0.4.18;

import "../../zeppelin/lifecycle/Destructible.sol";
import "../student/StudentInterface.sol";
import "./TeacherInterface.sol";


    //Courses
    function createCourse(int64 _codeCourse, string _name) public;
    function listCourse() public;
    function totalStudentByCourse(int64 _codeCourse) public view returns(uint256);
    function subscribeCourse(address _addressStudent, int64 _codeCourse) public;
    function totalVotesByCourse(int64 _codeCourse) public view returns(uint256);
    function scoreCourse(int64 codeCourse) public view returns(int8 score, bool finish, uint256 totalStudent);

    //Teacher
    function score() public returns(uint8);

    //reputation
    function sendReputation(address _addressStudent, int64 _codeCourse, int8 _reputation) public;




contract Teacher is TeacherInterface, Destructible {
    string public description;
    
    mapping(int64 => Course) public courses;
    int8 public totalCourses;

    function Teacher(string _description) public {
        description = _description;
    }

    function createCourse(int64 _codeCourse, string _name) public onlyOwner {
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

    function getTotalStudentByCourse(int64 _codeCourse) public view returns(uint256) {
        return courses[_codeCourse].addressStudent.length;
    }

    function getNumVotos(int64 _codigoCurso) public view returns(uint256) {
        return courses[_codigoCurso].votes.length;
    }

    function sendReputation(address _addressStudent, int64 _codeCourse, int8 _reputation)
        public
        {
        assert(subscriptionConfirmed(_addressStudent, _codeCourse));

        StudentInterface student = StudentInterface(_addressStudent);
        student.receiveCertificate(this, _codeCourse, courses[_codeCourse].name);
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