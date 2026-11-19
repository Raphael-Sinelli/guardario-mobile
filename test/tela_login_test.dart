import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/data/mock_data.dart';
import 'package:guardario_mobile/telas/tela_login.dart';
import 'package:guardario_mobile/theme/app_theme.dart';

Widget criarApp() {
  return MaterialApp(theme: AppTheme.tema(), home: const TelaLogin());
}

void main() {
  setUp(() {
    reiniciarDadosMock();
  });

  testWidgets('campos vazios mostram os dois erros', (tester) async {
    await tester.pumpWidget(criarApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();

    expect(find.text('Informe o e-mail'), findsOneWidget);
    expect(find.text('Informe a senha'), findsOneWidget);
  });

  testWidgets('e-mail inválido mostra o erro de formato', (tester) async {
    await tester.pumpWidget(criarApp());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'cida@guardario',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Senha'),
      '123456',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();

    expect(
      find.text('Digite um e-mail válido, como nome@email.com'),
      findsOneWidget,
    );
    expect(find.text('Informe a senha'), findsNothing);
  });

  testWidgets('senha com menos de 6 caracteres mostra o erro', (tester) async {
    await tester.pumpWidget(criarApp());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'cida@guardario.com',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), '123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();

    expect(
      find.text('A senha precisa ter no mínimo 6 caracteres'),
      findsOneWidget,
    );
  });

  testWidgets('credencial errada mostra o SnackBar e não entra', (
    tester,
  ) async {
    await tester.pumpWidget(criarApp());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'cida@guardario.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Senha'),
      'senhaerrada',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();

    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(usuarioLogado, isNull);
  });

  testWidgets('login correto navega para a tela principal', (tester) async {
    await tester.pumpWidget(criarApp());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'cida@guardario.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Senha'),
      '123456',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(usuarioLogado?.nome, 'Cida Souza');
  });
}
