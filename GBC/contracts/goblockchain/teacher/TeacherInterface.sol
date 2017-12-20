pragma solidity ^0.4.18;

contract TeacherInterface {
    
    event LogCourseCreated(int64 codeCourse);
    event LogStudentRegistered(address addressStudent, int64 codeCourse);
    event LogEventReceiveReputation(address addressStudent, int8 reputation);
    event LogEventSendCertificate(address addressStudent, int64 codeCourse);

    struct Course {
        int64 code;
        string name;
        int8 score;        
        int8[] votes;
        address[] addressStudent;
        mapping(address => bool) mapStudent;
    }

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
}