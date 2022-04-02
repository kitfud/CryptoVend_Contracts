//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./VendingMachineToken.sol";

contract VendingMachine{

    VendingMachineToken factoryReference; 
    uint256 public tokenId;

    event Deposit(address payee, uint256 value, uint256 time, uint256 currentContractBalance);
    event Withdraw(uint256 time, uint256 amount);

    constructor (VendingMachineToken factory, uint256 id) payable{
        factoryReference = factory;
        tokenId = id;
    }

    modifier onlyOwner(address caller){
        require(caller == factoryReference.ownerOf(tokenId), "function is only for owner");
        _;
    }

    function getBalance(address caller) public view onlyOwner(caller) returns (uint256 balance){
        balance = address(this).balance;
    }

    function ownerWithdraw(address caller) public onlyOwner(caller) {
        uint256 contractBalance = address(this).balance;
        (bool sent,) = factoryReference.ownerOf(tokenId).call{value:address(this).balance}("");
        require(sent,"Failed to Send Ether");
        emit Withdraw(block.timestamp, contractBalance);
    }

    function getAddress() public view returns (address){
        return address(this);
    } 
    
    receive() external payable{
        emit Deposit(msg.sender, msg.value,block.timestamp, address(this).balance);
    }
}
