var MessagesAndCodes = artifacts.require('./libraries/MessagesAndCodes')
var xxCoin = artifacts.require('./contracts/xxCoin')

module.exports = function (deployer) {
  deployer.then(async () => {
    try {
      // deploy and link MessagesAndCodes lib for MessagedERC1404's
        await deployer.deploy(MessagesAndCodes)
        await deployer.link(MessagesAndCodes, [
            xxCoin,
        ])
        await deployer.deploy(xxCoin,
                              '0x1A004a36a6BC9BCdE42c6d2b237C6477CF0f535f',
                              2000000000)
    } catch (err) {
      console.log(('Failed to Deploy Contracts', err))
    }
  })
}
