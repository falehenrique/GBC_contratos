var ERC223Token = artifacts.require("./goblockchain/token/ERC223Token.sol");

module.exports = function(deployer) {
  deployer.deploy(ERC223Token);
};
