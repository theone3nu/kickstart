pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns(address[]) {
        return deployedCampaigns;
    }
}
contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        uint approvalCount;
        bool complete;
        mapping(address => bool) approvals;
    }

    address public manager;
    uint public minimumContribution;
    Request[] public requests;
    mapping(address => bool) public approvers;
    uint public approversCount;

    function Campaign(uint minimum, address creator) public {
        minimumContribution = minimum;
        manager = creator;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function createRequest(string description, uint value, address recipient) public restricted{
        Request memory request = Request(
            {description: description,
            value: value,
            recipient: recipient,
            approvalCount: 0,
            complete: false
            });
        requests.push(request);
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(request.approvalCount > (approversCount/2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns(uint, uint, uint, uint, address) {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns(uint) {
        return requests.length;
    }
}