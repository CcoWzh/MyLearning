pragma solidity ^0.4.22;

contract Student {
    string studentId;
    string studentName;
    address owner;
    // age sex major
    
    modifier onlyOwner() {
        if(owner == msg.sender){
            _;
        }
    }
    
    constructor(string _studentId, string _stdentName) public {
        studentId = _studentId;
        studentName = _stdentName;
        owner = msg.sender;
    }
    
    function getStudentName() public constant returns(string) {
        return studentName;
    }
    
    function setStudentName(string _studentName) public onlyOwner {
        studentName = _studentName;
    }
}