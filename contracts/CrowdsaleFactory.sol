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

    // Starting from 0
    enum CampaignType {
        Simple,
        Timed,
        TimedCapped,
        TimedCappedRefundable
    }

    uint private numCampaigns;
    mapping (uint => CrowdsaleStruct) private crowdsales;

    event CampaignCreated(string indexed name);
    event TimedCampaignCreated(string indexed name);


    function create(string memory campaignName, uint256 _openingTime, uint256 _closingTime, uint256 _rate, address payable _wallet, uint256 cap, uint256 goal, CampaignType campaignType, address tokenAddress) public returns (address, uint, address) {

        ERC20Mintable genericCoin = ERC20Mintable(tokenAddress);
        uint campaignId = createCampaign(_openingTime, _closingTime, _rate, _wallet, genericCoin, cap, goal, campaignType);
        crowdsales[campaignId].name = campaignName;
        genericCoin.addMinter(address(crowdsales[campaignId].contractAddress));
        emit CampaignCreated(campaignName);
        return (address(tokenAddress), campaignId, crowdsales[campaignId].contractAddress);

    }

    // Helper function (because of stack overflow error - limited number of local variables in solidity)
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


    function getCampaignById(uint id) public view returns (address, string memory) {
        require(id >= 0, "Invalid ID");
        CrowdsaleStruct memory crowdsale = crowdsales[id];
        return (address(crowdsale.contractAddress), crowdsale.name);
    }


    function getNumCampaigns() public view returns (uint) {
        return numCampaigns;
    }

}