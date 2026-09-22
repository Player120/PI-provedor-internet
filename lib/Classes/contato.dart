import 'cliente.dart';

class Contato {
  int idContato;
  Cliente cliente;
  String telefonePrincipal;
  String? telefoneSecundario;
  String email;
  bool aceitaNotificacao;

  Contato({
    required this.idContato,
    required this.cliente,
    required this.telefonePrincipal,
    this.telefoneSecundario,
    required this.email,
    required this.aceitaNotificacao,
  });
}
