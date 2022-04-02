//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VendingMachine.sol";
import "./VendingMachineToken.sol";

contract VendingMachineFactory {
    address public factoryOwner; 
    VendingMachineToken tokenFactory;
    uint256 public currentNFTPrice;
    uint256 tokenCount; 

    mapping(uint256=>VendingMachine) public tokenIDToMachine;

    modifier onlyFactoryOwner (){
    require(factoryOwner==msg.sender,"Only for Vending Owner");
    _;
    }

    modifier onlyTokenOwner (){
    require(checkIfTokenHolder(msg.sender)==true, "Caller does not own any tokens.");
    _;
    }

    modifier onlyMachineOwner(uint256 tokenId){
    require(checkTokenOwnerById(tokenId)== msg.sender,"Only For Contract Owner.");
    _;
    }

    constructor(){
        currentNFTPrice = 20000000000000000;
        factoryOwner = msg.sender; 
        tokenFactory = new VendingMachineToken(msg.sender, currentNFTPrice);
        tokenCount =0;
    }

    function setNFTPrice(uint256 price) public onlyFactoryOwner{
        tokenFactory.setNFTPrice(price, msg.sender);
        currentNFTPrice = price;
    }

    function mintAgreement (uint256 payment) public payable {
        require(payment>=currentNFTPrice,"Payment is not meet NFT price.");
        tokenFactory.mintNFT(msg.sender, payment);
        tokenCount++;
        VendingMachine machine = new VendingMachine(tokenFactory,tokenCount);
        tokenIDToMachine[tokenCount] = machine;
    }

    function checkTokenOwnerById(uint tokenId) public view returns (address owner){
        owner = tokenFactory.ownerOf(tokenId);
    }

    function checkIfTokenHolder(address toSearch) public view returns (bool){
        for (uint i = 1; i<=tokenCount;i++){
            if(checkTokenOwnerById(i)== toSearch){
                return true;
            }
        }
        return false;
    }

    function addressToTokenID(address toSearch) public view onlyTokenOwner returns (uint256 [] memory){
         uint256 [] memory values = new uint256[](tokenCount);
         uint256 j;
         for (uint i = 1; i<=tokenCount;i++){
            if(checkTokenOwnerById(i)== toSearch){
                values[j]=i;
                j++;
            }
        }
        return values;
    }

    
    function getVendingContractAddressByToken(uint256 tokenId) public view returns (address){
       return tokenIDToMachine[tokenId].getAddress();
    }

    function getBalance(uint256 tokenId) public view onlyMachineOwner(tokenId) returns (uint256 balance){
        return tokenIDToMachine[tokenId].getBalance(msg.sender);

    }

    function ownerWithdraw(uint256 tokenId) public onlyMachineOwner(tokenId){
        tokenIDToMachine[tokenId].ownerWithdraw(msg.sender);
    }


}
