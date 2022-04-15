// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./MyNFT.sol";
import "./Xtoken.sol";

contract MarketPlace is MyNFT,Xtoken {
	struct Item {
	    string description;
	    address seller;
	    address buyer;
	    uint price;
	    bool sold;
	}

	mapping(uint256=>Item) public items;
	uint256 public itemCount;

	constructor () {
        itemCount = 0;
	}

	function getBalance(address addressForBalance) public view returns(uint){
        return balanceOf( addressForBalance );
    }

	function mintAndAddItemForSale(string memory tokenURI, string memory _description, uint _price) public returns(uint) {
	    itemCount++;
        mintNFT(msg.sender, msg.sender, tokenURI, itemCount);
        approve(address(this), itemCount);
	    items[itemCount].description = _description;
	    items[itemCount].seller = msg.sender;
	    items[itemCount].price = _price;
	    return itemCount;
	}

	function getItem(uint _index) public view returns(string memory, uint){
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    return(i.description, i.price);
	}

	function checkItemExisting(uint _index) public view returns (bool) {
	    Item storage i = items[_index];
	    return (i.seller != address(0));
	}

	function checkItemSold(uint _index) public view returns (bool) {
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    return i.sold;
	}

	function removeItem(uint _index) public {
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    require(i.seller == msg.sender, "only seller can remove item");
	    require(!i.sold, "item sold already");
	    delete items[_index];
	}

	function buyItem(uint _index) public {
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    require(!i.sold, "item sold already");
	    require(i.price <= balanceOf( msg.sender ), "not enough tokens");
	    i.buyer = msg.sender;
	    i.sold = true;
	    transferFrom (msg.sender, i.seller, i.price);
        safeTransferFrom(address(this), msg.sender, _index);

	}

}
