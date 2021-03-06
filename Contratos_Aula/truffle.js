//http://truffleframework.com/docs/advanced/configuration

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 500000,
      from: "0x60EAe06ce2045098a856149A2d090952695725Cc"
    }
  },
  testnet: {
    host: "178.25.19.88", // Random IP for example purposes (do not use)
    port: 80,
    network_id: "*",        // Ethereum public network
    // optional config values:
    // gas
    // gasPrice
    // from - default address to use for any transaction Truffle makes during migrations
    // provider - web3 provider instance Truffle should use to talk to the Ethereum network.
    //          - if specified, host and port are ignored.
  }
};
