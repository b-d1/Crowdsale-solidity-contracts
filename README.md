# Crowdsale-solidity-contracts

## Setup :

npm install openzeppelin-solidity --save

truffle compile

truffle migrate

truffle console

## External requirements
Ganache (app)

## Truffle console commands
```
let cfi = await CrowdsaleFactory.deployed().then(instance => instance)
let tfi = await TokenFactory.deployed().then(instance => instance)
tfi.createToken('NCCoin', 'NCC', 18)

let accounts = await web3.eth.getAccounts()
let blockNumber = await web3.eth.getBlockNumber()
let block = await web3.eth.getBlock(blockNumber)


cfi.create("NC ICO", block.timestamp + 100, block.timestamp + 86400, 1, accounts[1], 0, 0, 0, '0xaeCD719e33E81a5875AD213A5b932f40AeAc83b4').then(result => {console.log(result)})

tfi.getNumTokens().then(result => console.log(result.toNumber()))

tfi.getTokenById(0).then(result => console.log(result))

cfi.getCampaignById(0).then(result => console.log(result))
```
