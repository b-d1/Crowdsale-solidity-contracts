pragma solidity ^0.5.0;

import './GenericCoin.sol';
import './GenericCrowdsale.sol';


contract CrowdsaleFactory {


    struct Crowdsale {
        GenericCrowdsale contractAddress;
        string name;
    }

    uint private numCampaigns;
    uint private numTokens;
    mapping (uint => Crowdsale) private crowdsales;
    mapping (uint => address) private tokens;

    event TokenCreated(string indexed name, string indexed symbol, uint8 decimals);
    event CampaignCreated(string indexed name);


    function create(string memory campaignName, uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, string memory coinName, string memory coinSymbol, uint8 decimals) public returns (address, uint) {

        (uint tokenId, address tokenAddress) = createToken(coinName, coinSymbol, decimals);
        uint campaignId = createCampaign(campaignName, _openingTime, _closingTime, _rate, _wallet, ERC20Mintable(tokenAddress));
        return (address(tokenAddress), campaignId);
        //        ERC20Mintable genericCoin = ERC20Mintable(tokenAddress);
        //        genericCoin.addMinter(address(crowdsales[campaignId].contractAddress));
        //        created = true;

    }

    function createCampaign(string memory name, uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, ERC20Mintable token) internal returns (uint campaignId) {
        GenericCrowdsale crowdsaleAddress = new GenericCrowdsale(_openingTime, _closingTime, _rate, _wallet, token);
        campaignId = numCampaigns++;

        crowdsales[campaignId] = Crowdsale({contractAddress: crowdsaleAddress, name: name});
        emit CampaignCreated(name);
    }

    function createToken(string memory name, string memory symbol, uint8 decimals) internal returns (uint tokenId, address tokenAddress) {
        tokenAddress = address(new GenericCoin(name, symbol, decimals));
        tokenId = numTokens++;
        tokens[tokenId] = tokenAddress;
        emit TokenCreated(name, symbol, decimals);
    }

    function getTokenById(uint id) public returns (address) {
        require(id > 0, "Invalid ID");
        address token = tokens[id];
        return token;
    }

    function getNumTokens() public view returns (uint) {
        return numTokens;
    }

    function getNumCampaigns() public view returns (uint) {
        return numCampaigns;
    }

}