pragma solidity ^0.5.0;

import './GenericCoin.sol';
import 'openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol';

contract GenericTimedCrowdsale is TimedCrowdsale, MintedCrowdsale {

    constructor
    (
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _rate,
        address payable _wallet,
        ERC20Mintable _token
    )
    public
    Crowdsale(_rate, _wallet, _token)
    TimedCrowdsale(_openingTime, _closingTime) {

    }

}