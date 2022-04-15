// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// npm install @openzeppelin/contracts

contract MyNFT is ERC721URIStorage {
    address marketOwner ;

    constructor() ERC721("MyNFT", "NFT") {    // SC Name and symbol
        marketOwner = msg.sender;
    }    

function mintNFT(address isMarketOwner, address recipient, string memory tokenURI, uint256 _tokenIds) 
    public returns(uint256)        
    {
       require(isMarketOwner == marketOwner, "not market owner"); // not exists
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;     //  id if NFT minted
    }
}
