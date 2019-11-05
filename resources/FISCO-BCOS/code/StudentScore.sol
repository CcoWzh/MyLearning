pragma solidity ^0.4.22;

contract StudentScore {
    
    uint totalScore;
    uint studentCount;
    address owner;
    
    mapping (string => address) studentMap; // studentId->student
    mapping (string => uint) scoreMap;      // studentId->score
    
    event studentNotExistsEvent(string studentId);
    
    modifier onlyOwner() {
        if(owner == msg.sender){
            _;
        }
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function addStudentScore(string studentId, address student, uint score) public onlyOwner {
        studentMap[studentId] = student;
        scoreMap[studentId] = score;
        totalScore += score;
        studentCount ++;
    }
    
    function modifyScoreByStudentId(string studentId, uint score) public onlyOwner{
        if(!studentExists(studentId)) {
            studentNotExistsEvent(studentId);
            return;
        }
        totalScore -= scoreMap[studentId];
        scoreMap[studentId] = score;
        totalScore += score; 
    }
    
    function getAvgScore() public view returns(uint){
        return totalScore / studentCount;
    }
    
    function getScoreByStudentId(string studentId) public constant returns(string, string, uint){
        if(!studentExists(studentId)) {
            studentNotExistsEvent(studentId);
            return;
        }
        Student student = Student(studentMap[studentId]);
        var studentName = student.getStudentName();
        uint score = scoreMap[studentId];
        return(studentId, studentName, score);
    }
    
    function studentExists(string studentId) public view returns(bool){
        address student = Student(studentMap[studentId]);
        if(student == 0x00){
            return false;
        }else{
            return true;
        }
    }
    
}
