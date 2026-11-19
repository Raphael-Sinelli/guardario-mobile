import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/data/mock_data.dart';
import 'package:guardario_mobile/models/relato.dart';
import 'package:guardario_mobile/regras/regras_risco.dart';
import 'package:guardario_mobile/models/nivel_risco.dart';

void main() {
  setUp(() {
    reiniciarDadosMock();
  });

  test('a estação tem as cotas combinadas', () {
    expect(estacaoMock.nome, 'Ponte da Rua Capachós');
    expect(estacaoMock.cotaAtencao, 150);
    expect(estacaoMock.cotaAlerta, 220);
    expect(estacaoMock.cotaTransbordo, 300);
  });

  test('o app começa com 130 cm, 8 mm/h e risco NORMAL', () {
    expect(nivelRioCm, 130);
    expect(chuvaMmH, 8);
    expect(calcularRisco(nivelRioCm, chuvaMmH, estacaoMock), NivelRisco.normal);
  });

  test('há 3 alertas antigos, todos encerrados', () {
    expect(alertas.length, 3);
    expect(alertas.every((a) => !a.ativo), isTrue);
  });

  test('há 5 abrigos, com lotado, sem pets e sem acessibilidade', () {
    expect(abrigos.length, 5);
    expect(abrigos.any((a) => a.lotado), isTrue);
    expect(abrigos.any((a) => !a.aceitaPets), isTrue);
    expect(abrigos.any((a) => !a.acessivelPcd), isTrue);
    expect(abrigos.any((a) => !a.lotado), isTrue);
  });

  test('nenhum abrigo passa da capacidade', () {
    for (final abrigo in abrigos) {
      expect(abrigo.ocupacao <= abrigo.capacidade, isTrue);
    }
  });

  test('há 1 relato antigo já resolvido', () {
    expect(relatos.length, 1);
    expect(relatos.first.status, StatusRelato.resolvido);
  });

  test('o kit tem 12 itens, todos desmarcados no início', () {
    expect(itensKit.length, 12);
    expect(itensKit.every((i) => !i.pronto), isTrue);
  });

  test('reiniciarSimulacao volta o rio e os alertas ao começo', () {
    nivelRioCm = 330;
    chuvaMmH = 68;
    alertas.insert(0, alertas.first);
    reiniciarSimulacao();
    expect(nivelRioCm, 130);
    expect(chuvaMmH, 8);
    expect(alertas.length, 3);
  });
}
