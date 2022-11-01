//Name - Kushal Shah   UID - 2019140057


pragma solidity >=0.5.0 <0.9.0;

contract Credit{
    uint creditLimit = 10000;

    address owner;
    constructor(){
        owner = msg.sender;
        creditLimit = 10000;
    }

    function getCreditLimit() public view returns(uint){
        require(owner == msg.sender, "Only owner can access the function");
        return creditLimit;
    }

    function expenses(uint travel, uint food, uint stay) public returns (string memory){
        
        creditLimit = creditLimit - travel - food - stay;
        if(creditLimit>=0){
            resetCreditLimit();
            return ("Cannot process the transaction");
        }
        return ("Transaction success");
    }

    function resetCreditLimit() public {
        creditLimit = 10000;
    }
     
}
