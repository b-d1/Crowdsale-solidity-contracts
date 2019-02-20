pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';


contract GenericCoin is ERC20Mintable, ERC20Detailed {
    constructor (string memory name, string memory symbol, uint8 decimals) public ERC20Detailed(name, symbol, decimals) {
        // solhint-disable-previous-line no-empty-blocks
    }
}