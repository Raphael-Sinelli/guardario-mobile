import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/data/mock_data.dart';
import 'package:guardario_mobile/models/relato.dart';
import 'package:guardario_mobile/telas/tela_novo_relato.dart';
import 'package:guardario_mobile/theme/app_theme.dart';

// Tela alta para o formulário inteiro caber sem rolar
void usarTelaAlta(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(600, 2000);
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() {
    reiniciarDadosMock();
  });

  testWidgets('formulário vazio mostra os erros e o SnackBar', (tester) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tema(), home: const TelaNovoRelato()),
    );

    await tester.tap(find.text('Enviar relato'));
    await tester.pump();

    expect(find.text('Escolha o tipo do relato'), findsOneWidget);
    expect(find.text('Informe o bairro'), findsOneWidget);
    expect(find.text('Descreva com pelo menos 10 caracteres'), findsOneWidget);
    expect(
      find.text('Corrija os campos em vermelho para enviar.'),
      findsOneWidget,
    );
  });

  testWidgets('descrição mostra o contador de caracteres', (tester) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tema(), home: const TelaNovoRelato()),
    );

    expect(find.text('0/500'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descrição'),
      'Rua alagada',
    );
    await tester.pump();
    expect(find.text('11/500'), findsOneWidget);
  });

  testWidgets('envio válido confirma e devolve o relato', (tester) async {
    usarTelaAlta(tester);
    Relato? devolvido;

    // Tela de teste que abre o formulário e guarda o que ele devolve
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tema(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  devolvido = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaNovoRelato(),
                    ),
                  );
                },
                child: const Text('abrir formulario'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('abrir formulario'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoRelato>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rio subindo').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Bairro'),
      'Jardim Pantanal',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descrição'),
      'A água já cobriu a calçada da rua principal.',
    );
    await tester.tap(find.text('Enviar relato'));
    await tester.pumpAndSettle();

    // Área em NORMAL: rio subindo vale 3
    expect(find.text('Confirmar relato'), findsOneWidget);
    expect(find.text('Prioridade calculada: 3 de 5'), findsOneWidget);

    await tester.tap(find.text('Confirmar envio'));
    await tester.pumpAndSettle();

    expect(devolvido, isNotNull);
    expect(devolvido!.tipo, TipoRelato.rioSubindo);
    expect(devolvido!.prioridade, 3);
    expect(devolvido!.status, StatusRelato.aberto);
  });
}
