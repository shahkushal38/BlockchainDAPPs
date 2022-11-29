pragma solidity ^0.8.0;

contract Student{
    string name;
    string email;
    uint contact;
    string college;
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require (msg.sender == owner, "Only owner can retrieve data");
        _;
    }
    function getStudentDetails(string memory _name, string memory _email, uint _contact, string memory _college) public {
        name = _name;
        email = _email;
        contact = _contact;
        college = _college;
    }

    function retrieve() onlyOwner public view returns(string memory, string memory, uint256, string memory){
        return (name, email, contact, college);
    }
}
