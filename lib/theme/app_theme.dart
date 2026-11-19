import 'package:flutter/material.dart';

// Tema único do app. Todas as telas usam estas cores, espaçamentos e estilos.
class AppTheme {
  // Azul principal do GuardaRio
  static const Color azul = Color(0xFF1F7AB8);

  // Cores fixas de risco. No app elas sempre aparecem junto com ícone e texto.
  static const Color corNormal = Color(0xFF2E7D32); // verde
  static const Color corAtencao = Color(0xFFF9A825); // amarelo
  static const Color corAlerta = Color(0xFFEF6C00); // laranja
  static const Color corEmergencia = Color(0xFFC62828); // vermelho

  // Cor do texto que fica em cima de cada cor de risco (amarelo e laranja
  // pedem texto escuro para ter contraste)
  static const Color textoSobreNormal = Colors.white;
  static const Color textoSobreAtencao = Color(0xDD000000);
  static const Color textoSobreAlerta = Color(0xDD000000);
  static const Color textoSobreEmergencia = Colors.white;

  // Cor de fundo das telas
  static const Color fundo = Color(0xFFF3F7FA);

  // Espaçamentos padrão: 8, 16 e 24
  static const double espacoP = 8;
  static const double espacoM = 16;
  static const double espacoG = 24;

  // Raio dos cards e dos botões
  static const double raioCard = 12;

  static ThemeData tema() {
    final bordaArredondada = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(raioCard),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: azul,
        primary: azul,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: fundo,

      // Letras maiores que o padrão: a pessoa que usa o app tem 67 anos
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: bordaArredondada,
      ),

      // Botões grandes, fáceis de tocar
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: azul,
          foregroundColor: Colors.white,
          minimumSize: const Size(88, 56),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: bordaArredondada,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: azul,
          minimumSize: const Size(88, 56),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          side: const BorderSide(color: azul, width: 2),
          shape: bordaArredondada,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(88, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Campos de formulário: borda vermelha forte quando há erro
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(espacoM),
        labelStyle: const TextStyle(fontSize: 16),
        errorStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: corEmergencia,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raioCard),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raioCard),
          borderSide: const BorderSide(color: corEmergencia, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raioCard),
          borderSide: const BorderSide(color: corEmergencia, width: 2),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: azul,
        unselectedItemColor: Color(0xFF546E7A),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 14),
      ),

      chipTheme: ChipThemeData(
        // Sem a cor o texto do chip saía quase branco e não dava para ler
        labelStyle: const TextStyle(fontSize: 16, color: Color(0xFF263238)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFD6EAF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(raioCard),
          side: const BorderSide(color: Color(0xFFB0BEC5)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
        shape: bordaArredondada,
      ),
    );
  }
}
