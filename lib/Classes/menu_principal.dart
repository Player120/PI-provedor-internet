import 'dart:io';
import '../Menus/lista_clientes.dart';
import '../Menus/cadastro_clientes.dart';
import '../Menus/menu3.dart';

import './cliente_dao.dart';

class MenuPrincipal {
  var clienteDao = ClienteDao();
  var listaClientes = ListaClientes();
  var cadastroClientes = CadastroClientes();

  MenuPrincipal() {
    executar();
  }

  Future<void> executar() async {
    bool continuar = true;
    while (continuar) {
      mostrarMenu();
      continuar = await escolherOpcao();
    }
  }

  void mostrarMenu() {
    print("==============================");
    print("------------------------------");
    print("     PROVEDOR DE INTERNET"); 
    print("------------------------------");
    print("[1] Listar Clientes");
    print("[2] Cadastrar Cliente");
    print("[3] Opção 3");
    print("[4] Sair");
    print("------------------------------");
    print("===============================");
  }

  Future<bool> escolherOpcao() async {
    stdout.write("Escolha uma opção: ");
    String? escolha = stdin.readLineSync()!;

    switch (escolha) {
      case "1":
        await listaClientes.listar();
        return true;

      case "2":
        await cadastroClientes.cadastrar();
        return true;

      case "3":
        Menu3;
        return true;

      case "4":
        print("Encerrando!");
        return false;
        
      default:
        print("Opção inválida!");
        return true;
    }
  }
}