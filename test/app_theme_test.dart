import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/theme/app_theme.dart';

void main() {
  final tema = AppTheme.tema();

  test('a cor primária é o azul do GuardaRio', () {
    expect(tema.colorScheme.primary, const Color(0xFF1F7AB8));
  });

  test('os cards têm raio 12', () {
    final forma = tema.cardTheme.shape as RoundedRectangleBorder;
    expect(forma.borderRadius, BorderRadius.circular(12));
  });

  test('o texto dos chips tem cor escura definida', () {
    // Sem cor definida o texto do chip saía quase branco e não dava para ler
    final cor = tema.chipTheme.labelStyle?.color;
    expect(cor, isNotNull);
    expect(cor!.computeLuminance() < 0.2, isTrue);
  });

  test('as quatro cores de risco são diferentes', () {
    final cores = {
      AppTheme.corNormal,
      AppTheme.corAtencao,
      AppTheme.corAlerta,
      AppTheme.corEmergencia,
    };
    expect(cores.length, 4);
  });
}
