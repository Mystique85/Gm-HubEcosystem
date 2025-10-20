/**
 *Submitted for verification at celoscan.io on 2025-10-20
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GMDapp {
    // Fee for sending GM (in Wei)
    uint256 public gmFee = 0.01 ether;

    // Contract owner
    address public owner = msg.sender;

    // User data structure
    struct User {
        uint256 streak;        // consecutive days
        uint256 totalGM;       // total GM sent
        uint256 lastTimestamp; // last GM timestamp
    }

    mapping(address => User) public users;

    // Event for logging GM activity
    event GMSent(address indexed user, uint256 streak, uint256 totalGM);

    // --- PUBLIC FUNCTIONS ---

    // Send GM with fee
    function sayGM() external payable {
        require(msg.value >= gmFee, "Insufficient fee");

        User storage user = users[msg.sender];

        // Continue streak if last GM was within 24h
        if (block.timestamp - user.lastTimestamp <= 1 days) {
            user.streak += 1;
        } else {
            user.streak = 1;
        }

        user.totalGM += 1;
        user.lastTimestamp = block.timestamp;

        emit GMSent(msg.sender, user.streak, user.totalGM);
    }

    // Retrieve GM fee
    function getGmFee() external view returns (uint256) {
        return gmFee;
    }

    // Retrieve user statistics
    function getUserStats(address userAddr) external view returns (uint256 streak, uint256 totalGM, uint256 lastTimestamp) {
        User memory user = users[userAddr];
        return (user.streak, user.totalGM, user.lastTimestamp);
    }

    // --- ADMIN FUNCTIONS ---

    // Change GM fee
    function setGmFee(uint256 newFee) external {
        require(msg.sender == owner, "Only owner can set fee");
        gmFee = newFee;
    }

    // Withdraw contract balance
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}