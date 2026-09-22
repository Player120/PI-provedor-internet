import 'dart:io';
import 'Menus/menu1.dart';
import 'Menus/menu2.dart';
import 'Menus/menu3.dart';

class MenuPrincipal {
  MenuPrincipal() {
    executar();
  }

  void executar() {
    bool continuar = true;
    while (continuar) {
      mostrarMenu();
      continuar = escolherOpcao();
    }
  }

  void mostrarMenu() {
    print("------------------------------");
    print("     PROVEDOR DE INTERNET"); 
    print("------------------------------");
    print("[1] Listar Clientes");
    print("[2] Opção 2");
    print("[3] Opção 3");
    print("[4] Sair");
    print("------------------------------");
  }

  bool escolherOpcao() {
    print("Escolha uma opção:");
    String? escolha = stdin.readLineSync()!;

    switch (escolha) {
      case "1":
        Menu1();
        return true;
      case "2":
        Menu2();
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