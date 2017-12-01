var RegistroPessoas = artifacts.require("RegistroPessoas");
contract('RegistroPessoas Validation', function(accounts) {
  var registroPessoas;

  it("should validate", function(done) {
        RegistroPessoas.deployed().then(function(instance) {
            registroPessoas = instance;
            return registroPessoas.listaContaPessoas.length;
            }).then(function() {
            return mockValidation.getValidationsCount.call();
        }).then(done)
        .catch(done);
    });
});