pragma solidity ^0.8.0;

contract crowdFunding{
    mapping (address => uint) public contributor;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct Request{
		string eventName;
		address payable recipient;
		uint value;
		bool completed;
		uint noOfVoters;
		mapping(address=>bool) voters;
	}
	mapping(uint=>Request) public requests;
	uint public numRequests;

    constructor(uint _target, uint _deadline){
        target = _target;
        deadline = block.timestamp+_deadline;
        minimumContribution = 100 wei;
        noOfContributors = 0;
        manager = msg.sender;
    }

    function sendEth() public payable{
        require(manager!=msg.sender, "Manager cannot distribute");
        require(block.timestamp<deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum contribution is not met");

        if(contributor[msg.sender]==0){
            noOfContributors++;
        }
        contributor[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function refund() public{
        require(block.timestamp>deadline && raisedAmount<target, "You are not eliginble for refund");
        require(contributor[msg.sender]>0,"No contributions make");
        address payable user = payable(msg.sender);
        user.transfer(contributor[msg.sender]);
        contributor[msg.sender]=0;
    }

    modifier onlyManager(){
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function createRequest(string memory _description, address payable _recipient,uint _value) public onlyManager{
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.eventName = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters =0;

    }

    function voteRequest(uint _requestNo) public {
		require(contributor[msg.sender] > 0, "You must be contributor");
		Request storage thisRequest = requests[_requestNo];
		require(thisRequest.voters[msg.sender] == false, "You have already voted");
		thisRequest.voters[msg.sender] = true;
		thisRequest.noOfVoters++;
	}

	function makePayment(uint _requestNo) public {
		require(raisedAmount >= target);
		Request storage thisRequest = requests[_requestNo];
		require(thisRequest.completed == false, "The request has been completed");
		require(thisRequest.noOfVoters > noOfContributors/2, "Majoruty does not support");
		thisRequest.recipient.transfer(thisRequest.value);
		thisRequest.completed = true;
	}

}
