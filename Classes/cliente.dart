class Cliente {
  int idCliente;
  String tipoPessoa;
  String nomeCompleto;
  String cpfCnpj;
  String? rg;
  DateTime? dataNascimento;
  DateTime dataCadastro;
  String statusCliente;

  Cliente({
    required this.idCliente,
    required this.tipoPessoa,
    required this.nomeCompleto,
    required this.cpfCnpj,
    this.rg,
    this.dataNascimento,
    required this.dataCadastro,
    required this.statusCliente,
  });
}
