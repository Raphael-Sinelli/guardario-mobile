import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/models/alerta.dart';
import 'package:guardario_mobile/models/estacao.dart';
import 'package:guardario_mobile/models/nivel_risco.dart';
import 'package:guardario_mobile/models/relato.dart';
import 'package:guardario_mobile/regras/regras_risco.dart';

// Mesmas cotas da estação "Ponte da Rua Capachós"
const estacao = Estacao(
  nome: 'Ponte da Rua Capachós',
  rio: 'Rio Tietê',
  area: 'Jardim Pantanal',
  cidade: 'São Paulo',
  cotaAtencao: 150,
  cotaAlerta: 220,
  cotaTransbordo: 300,
);

Alerta alertaAtivo(int id, NivelRisco nivel) {
  return Alerta(
    id: id,
    nivel: nivel,
    area: 'Jardim Pantanal',
    mensagem: 'teste',
    criadoEm: DateTime(2026, 11, 19, 10, 0),
  );
}

void main() {
  group('calcularRisco sem chuva forte', () {
    test('abaixo da cota de atenção é NORMAL', () {
      expect(calcularRisco(0, 0, estacao), NivelRisco.normal);
      expect(calcularRisco(130, 8, estacao), NivelRisco.normal);
      expect(calcularRisco(149, 0, estacao), NivelRisco.normal);
    });

    test('a partir de 150 cm é ATENÇÃO', () {
      expect(calcularRisco(150, 0, estacao), NivelRisco.atencao);
      expect(calcularRisco(219, 0, estacao), NivelRisco.atencao);
    });

    test('a partir de 220 cm é ALERTA', () {
      expect(calcularRisco(220, 0, estacao), NivelRisco.alerta);
      expect(calcularRisco(299, 0, estacao), NivelRisco.alerta);
    });

    test('a partir de 300 cm é EMERGÊNCIA', () {
      expect(calcularRisco(300, 0, estacao), NivelRisco.emergencia);
      expect(calcularRisco(330, 0, estacao), NivelRisco.emergencia);
    });
  });

  group('calcularRisco com agravante de chuva', () {
    test('chuva de 49 mm/h não muda o risco', () {
      expect(calcularRisco(130, 49, estacao), NivelRisco.normal);
      expect(calcularRisco(250, 49, estacao), NivelRisco.alerta);
    });

    test('chuva de 50 mm/h sobe um nível em cada faixa', () {
      expect(calcularRisco(130, 50, estacao), NivelRisco.atencao);
      expect(calcularRisco(170, 50, estacao), NivelRisco.alerta);
      expect(calcularRisco(250, 50, estacao), NivelRisco.emergencia);
    });

    test('EMERGÊNCIA continua EMERGÊNCIA com chuva forte', () {
      expect(calcularRisco(320, 80, estacao), NivelRisco.emergencia);
    });
  });

  group('simulação de subida do rio', () {
    test('o nível sobe 40 cm por toque e para em 330 cm', () {
      expect(proximoNivelCm(130), 170);
      expect(proximoNivelCm(290), 330);
      expect(proximoNivelCm(330), 330);
    });

    test('em 4 toques o risco passa por NORMAL, ATENÇÃO, ALERTA e EMERGÊNCIA',
        () {
      int nivel = 130;
      int chuva = 8;
      final sequencia = <NivelRisco>[calcularRisco(nivel, chuva, estacao)];

      for (int toque = 1; toque <= 4; toque++) {
        nivel = proximoNivelCm(nivel);
        chuva = chuva + passoChuvaMmH;
        sequencia.add(calcularRisco(nivel, chuva, estacao));
      }

      expect(sequencia, [
        NivelRisco.normal, // 130 cm, 8 mm/h (início)
        NivelRisco.atencao, // 170 cm, 20 mm/h
        NivelRisco.atencao, // 210 cm, 32 mm/h
        NivelRisco.alerta, // 250 cm, 44 mm/h
        NivelRisco.emergencia, // 290 cm, 56 mm/h (chuva sobe o nível)
      ]);
    });
  });

  group('calcularPrioridade', () {
    test('prioridade base de cada tipo com a área em NORMAL', () {
      expect(calcularPrioridade(TipoRelato.pessoaIlhada, NivelRisco.normal), 5);
      expect(calcularPrioridade(TipoRelato.deslizamento, NivelRisco.normal), 4);
      expect(calcularPrioridade(TipoRelato.rioSubindo, NivelRisco.normal), 3);
      expect(calcularPrioridade(TipoRelato.alagamentoVia, NivelRisco.normal), 3);
      expect(
          calcularPrioridade(TipoRelato.bueiroEntupido, NivelRisco.normal), 2);
      expect(calcularPrioridade(TipoRelato.outro, NivelRisco.normal), 1);
    });

    test('ATENÇÃO não aumenta a prioridade', () {
      expect(calcularPrioridade(TipoRelato.rioSubindo, NivelRisco.atencao), 3);
    });

    test('área em ALERTA ou EMERGÊNCIA soma 1', () {
      expect(calcularPrioridade(TipoRelato.rioSubindo, NivelRisco.alerta), 4);
      expect(
          calcularPrioridade(TipoRelato.bueiroEntupido, NivelRisco.emergencia),
          3);
      expect(calcularPrioridade(TipoRelato.outro, NivelRisco.alerta), 2);
    });

    test('o teto é 5', () {
      expect(
          calcularPrioridade(TipoRelato.pessoaIlhada, NivelRisco.emergencia), 5);
      expect(calcularPrioridade(TipoRelato.deslizamento, NivelRisco.alerta), 5);
    });
  });

  group('atualizarAlertas (alerta automático)', () {
    final agora = DateTime(2026, 11, 19, 12, 0);

    test('risco abaixo de ALERTA não cria alerta', () {
      final alertas = <Alerta>[];
      expect(atualizarAlertas(alertas, NivelRisco.atencao, estacao, agora),
          isNull);
      expect(alertas, isEmpty);
    });

    test('risco ALERTA sem alerta ativo cria um alerta', () {
      final alertas = <Alerta>[];
      final novo = atualizarAlertas(alertas, NivelRisco.alerta, estacao, agora);
      expect(novo, isNotNull);
      expect(novo!.nivel, NivelRisco.alerta);
      expect(novo.ativo, isTrue);
      expect(alertas.length, 1);
    });

    test('não cria outro quando já existe alerta ativo de nível igual', () {
      final alertas = <Alerta>[alertaAtivo(1, NivelRisco.alerta)];
      expect(atualizarAlertas(alertas, NivelRisco.alerta, estacao, agora),
          isNull);
      expect(alertas.length, 1);
    });

    test('não cria alerta menor quando já existe um maior ativo', () {
      final alertas = <Alerta>[alertaAtivo(1, NivelRisco.emergencia)];
      expect(atualizarAlertas(alertas, NivelRisco.alerta, estacao, agora),
          isNull);
      expect(alertas.first.ativo, isTrue);
    });

    test('EMERGÊNCIA encerra o ALERTA ativo e cria um alerta novo', () {
      final alertas = <Alerta>[alertaAtivo(1, NivelRisco.alerta)];
      final novo =
          atualizarAlertas(alertas, NivelRisco.emergencia, estacao, agora);

      expect(novo, isNotNull);
      expect(novo!.nivel, NivelRisco.emergencia);
      expect(alertas.length, 2);
      expect(alertas.last.ativo, isFalse); // o ALERTA antigo foi substituído
      expect(alertas.last.encerradoEm, agora);
      expect(alertas.first.ativo, isTrue);
    });
  });
}
