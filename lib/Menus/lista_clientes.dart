import '../Classes/cliente_dao.dart';

class ListaClientes {
  var clienteDao = ClienteDao();

  Future<void> listar() async {
      print('\n');
      print(' -----------------------');
      print('   Lista de Clientes  ');
      print(' -----------------------');
      var clientes = await clienteDao.listarClientes();

      if (clientes.isEmpty) {
        print("Nenhum clientes está cadastrado!");
      } else {
        for (var cliente in clientes) {
          print(cliente);
        }
      }
  }
}