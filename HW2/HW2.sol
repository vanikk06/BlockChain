// ● 新增功能
//    1. 增加一個mapping check，確認address是否已經註冊過
//    2. 增加 receive() function


pragma solidity ^0.6.0;

contract Bank {
    
    mapping(string => address) public students;
    mapping(address => uint256) public balances;
    mapping(address => bool) public check;
    address payable public owner;
    
    constructor() public payable{
        owner = msg.sender;
    }
    
    function enroll(string memory studentID) public {
        students[studentID] = msg.sender;
        check[msg.sender] = true;
    }
    
    function deposit() public payable{
        require(msg.sender.balance >= msg.value, 'Not enough Ether.');
        require(check[msg.sender] == true, 'You are not enroll.');
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) public payable{
        require(check[msg.sender] == true, 'You are not enroll.');
        require(balances[msg.sender] >= amount, 'Insufficient Balance');
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
    
    function transfer(uint256 amount, address payable addr) public payable{
        require(check[msg.sender] == true, 'You are not enroll.');
        require(balances[msg.sender] >= amount, 'Insufficient Balance');
        balances[msg.sender] -= amount;
        balances[addr] += amount;
    }
   
    function getBalance() public view returns(uint256){
        require(check[msg.sender] == true, 'You are not enroll.');
        return balances[msg.sender];
    }
    
    function getBankBalance() public view returns(uint256){
        require(owner == msg.sender, 'Permission denied.');
        return address(this).balance;
    }
    
    fallback() external payable{
        require(owner == msg.sender, "You're not a owner.");
        selfdestruct(owner);
    }
    
    receive() external payable{
        require(owner == msg.sender, "You're not a boss.");
        address(this).transfer(msg.value);
    }
}
