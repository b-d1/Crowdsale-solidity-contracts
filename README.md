# Crowdsale-solidity-contracts

## Setup :

npm install openzeppelin-solidity --save

truffle compile

truffle migrate

truffle console

## External requirements
Ganache (app)

## Truffle console commands

let cni = await CrowdsaleFactory.deployed().then(instance => instance)

let accounts = await web3.eth.getAccounts()

let blockNumber = await web3.eth.getBlockNumber()

let block = await web3.eth.getBlock(blockNumber)

cni.create("NC ICO", block.timestamp + 100, block.timestamp + 86400, 1, accounts[1], 'NCoin2', 'NCC', 18).then(result => {console.log(result)})

cni.getNumTokens().then(result => console.log(result.toNumber()))

cni.getTokenById(1).then(result => console.log(result))
