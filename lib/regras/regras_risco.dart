import '../models/alerta.dart';
import '../models/estacao.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';

// Estas regras são as mesmas da API Java (RN01, RN02 e RN06), para a
// integração futura dar o mesmo resultado.

// Quanto a simulação soma a cada toque e até onde o nível pode subir
const int passoNivelCm = 40;
const int passoChuvaMmH = 12;
const int tetoNivelCm = 330;

// RN01: régua de risco da estação, com o agravante de chuva.
NivelRisco calcularRisco(int nivelCm, int chuvaMmH, Estacao estacao) {
  NivelRisco risco;
  if (nivelCm >= estacao.cotaTransbordo) {
    risco = NivelRisco.emergencia;
  } else if (nivelCm >= estacao.cotaAlerta) {
    risco = NivelRisco.alerta;
  } else if (nivelCm >= estacao.cotaAtencao) {
    risco = NivelRisco.atencao;
  } else {
    risco = NivelRisco.normal;
  }

  // Chuva de 50 mm/h ou mais sobe um nível, até EMERGÊNCIA
  if (chuvaMmH >= 50 && risco != NivelRisco.emergencia) {
    risco = NivelRisco.values[risco.index + 1];
  }
  return risco;
}

// RN06: prioridade do relato, de 1 a 5.
int calcularPrioridade(TipoRelato tipo, NivelRisco riscoDaArea) {
  int prioridade;
  switch (tipo) {
    case TipoRelato.pessoaIlhada:
      prioridade = 5;
    case TipoRelato.deslizamento:
      prioridade = 4;
    case TipoRelato.rioSubindo:
      prioridade = 3;
    case TipoRelato.alagamentoVia:
      prioridade = 3;
    case TipoRelato.bueiroEntupido:
      prioridade = 2;
    case TipoRelato.outro:
      prioridade = 1;
  }

  // Área em ALERTA ou EMERGÊNCIA aumenta 1, com teto em 5
  if (riscoDaArea == NivelRisco.alerta ||
      riscoDaArea == NivelRisco.emergencia) {
    prioridade = prioridade + 1;
  }
  if (prioridade > 5) {
    prioridade = 5;
  }
  return prioridade;
}

// Novo nível do rio depois de um toque em "Simular subida do rio"
int proximoNivelCm(int nivelAtualCm) {
  int novo = nivelAtualCm + passoNivelCm;
  if (novo > tetoNivelCm) {
    novo = tetoNivelCm;
  }
  return novo;
}

// RN02: alerta automático. Com risco ALERTA ou maior, cria um alerta se não
// houver alerta ativo de nível igual ou maior. Os ativos de nível menor são
// encerrados (substituídos). Devolve o alerta novo, ou null se não criou nada.
Alerta? atualizarAlertas(
  List<Alerta> alertas,
  NivelRisco risco,
  Estacao estacao,
  DateTime agora,
) {
  if (risco.index < NivelRisco.alerta.index) {
    return null;
  }

  for (final alerta in alertas) {
    if (alerta.ativo && alerta.nivel.index >= risco.index) {
      return null;
    }
  }

  // Sobraram só alertas ativos de nível menor: encerra todos
  for (final alerta in alertas) {
    if (alerta.ativo) {
      alerta.ativo = false;
      alerta.encerradoEm = agora;
    }
  }

  final novo = Alerta(
    id: alertas.length + 1,
    nivel: risco,
    area: estacao.area,
    mensagem: mensagemDoAlerta(risco, estacao),
    criadoEm: agora,
  );
  alertas.insert(0, novo);
  return novo;
}

String mensagemDoAlerta(NivelRisco risco, Estacao estacao) {
  switch (risco) {
    case NivelRisco.emergencia:
      return '${estacao.rio} passou da cota de transbordo na ${estacao.nome}. '
          'Saia de casa agora.';
    case NivelRisco.alerta:
      return '${estacao.rio} passou da cota de alerta na ${estacao.nome}. '
          'Prepare a saída.';
    case NivelRisco.atencao:
      return '${estacao.rio} passou da cota de atenção na ${estacao.nome}. '
          'Acompanhe o nível.';
    case NivelRisco.normal:
      return '${estacao.rio} está em nível normal na ${estacao.nome}.';
  }
}
