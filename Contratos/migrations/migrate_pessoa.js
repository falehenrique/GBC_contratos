var RegistrosPessoas = artifacts.require("RegistrosPessoas");
var pessoaContrato = artifacts.require("Pessoa");

var nome = "Henrique L";
var email = "fale.henrique@gmail.com";
var cpf = 12345678;
var dataNascimento = "29/03/1986"

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(RegistrosPessoas).then(
    function(){
        console.info("endereço registro de contratos " + RegistrosPessoas.address);
        deployer.deploy(pessoaContrato, nome, email, cpf, dataNascimento, RegistrosPessoas.address, {gas: 50000}).then(function(){
             console.info("deploy finalizado");
        });
    }
  );
};

// module.exports = function(deployer) {
//   // deployment steps
//   deployer.deploy(registroPessoas).then(function(instance){
//     return deployer.deploy(pessoaContrato, nome, email, cpf, dataNascimento, instance.address).then(function(instance){
//       console.info("endereço registroPessoas = "+ instance.address);
//     });
//   });
// };
