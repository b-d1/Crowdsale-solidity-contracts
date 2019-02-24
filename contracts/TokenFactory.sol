pragma solidity ^0.5.0;

import './GenericCoin.sol';


contract TokenFactory {

    uint private numTokens;
    mapping (uint => address) private tokens;
    event TokenCreated(string indexed name, string indexed symbol, uint8 decimals);

    function createToken(string memory name, string memory symbol, uint8 decimals) public returns (uint, address) {
        address tokenAddress = address(new GenericCoin(name, symbol, decimals));
        uint tokenId = numTokens++;
        tokens[tokenId] = tokenAddress;
        emit TokenCreated(name, symbol, decimals);
        return (tokenId, tokenAddress);
    }

    function getNumTokens() public view returns (uint) {
        return numTokens;
    }


    function getTokenById(uint id) public view returns (address) {
        require(id >= 0, "Invalid ID");
        address token = tokens[id];
        return token;
    }


}
