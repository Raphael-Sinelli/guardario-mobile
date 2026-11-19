import '../models/abrigo.dart';
import '../models/alerta.dart';
import '../models/estacao.dart';
import '../models/item_kit.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';
import '../models/usuario.dart';

// Todos os dados do app ficam aqui, em memória. Nada vem de internet nem de
// banco. Quando a API existir, só este arquivo precisa ser trocado.

// Estação do rio e cotas (em cm)
const Estacao estacaoMock = Estacao(
  nome: 'Ponte da Rua Capachós',
  rio: 'Rio Tietê',
  area: 'Jardim Pantanal',
  cidade: 'São Paulo',
  cotaAtencao: 150,
  cotaAlerta: 220,
  cotaTransbordo: 300,
);

// Leitura inicial da estação
const int nivelInicialCm = 130;
const int chuvaInicialMmH = 8;

// Usuário de teste do login
const Usuario usuarioTeste = Usuario(
  nome: 'Cida Souza',
  email: 'cida@guardario.com',
);
const String senhaTeste = '123456';

// Estado compartilhado entre as telas. Cada tela muda estas variáveis e
// chama setState() para redesenhar.
Usuario? usuarioLogado; // null quando a pessoa entrou sem conta
int nivelRioCm = nivelInicialCm;
int chuvaMmH = chuvaInicialMmH;
List<Alerta> alertas = criarAlertasAntigos();
List<Abrigo> abrigos = criarAbrigos();
List<Relato> relatos = criarRelatos();
List<ItemKit> itensKit = criarItensKit();

// Volta o rio e os alertas ao começo. Usada no botão "Reiniciar simulação".
void reiniciarSimulacao() {
  nivelRioCm = nivelInicialCm;
  chuvaMmH = chuvaInicialMmH;
  alertas = criarAlertasAntigos();
}

// Volta tudo ao estado inicial. Usada nos testes.
void reiniciarDadosMock() {
  usuarioLogado = null;
  reiniciarSimulacao();
  abrigos = criarAbrigos();
  relatos = criarRelatos();
  itensKit = criarItensKit();
}

// Três alertas antigos, já encerrados. O mais novo vem primeiro.
List<Alerta> criarAlertasAntigos() {
  return [
    Alerta(
      id: 3,
      nivel: NivelRisco.alerta,
      area: 'Jardim Pantanal',
      mensagem:
          'Rio Tietê passou da cota de alerta na Ponte da Rua Capachós. '
          'Prepare a saída.',
      criadoEm: DateTime(2026, 10, 27, 18, 5),
      ativo: false,
      encerradoEm: DateTime(2026, 10, 28, 1, 20),
    ),
    Alerta(
      id: 2,
      nivel: NivelRisco.emergencia,
      area: 'Jardim Pantanal',
      mensagem:
          'Rio Tietê passou da cota de transbordo na Ponte da Rua '
          'Capachós. Saia de casa agora.',
      criadoEm: DateTime(2026, 3, 3, 5, 10),
      ativo: false,
      encerradoEm: DateTime(2026, 3, 3, 11, 30),
    ),
    Alerta(
      id: 1,
      nivel: NivelRisco.alerta,
      area: 'Jardim Pantanal',
      mensagem:
          'Rio Tietê passou da cota de alerta na Ponte da Rua Capachós. '
          'Prepare a saída.',
      criadoEm: DateTime(2026, 2, 12, 17, 40),
      ativo: false,
      encerradoEm: DateTime(2026, 2, 12, 22, 15),
    ),
  ];
}

// Cinco abrigos da região. Os endereços e nomes são ilustrativos e o telefone
// segue o formato (11) 0000-0000, sem número real.
List<Abrigo> criarAbrigos() {
  return [
    Abrigo(
      nome: 'CEU Jardim Helena',
      endereco: 'Rua das Palmeiras, 120, Jardim Helena, São Paulo',
      telefone: '(11) 0000-0000',
      capacidade: 200,
      ocupacao: 84,
      aceitaPets: true,
      acessivelPcd: true,
    ),
    Abrigo(
      nome: 'Escola Municipal Jardim Pantanal',
      endereco: 'Avenida do Rio Tietê, 45, Jardim Pantanal, São Paulo',
      telefone: '(11) 0000-0000',
      capacidade: 150,
      ocupacao: 150, // lotado
      aceitaPets: false,
      acessivelPcd: true,
    ),
    Abrigo(
      nome: 'Salão Paroquial Nossa Senhora Aparecida',
      endereco: 'Rua São Pedro, 310, São Miguel Paulista, São Paulo',
      telefone: '(11) 0000-0000',
      capacidade: 80,
      ocupacao: 41,
      aceitaPets: true,
      acessivelPcd: false, // sem rampa de acesso
    ),
    Abrigo(
      nome: 'Ginásio Poliesportivo de São Miguel',
      endereco: 'Avenida Marechal Tito, 2800, São Miguel Paulista, São Paulo',
      telefone: '(11) 0000-0000',
      capacidade: 300,
      ocupacao: 212,
      aceitaPets: true,
      acessivelPcd: true,
    ),
    Abrigo(
      nome: 'Salão Comunitário Vila Itaim',
      endereco: 'Rua dos Ipês, 78, Vila Itaim, São Paulo',
      telefone: '(11) 0000-0000',
      capacidade: 60,
      ocupacao: 57,
      aceitaPets: false,
      acessivelPcd: false,
    ),
  ];
}

// Um relato antigo, já resolvido
List<Relato> criarRelatos() {
  return [
    Relato(
      tipo: TipoRelato.bueiroEntupido,
      bairro: 'Jardim Pantanal',
      descricao:
          'Bueiro da rua principal entupido de lixo. A água não escoava '
          'depois da chuva.',
      pessoasEmRisco: false,
      prioridade: 2,
      status: StatusRelato.resolvido,
      criadoEm: DateTime(2026, 9, 18, 10, 15),
    ),
  ];
}

// Os 12 itens do kit de emergência
List<ItemKit> criarItensKit() {
  return [
    ItemKit('Documentos pessoais em saco plástico'),
    ItemKit('Remédios de uso contínuo'),
    ItemKit('Lanterna com pilhas'),
    ItemKit('Rádio de pilha'),
    ItemKit('Água potável'),
    ItemKit('Alimentos que não estragam'),
    ItemKit('Carregador portátil de celular'),
    ItemKit('Roupas e agasalho'),
    ItemKit('Cobertor'),
    ItemKit('Kit de primeiros socorros'),
    ItemKit('Apito'),
    ItemKit('Ração e coleira do pet'),
  ];
}
