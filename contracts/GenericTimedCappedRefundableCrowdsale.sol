pragma solidity ^0.5.0;

import './GenericCoin.sol';
import 'openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';

contract GenericTimedCappedRefundableCrowdsale is TimedCrowdsale, MintedCrowdsale, CappedCrowdsale, RefundableCrowdsale {

    constructor
    (
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _rate,
        address payable _wallet,
        ERC20Mintable _token,
        uint256 _cap,
        uint256 _goal
    )
    public
    Crowdsale(_rate, _wallet, _token)
    TimedCrowdsale(_openingTime, _closingTime)
    CappedCrowdsale(_cap)
    RefundableCrowdsale(_goal) {
        require(_goal <= _cap);
    }

}