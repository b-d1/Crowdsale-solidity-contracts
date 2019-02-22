const GenericCrowdsale = artifacts.require('./GenericCrowdsale.sol');
const GenericCoin = artifacts.require('./GenericCoin.sol');
const CrowdsaleFactory = artifacts.require('./CrowdsaleFactory.sol');

module.exports = async function(deployer, network, accounts) {


    const blockNumber = await web3.eth.getBlockNumber();
    const block = await web3.eth.getBlock(blockNumber);

    console.log("BLOCK NUMBER ", blockNumber);
    console.log("BLOCK ", block);

    const openingTime = block.timestamp + 1;
    const closingTime = openingTime + 86400 * 20; // 20 days from now
    const rate = 1;
    const wallet = accounts[1];

    const coinName = "NordCypher Coin";
    const coinSymbol = "NCC";
    const coinDecimals = 18;

    return deployer
        .then(() => {
            return deployer.deploy(CrowdsaleFactory)
        });

};