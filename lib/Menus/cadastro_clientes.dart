import 'dart:io';
import 'package:pi_provedor_internet/Classes/endereco.dart';

import '../Classes/cliente_dao.dart';
import '../Classes/cliente.dart';
// import '../Classes/endereco.dart';
import '../Classes/plano.dart';
import '../Classes/contato.dart';

class CadastroClientes {
  var clienteDao = ClienteDao();
  late final Cliente cliente;
  late final Endereco endereco;
  late final Plano plano;
  late final Contato contato;

  // Dados Pessoais
  String nome = "";
  DateTime? dataNascimento;
  String tipoPessoa = "";
  String cpfCnpj = "";
  String rg = "";

  // Dados do Endereço
  String logradouro = "";
  int? numero;
  String complemento = "";
  String bairro = "";
  String cidade = "";
  String cep = "";
  String estado = "";
  String tipoEndereco = "";

  // Dados do Contrato
  DateTime? dataAdesao;
  DateTime? vencimentoFatura;

  // Dados do Plano
  String nomePlano = "";
  int? velocidade;
  double? mensalidade;

  // Dados do Contato
  String telefonePrincipal = "";
  String? telefoneSecundario;
  String email = "";
  bool? aceitaNotificacao;


  Future<void> cadastrar() async {
    print('\n');
    print(' -----------------------');
    print('   Cadastro de Cliente  ');
    print(' -----------------------');
    print('===================================================================================');
    print('  ATENÇÃO! NÃO DEIXE NENHUM CAMPO EM BRANCO (EXCETO SE O CAMPO DIZER O CONTRÁRIO)');
    print('===================================================================================');

    while (true) {
      bool pronto = dadosPessoais();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    } 
    
    while (true) {
      bool pronto = dadosEndereco();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }

    while (true) {
      bool pronto = dadosContato();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }

   while (true) {
      bool pronto = dadosPlano();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }

    // Depois de tudo já ter sido inserido
    cliente = Cliente(tipoPessoa: tipoPessoa, nomeCompleto: nome, cpfCnpj: cpfCnpj, rg: rg, dataNascimento: dataNascimento, statusCliente: "Ativo");
    endereco = Endereco(estado: estado, tipoEndereco: tipoEndereco, cep: cep, logradouro: logradouro, numero: numero, bairro: bairro, cidade: cidade);
    contato = Contato(telefonePrincipal: telefonePrincipal, email: email, aceitaNotificacao: aceitaNotificacao);
    plano = Plano(nome: nomePlano, velocidade: velocidade, mensalidade: mensalidade);

    await clienteDao.cadastrarCliente(cliente, endereco, contato, plano);
  }

  bool dadosPessoais() {
    print("--------------------------------------------------------------------");
    stdout.write("Nome Completo: ");
    nome = stdin.readLineSync()!.toUpperCase();

    stdout.write("Data de Nascimento (Digite no formato aaaa-mm-dd): ");
    dataNascimento = DateTime.tryParse(stdin.readLineSync()!);

    stdout.write("Tipo de Pessoa (Fisica ou Juridica - NÃO COLOQUE ACENTO!): ");
    tipoPessoa = stdin.readLineSync()!.toUpperCase();
    print(tipoPessoa);

    switch (tipoPessoa) {
      case "FISICA":
        stdout.write("CPF (sem pontuação e traço): ");
        cpfCnpj = stdin.readLineSync()!;
        break;

      case "JURIDICA":
        stdout.write("CNPJ (sem pontuação, traço ou barra): ");
        cpfCnpj = stdin.readLineSync()!;
        break;

      default:
        print("Tipo de pessoa inválido!");
        return false;
    }

    stdout.write("RG (opcional, pode deixar em branco): ");
    rg = stdin.readLineSync()!.toUpperCase();

    if (nome.isEmpty || dataNascimento == null || tipoPessoa.isEmpty || cpfCnpj.isEmpty) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    return true;
  }

  bool dadosEndereco() {
    print("--------------------------------------------------------------------");
    stdout.write("Logradouro: ");
    logradouro = stdin.readLineSync()!.toUpperCase();

    stdout.write("Número: ");
    numero = int.tryParse(stdin.readLineSync()!);

    stdout.write("Complemento (deixe em branco se não se aplica): ");
    complemento = stdin.readLineSync()!;

    stdout.write("Bairro: ");
    bairro = stdin.readLineSync()!.toUpperCase();

    stdout.write("Cidade: ");
    cidade = stdin.readLineSync()!.toUpperCase();

    stdout.write("CEP (sem traço): ");
    cep = stdin.readLineSync()!;

    stdout.write("Estado (use apenas a sigla de duas letras): ");
    estado = stdin.readLineSync()!.toUpperCase();

    stdout.write("Tipo de Endereço: ");
    tipoEndereco = stdin.readLineSync()!.toUpperCase();

    if (
      logradouro.isEmpty || 
      numero == null || 
      bairro.isEmpty || 
      cidade.isEmpty ||
      cep.isEmpty ||
      estado.isEmpty ||
      tipoEndereco.isEmpty ||
      estado.length > 2
    ) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    return true;
  }

  bool dadosContato() {
    print("--------------------------------------------------------------------");
    stdout.write("Telefone Principal: ");
    telefonePrincipal = stdin.readLineSync()!.toUpperCase();

    stdout.write("Telefone Secundário (opcional, pode deixar em branco): ");
    telefoneSecundario = stdin.readLineSync()!.toUpperCase();

    stdout.write("E-Mail: ");
    email = stdin.readLineSync()!;

    stdout.write("Aceita ser notificado sobre atualizações e mudanças? (S para sim, qualquer outra coisa para não): ");
    String aceita = stdin.readLineSync()!.toUpperCase();
    if (aceita == "S") {
      aceitaNotificacao = true;
    } else {
      aceitaNotificacao = false;
    }

    if (telefonePrincipal.isEmpty || email.isEmpty) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    return true;
  }  

  bool dadosPlano() {
    print("--------------------------------------------------------------------");
    print("=== Escolha do Plano ===");
    print("--------------------------------------------------------------------");
    print("[1] Plano Bronze | 100 Mbps | R\$ 89,90 por mês");
    print("[2] Plano Prata | 300 Mbps | R\$ 109,90 por mês");
    print("[3] Plano Ouro | 500 Mbps | R\$ 129,90 por mês");
    print("[4] Plano Diamante | 700 Mbps | R\$ 159,90 por mês");
    print("[5] Plano Fibra Turbo | 1 Gbps | R\$ 199,90 por mês");
    print("[6] Plano Família | 2 Gbps | R\$ 289,90 por mês");
    print("[7] Plano Empresarial | 6 Gbps | R\$ 799,90 por mês");
    print("--------------------------------------------------------------------");
    stdout.write("Digite o número do plano: ");
    int? planoEscolhido = int.tryParse(stdin.readLineSync()!);

    switch (planoEscolhido) {
      case 1:
        nomePlano = "Plano Bronze";
        velocidade = 100;
        mensalidade = 89.9;
        break;

      case 2:
        nomePlano = "Plano Prata";
        velocidade = 300;
        mensalidade = 109.9;
        break;

      case 3:
        nomePlano = "Plano Ouro";
        velocidade = 500;
        mensalidade = 129.9;
        break;
      
      case 4:
        nomePlano = "Plano Diamante";
        velocidade = 700;
        mensalidade = 159.9;
        break;

      case 5:
        nomePlano = "Plano Fibra Turbo";
        velocidade = 1000;
        mensalidade = 199.9;
        break;

      case 6:
        nomePlano = "Plano Família";
        velocidade = 2000;
        mensalidade = 289.9;
        break;

      case 7:
        nomePlano = "Plano Empresarial";
        velocidade = 6000;
        mensalidade = 799.9;
        break;
    
      default:
        print("O valor digitado é inválido ou o plano não existe!");
        return false;
    }

    return true;
  }

  bool confirmacao() {
    stdout.write("Deseja continuar o cadastro? (S para continuar, qualquer outra coisa para parar): ");
    String entrada = stdin.readLineSync()!.toUpperCase();
    if (entrada == "S") {
      return true;
    } else {
      return false;
    }
  }
}