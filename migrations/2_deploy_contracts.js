const GenericCrowdsale = artifacts.require('./GenericCrowdsale.sol');
const GenericCoin = artifacts.require('./GenericCoin.sol');

module.exports = function(deployer, network, accounts) {

    const openingTime = Date.now() + 2;
    const closingTime = openingTime + 86400 * 20; // 20 days from now
    const rate = 1
    const wallet = accounts[1];

    const coinName = "NordCypher Coin";
    const coinSymbol = "NCC";
    const coinDecimals = 18;

    return deployer
        .then(() => {
            return deployer.deploy(GenericCoin, coinName, coinSymbol, coinDecimals);
        })
        .then(() => {
            return deployer.deploy(
                GenericCrowdsale,
                openingTime,
                closingTime,
                rate,
                wallet,
                GenericCoin.address
            );
        });

};