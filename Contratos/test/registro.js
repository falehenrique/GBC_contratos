var TesteTruffle = artifacts.require("TesteTruffle");
contract('TesteTruffle Validation', function(accounts) {
  var testeTruffle;

  it("should validate", function(done) {
    TesteTruffle.deployed().then(function(instance) {
            testeTruffle = instance;
            return testeTruffle.getNome();
        }).then(function(nome){
            console.info(nome);
            assert.equal(nome, "henrique", "nome esta correto");
        }
        ).then(done)
        .catch(done);
    });
});