// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Xtoken 
{

    string public constant tokenName = "XToken";
    string public constant tokenSymbol = "ERC20";
    address public tokenOwners;    

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 1 ether;
    using SafeMath for uint256;

    constructor() {                      
	balances[msg.sender] = totalSupply_;   
    tokenOwners = msg.sender;      
    }  

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }

    function balanceOfToken(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address sender, address receiver, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[sender]);
        balances[sender] = balances[sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        return true;
    }

    function approveTokens(address delegate, uint256 numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferTokensFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        return true;
    }

    function buy() payable public {
        uint256 amountTobuy = msg.value;
        uint256 dexBalance = balances[tokenOwners];  
        require(amountTobuy > 0, "You need to send some Ether");
        require(amountTobuy <= dexBalance, "Not enough tokens in reserve");
        transfer(tokenOwners , msg.sender, amountTobuy);
    }
}
    library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}    



