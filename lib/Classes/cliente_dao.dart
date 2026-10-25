import 'package:mysql_client/mysql_client.dart';
import './database.dart';
import './cliente.dart';
import './endereco.dart';
import './contato.dart';
import 'plano.dart';
import './contrato_assinatura.dart';
import 'calcular_vencimento.dart';

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

  Future<void> cadastrarCliente(Cliente cliente, Endereco endereco, Contato contato, Plano plano) async {
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();

      print("Cadastrando endereço...");
      int idendereco = await inserirEndereco(endereco, conn);

      print("Cadastrando contato...");
      int idcontato = await inserirContato(contato, conn);

      print("Cadastrando plano...");
      int idcontrato = await inserirPlano(plano, conn);

      print("Cadastrando cliente...");
      await inserirCliente(cliente, idendereco, idcontato, idcontrato, conn);

      print("--------------------------------------");
      print("   Cliente cadastrado com sucesso!");
      print("--------------------------------------");
    } catch (e) {
      print("Erro ao cadastrar o cliente: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  Future<int> inserirEndereco(Endereco endereco, MySQLConnection conn) async {
    var sql = "INSERT INTO enderecos (logradouro, numero, complemento, bairro, cidade, cep, estado, tipoEndereco) VALUES (:logradouro, :numero, :complemento, :bairro, :cidade, :cep, :estado, :tipoEndereco)";

    await conn.execute(sql, {
      "logradouro": endereco.logradouro,
      "numero": endereco.numero,
      "complemento": endereco.complemento,
      "bairro": endereco.bairro,
      "cidade": endereco.cidade,
      "cep": endereco.cep,
      "estado": endereco.estado,
      "tipoEndereco": endereco.tipoEndereco
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);

    int idendereco = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());
    return idendereco;
  }

  Future<int> inserirContato(Contato contato, MySQLConnection conn) async {
    var sql = "INSERT INTO contatos (telefonePrincipal, telefoneSecundario, email, aceitaNotificacao) VALUES (:telefonePrincipal, :telefoneSecundario, :email, :aceitaNotificacao)";

    await conn.execute(sql, {
      "telefonePrincipal": contato.telefonePrincipal,
      "telefoneSecundario": contato.telefoneSecundario,
      "email": contato.email,
      "aceitaNotificacao": contato.aceitaNotificacao
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);

    int idcontato = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());
    return idcontato;
  }

  Future<int> inserirPlano(Plano plano, MySQLConnection conn) async {
    // Para calcular a data de vencimento para o contrato
    DateTime dataVencimento = CalcularVencimento().calculo();
    ContratoAssinatura contrato = ContratoAssinatura(dataAdesao: DateTime.now(), vencimentoFatura: dataVencimento);

    // Insere o contrato no sistema primeiro, visto que um plano necessita estar atrelado a um contrato
    var sql = "INSERT INTO contratosassinaturas (dataAdesao, vencimentoFatura) VALUES (:dataAdesao, :vencimentoFatura)";
    await conn.execute(sql, {
      "dataAdesao": contrato.dataAdesao,
      "vencimentoFatura": contrato.vencimentoFatura
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);
    
    int idcontrato = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());

    sql = "INSERT INTO planos (nome, velocidade, mensalidade, contratosAssinaturas_idcontrato) VALUES (:nome, :velocidade, :mensalidade, LAST_INSERT_ID())";
    await conn.execute(sql, {
      "nome": plano.nome,
      "velocidade": plano.velocidade,
      "mensalidade": plano.mensalidade
    });

    return idcontrato;
  }

  Future<void> inserirCliente(Cliente cliente, int idendereco, int idcontato, int idcontrato, MySQLConnection conn) async {
    var sql = "INSERT INTO clientes (nomeCompleto, tipoPessoa, cpfCnpj, rg, dataNascimento, dataCadastro, statusCliente, enderecos_idendereco, contatos_idcontato, contratosassinaturas_idcontrato) VALUES (:nomeCompleto, :tipoPessoa, :cpfCnpj, :rg, :dataNascimento, :dataCadastro, :statusCliente, :enderecos_idendereco, :contatos_idcontato, :contratosassinaturas_idcontrato)";

    await conn.execute(sql, {
      "nomeCompleto": cliente.nomeCompleto, 
      "tipoPessoa": cliente.tipoPessoa, 
      "cpfCnpj": cliente.cpfCnpj, 
      "rg": cliente.rg, 
      "dataNascimento": cliente.dataNascimento, 
      "dataCadastro": DateTime.now(),
      "statusCliente": "Ativo", 
      "enderecos_idendereco": idendereco, 
      "contatos_idcontato": idcontato, 
      "contratosassinaturas_idcontrato": idcontrato
    });
  }
}