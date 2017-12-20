var Student = artifacts.require("./goblockchain/student/Student.sol");

module.exports = function(deployer) {
  deployer.deploy(Student);
};
