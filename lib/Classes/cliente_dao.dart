import 'package:mysql_client/mysql_client.dart';
import './database.dart';
import './cliente.dart';

class ClienteDao {
  Future<List> listarClientes() async {
    List<Cliente> lista = [];
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();

      var resultado = await conn.execute("SELECT * FROM clientes");

      for (var linha in resultado.rows) {
        lista.add(Cliente(
          idcliente: int.tryParse(linha.colByName("idcliente").toString()), 
          tipoPessoa: linha.colByName("tipoPessoa").toString(), 
          nomeCompleto: linha.colByName("nomeCompleto").toString(), 
          cpfCnpj: linha.colByName("cpfCnpj").toString(),
          rg: linha.colByName("rg").toString(),
          dataNascimento: DateTime.tryParse(linha.colByName("dataNascimento").toString()),
          dataCadastro: DateTime.tryParse(linha.colByName("dataCadastro").toString()), 
          statusCliente: linha.colByName("statusCliente").toString()
        ));
      }

    } catch (e) {
      print("Erro ao listar os clientes: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
    return lista;
  }
}