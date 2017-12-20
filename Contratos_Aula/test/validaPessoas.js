var RegistrosPessoas = artifacts.require("RegistrosPessoas");
var Pessoa = artifacts.require("Pessoa");

contract('RegistrosPessoas Validation', function(accounts) {
  var registrosPessoas;
  it("should validate", function(done) {
    RegistrosPessoas.deployed().then(function(instance) {
        registrosPessoas = instance;
            return registrosPessoas.listaContaPessoas.length;
        }).then(function(length){
            console.info(length);
            assert.equal(length, 1, "registro esta correto");
        }
        ).then(done)
        .catch(done);
    });
});