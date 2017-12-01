var TesteTruffle = artifacts.require("./TesteTruffle.sol");

module.exports = function(deployer) {
  deployer.deploy(TesteTruffle);
  console.info("passou pela migration teste");
};