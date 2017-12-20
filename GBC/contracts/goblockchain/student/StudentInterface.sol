pragma solidity ^0.4.18;

contract StudentInterface {
    Certificate[] public certificates;

    event LogEventReceiveCertificate(address addressTeacher, int64 codeCourse, string _nameCourse);

    struct Certificate {
        address addressTeacher;
        int64 codeCourse;
        string nameCourse;
    }

    function subscribeCourse(address _addressTeacher, int64 _codeCourse) public;
    function sendReputationCourse(address _addressTeacher, int64 _codeCourse, int8 _reputation) public;
    function receiveCertificate(address _addressTeacher, int64 _codeCourse, string _nameCourse) public;

}