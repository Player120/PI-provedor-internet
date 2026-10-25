class Cliente {
  int? idcliente;
  String tipoPessoa;
  String nomeCompleto;
  String cpfCnpj;
  String? rg;
  DateTime? dataNascimento;
  DateTime? dataCadastro;
  String statusCliente;

  Cliente({
    this.idcliente,
    required this.tipoPessoa,
    required this.nomeCompleto,
    required this.cpfCnpj,
    this.rg,
    required this.dataNascimento,
    this.dataCadastro,
    required this.statusCliente,
  });

  @override
  String toString() {
    return 
    """
    =============================================================================================
    --------------------------------------------------------------------------------------------
    | [$idcliente] Nome: $nomeCompleto | Data de Nascimento: $dataNascimento | 
    | Status do Cliente: $statusCliente |
    | CPF/CNPJ: $cpfCnpj | RG: $rg |
    | Tipo de Pessoa: $tipoPessoa | Data do Cadastro: $dataCadastro |
    ---------------------------------------------------------------------------------------------
    ==============================================================================================
    """;
  }
}
