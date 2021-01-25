const DappToken = artifacts.require('DappToken')
const DaiToken = artifacts.require('DaiToken')
const TokenFarm = artifacts.require('TokenFarm')

module.exports = async function(deployer, network, accounts) {

// Deploy Mock Dia Token
await deployer.deploy(DaiToken)
const daiToken = await DaiToken.deployed()

// Deploy Dapp Token
await deployer.deploy(DappToken)
const dappToken = await DappToken.deployed()

// Deploy Token Farm
await deployer.deploy(TokenFarm, dappToken.address, daiToken.address,)
const tokenFarm = await TokenFarm.deployed()

// Transfer all tokens to TokenFarm (1million)
await dappToken.transfer(tokenFarm.address, '100000000000000000000')

// Tranfer 100 Mock Dai to investor
await daiToken.transfer(accounts[1], '100000000000000000000')
}
