pragma solidity ^0.5.0;

import './GenericCoin.sol';
import './GenericCrowdsale.sol';
import './GenericTimedCrowdsale.sol';
import './GenericTimedCappedCrowdsale.sol';
import './GenericTimedCappedRefundableCrowdsale.sol';


contract CrowdsaleFactory {


    struct CrowdsaleStruct {
        address contractAddress;
        string name;
    }

    enum CampaignType {
        Simple,
        Timed,
        TimedCapped,
        TimedCappedRefundable
    }


    uint private numCampaigns;
    uint private numTokens;
    mapping (uint => CrowdsaleStruct) private crowdsales;
    mapping (uint => address) private tokens;

    event TokenCreated(string indexed name, string indexed symbol, uint8 decimals);
    event CampaignCreated(string indexed name);
    event TimedCampaignCreated(string indexed name);


    function create(string memory campaignName, uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, uint256 cap, uint256 goal, CampaignType campaignType, address tokenAddress) public returns (address, uint) {

        ERC20Mintable genericCoin = ERC20Mintable(tokenAddress);
        uint campaignId = createCampaign(_openingTime, _closingTime, _rate, _wallet, genericCoin, cap, goal, campaignType);
        crowdsales[campaignId].name = campaignName;
        genericCoin.addMinter(crowdsales[campaignId].contractAddress);
        emit CampaignCreated(campaignName);
        return (address(tokenAddress), campaignId);

    }

    function createCampaign(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, ERC20Mintable genericCoin, uint256 cap, uint256 goal, CampaignType campaignType) internal returns (uint campaignId) {

        if(campaignType == CampaignType.Simple) {
            campaignId = createSimpleCampaign(_rate, _wallet, genericCoin);
        } else {
            if(campaignType == CampaignType.Timed) {
                campaignId = createTimedCampaign(_openingTime, _closingTime, _rate, _wallet, genericCoin);
            } else {
                if(campaignType == CampaignType.TimedCapped) {
                    campaignId = createTimedCappedCampaign(_openingTime, _closingTime, _rate, _wallet, genericCoin, cap);
                } else {
                    if(campaignType == CampaignType.TimedCappedRefundable) {
                        campaignId = createTimedCappedRefundableCampaign(_openingTime, _closingTime, _rate, _wallet, genericCoin, cap, goal);
                    }
                }
            }
        }
    }

    function createSimpleCampaign(uint256 _rate, address payable _wallet, ERC20Mintable token) internal returns (uint campaignId) {
        GenericCrowdsale crowdsaleAddress = new GenericCrowdsale(_rate, _wallet, token);
        campaignId = numCampaigns++;

        crowdsales[campaignId] = CrowdsaleStruct({contractAddress: address(crowdsaleAddress), name: ''});
    }

    function createTimedCampaign(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, ERC20Mintable token) internal returns (uint campaignId) {
        GenericTimedCrowdsale crowdsaleAddress = new GenericTimedCrowdsale(_openingTime, _closingTime, _rate, _wallet, token);
        campaignId = numCampaigns++;

        crowdsales[campaignId] = CrowdsaleStruct({contractAddress: address(crowdsaleAddress), name: ''});
    }

    function createTimedCappedCampaign(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, ERC20Mintable token, uint256 cap) internal returns (uint campaignId) {
        GenericTimedCappedCrowdsale crowdsaleAddress = new GenericTimedCappedCrowdsale(_openingTime, _closingTime, _rate, _wallet, token, cap);
        campaignId = numCampaigns++;

        crowdsales[campaignId] = CrowdsaleStruct({contractAddress: address(crowdsaleAddress), name: ''});
    }

    function createTimedCappedRefundableCampaign(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, ERC20Mintable token, uint256 cap, uint256 goal) internal returns (uint campaignId) {
        GenericTimedCappedRefundableCrowdsale crowdsaleAddress = new GenericTimedCappedRefundableCrowdsale(_openingTime, _closingTime, _rate, _wallet, token, cap, goal);
        campaignId = numCampaigns++;

        crowdsales[campaignId] = CrowdsaleStruct({contractAddress: address(crowdsaleAddress), name: ''});
    }

    function createToken(string memory name, string memory symbol, uint8 decimals) internal returns (uint tokenId, address tokenAddress) {
        tokenAddress = address(new GenericCoin(name, symbol, decimals));
        tokenId = numTokens++;
        tokens[tokenId] = tokenAddress;
        emit TokenCreated(name, symbol, decimals);
    }

    function getTokenById(uint id) public view returns (address) {
        require(id >= 0, "Invalid ID");
        address token = tokens[id];
        return token;
    }

    function getCampaignById(uint id) public view returns (address, string memory) {
        require(id >= 0, "Invalid ID");
        CrowdsaleStruct memory crowdsale = crowdsales[id];
        return (address(crowdsale.contractAddress), crowdsale.name);
    }

    function getNumTokens() public view returns (uint) {
        return numTokens;
    }

    function getNumCampaigns() public view returns (uint) {
        return numCampaigns;
    }

}