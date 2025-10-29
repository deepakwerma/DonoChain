// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparentDonations {
    address public owner;
    uint256 public totalDonations;

    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
    }

    Donation[] public donations;

    event Donated(address indexed donor, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed to, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Anyone can donate Ether
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0");

        donations.push(Donation(msg.sender, msg.value, block.timestamp));
        totalDonations += msg.value;

        emit Donated(msg.sender, msg.value, block.timestamp);
    }

    // Owner can withdraw donations to distribute them
    function withdraw(address payable _to, uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Not enough balance");

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(_to, _amount, block.timestamp);
    }

    // Get number of donations
    function getDonationCount() external view returns (uint256) {
        return donations.length;
    }

    // Get a specific donation record
    function getDonation(uint256 _index) external view returns (address, uint256, uint256) {
        require(_index < donations.length, "Invalid index");
        Donation memory d = donations[_index];
        return (d.donor, d.amount, d.timestamp);
    }

    // Get the current contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
