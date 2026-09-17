import "cliente.dart";

class Endereco {
  int idEndereco;
  Cliente cliente;
  String estado;
  String tipoEndereco;
  String cep;
  String logradouro;
  String numero;
  String? complemento;
  String? bairro;
  String cidade;

  Endereco({
    required this.idEndereco,
    required this.cliente,
    required this.estado,
    required this.tipoEndereco,
    required this.cep,
    required this.logradouro,
    required this.numero,
    this.complemento,
    this.bairro,
    required this.cidade,
  });
}
