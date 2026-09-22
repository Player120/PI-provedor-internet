import 'cliente.dart';
import 'endereco.dart';
import 'plano.dart';

class ContratoAssinatura {
  int idContrato;
  Cliente cliente;
  Plano plano;
  Endereco enderecoInstalacao;
  DateTime dataAdesao;
  int diaVencimentoFatura;

  ContratoAssinatura({
    required this.idContrato,
    required this.cliente,
    required this.plano,
    required this.enderecoInstalacao,
    required this.dataAdesao,
    required this.diaVencimentoFatura,
  });
}
