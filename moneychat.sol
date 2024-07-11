// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MoneyChat {
    address public owner;

    struct User {
        address userAddress;
        uint256 balance;
    }

    mapping(address => User) public users;

    event UserRegistered(address userAddress);
    event DepositMade(address indexed userAddress, uint256 amount);
    event WithdrawalMade(address indexed userAddress, uint256 amount);
    event TransferMade(address indexed from, address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier userExists(address _userAddress) {
        require(users[_userAddress].userAddress != address(0), "User does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerUser() public {
        require(users[msg.sender].userAddress == address(0), "User already registered");
        users[msg.sender] = User(msg.sender, 0);
        emit UserRegistered(msg.sender);
    }

    function deposit() public payable userExists(msg.sender) {
        users[msg.sender].balance += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public userExists(msg.sender) {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");
        users[msg.sender].balance -= _amount;
        payable(msg.sender).transfer(_amount);
        emit WithdrawalMade(msg.sender, _amount);
    }

    function transfer(address _to, uint256 _amount) public userExists(msg.sender) userExists(_to) {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");
        users[msg.sender].balance -= _amount;
        users[_to].balance += _amount;
        emit TransferMade(msg.sender, _to, _amount);
    }

    function getBalance(address _userAddress) public view userExists(_userAddress) returns (uint256) {
        return users[_userAddress].balance;
    }

    function getMyBalance() public view userExists(msg.sender) returns (uint256) {
        return users[msg.sender].balance;
    }
}

