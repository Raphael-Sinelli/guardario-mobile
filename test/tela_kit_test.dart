import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/data/mock_data.dart';
import 'package:guardario_mobile/telas/tela_kit.dart';
import 'package:guardario_mobile/theme/app_theme.dart';

void main() {
  setUp(() {
    reiniciarDadosMock();
  });

  testWidgets('o contador muda quando os itens são marcados', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tema(), home: const TelaKit()),
    );

    expect(find.text('Itens prontos: 0 de 12'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.pump();
    expect(find.text('Itens prontos: 1 de 12'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump();
    expect(find.text('Itens prontos: 2 de 12'), findsOneWidget);

    // Desmarcar volta o contador
    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.pump();
    expect(find.text('Itens prontos: 1 de 12'), findsOneWidget);
  });
}
