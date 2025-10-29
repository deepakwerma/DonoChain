# 💖 Transparent Donations Smart Contract

A simple and beginner-friendly Solidity smart contract for **transparent donation collection and distribution**.  
This contract allows anyone to donate Ether and provides full transparency by recording all donations on-chain.  
The contract owner can withdraw and distribute funds while everyone can verify all transactions.

---
<img width="1919" height="875" alt="Screenshot 2025-10-29 135514" src="https://github.com/user-attachments/assets/65dc51e6-9bc2-4b90-b67e-8022486fbba2" />
https://celo-sepolia.blockscout.com/address/0xd53D5a902FC8ECEB68BEE14909B8BDE2781CE729

## 🧠 Features

- ✅ Anyone can send Ether donations
- 🔍 All donations are publicly viewable on-chain
- 👑 Only the owner can withdraw/distribute funds
- 💰 Tracks total donations and contract balance
- ⏱ Records donor address, amount, and timestamp

---

## 🛠️ Smart Contract Code

File: `TransparentDonations.sol`

```solidity
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
