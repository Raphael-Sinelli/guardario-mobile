import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/data/mock_data.dart';
import 'package:guardario_mobile/telas/tela_abrigos.dart';
import 'package:guardario_mobile/telas/tela_inicio.dart';
import 'package:guardario_mobile/theme/app_theme.dart';

// Tela alta para a tela inicial inteira ficar construída, sem rolar
void usarTelaAlta(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(600, 2400);
  addTearDown(tester.view.reset);
}

Widget criarInicio() {
  return MaterialApp(
    theme: AppTheme.tema(),
    home: TelaInicio(irParaAba: (indice) {}),
  );
}

void main() {
  setUp(() {
    reiniciarDadosMock();
  });

  testWidgets('Simular subida muda o nível e o risco', (tester) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(criarInicio());

    expect(find.text('130 cm'), findsOneWidget);
    expect(find.text('NORMAL'), findsOneWidget);
    expect(find.text('Nenhum alerta ativo no momento.'), findsOneWidget);

    // 1º toque: 170 cm, 20 mm/h
    await tester.tap(find.text('Simular subida do rio'));
    await tester.pump();
    expect(find.text('170 cm'), findsOneWidget);
    expect(find.text('ATENÇÃO'), findsOneWidget);

    // 2º toque: 210 cm, 32 mm/h, ainda ATENÇÃO
    await tester.tap(find.text('Simular subida do rio'));
    await tester.pump();
    expect(find.text('210 cm'), findsOneWidget);
    expect(find.text('ATENÇÃO'), findsOneWidget);

    // 3º toque: 250 cm, 44 mm/h, ALERTA e alerta automático
    await tester.tap(find.text('Simular subida do rio'));
    await tester.pump();
    expect(find.text('250 cm'), findsOneWidget);
    expect(find.text('ALERTA'), findsOneWidget);
    expect(find.text('ALERTA ATIVO: ALERTA'), findsOneWidget);
    expect(find.text('Novo alerta: ALERTA em Jardim Pantanal'), findsOneWidget);

    // 4º toque: 290 cm, 56 mm/h, a chuva sobe para EMERGÊNCIA
    await tester.tap(find.text('Simular subida do rio'));
    await tester.pump();
    expect(find.text('290 cm'), findsOneWidget);
    expect(find.text('EMERGÊNCIA'), findsOneWidget);
    expect(find.text('ALERTA ATIVO: EMERGÊNCIA'), findsOneWidget);

    // O aviso do alerta novo não fica preso atrás do aviso anterior
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.text('Novo alerta: EMERGÊNCIA em Jardim Pantanal'),
      findsOneWidget,
    );
    expect(find.text('Novo alerta: ALERTA em Jardim Pantanal'), findsNothing);
  });

  testWidgets('Reiniciar simulação volta ao começo', (tester) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(criarInicio());

    await tester.tap(find.text('Simular subida do rio'));
    await tester.pump();
    expect(find.text('170 cm'), findsOneWidget);

    await tester.tap(find.text('Reiniciar simulação'));
    await tester.pump();
    expect(find.text('130 cm'), findsOneWidget);
    expect(find.text('NORMAL'), findsOneWidget);
  });

  testWidgets('visitante recebe o aviso ao tentar enviar um relato', (
    tester,
  ) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(criarInicio());

    await tester.tap(find.text('Novo relato'));
    await tester.pumpAndSettle();

    expect(find.text('Entre para enviar um relato'), findsOneWidget);
    expect(find.text('Ir para o login'), findsOneWidget);
  });

  testWidgets('filtro sem resultado mostra a mensagem de lista vazia', (
    tester,
  ) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tema(), home: const TelaAbrigos()),
    );

    expect(find.text('Nenhum abrigo atende a esses filtros.'), findsNothing);

    // Ninguém favoritou nada ainda, então o filtro Favoritos fica vazio
    await tester.tap(find.text('Favoritos'));
    await tester.pump();

    expect(find.text('Nenhum abrigo atende a esses filtros.'), findsOneWidget);
  });
}
