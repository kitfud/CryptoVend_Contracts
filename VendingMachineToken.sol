//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract VendingMachineToken is ERC721URIStorage, Ownable {
    
    using Counters for Counters.Counter;
    address public vendingFactoryOwner; 
    Counters.Counter private _tokenIds;
    string public NFT_URI = "https://ipfs.io/ipfs/QmZYukMQtvNAm6h3pDpS6TFtxr9eRxYhwvtrYDEZzFavgg?filename=VendingMachine.json";
    uint256 public NFTcost; 

    constructor(address owner, uint256 cost) ERC721("Vending Machine", "VEND") {
        vendingFactoryOwner = owner; 
        NFTcost = cost;
    }

   modifier onlyVendingOwner (address sender){
    require(vendingFactoryOwner==sender,"Only for Vending Factory Owner");
    _;
    }

    function setNFTPrice(uint256 newPrice, address sender) public onlyVendingOwner(sender){
        NFTcost = newPrice; 
    }

    function mintNFT(address owner, uint _amount)
        public
        payable 
        returns (uint256)
    {
        require (_amount>=NFTcost,"Send more eth to buy NFT");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(owner, newItemId);
        _setTokenURI(newItemId, NFT_URI);

        return newItemId;
    }

}


