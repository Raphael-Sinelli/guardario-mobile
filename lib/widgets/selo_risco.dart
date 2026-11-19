import 'package:flutter/material.dart';

import '../models/nivel_risco.dart';
import '../theme/app_theme.dart';

// O risco sempre aparece com cor, ícone e texto, nunca só com cor.
// Estas quatro funções dizem como cada nível é mostrado.

Color corDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.normal:
      return AppTheme.corNormal;
    case NivelRisco.atencao:
      return AppTheme.corAtencao;
    case NivelRisco.alerta:
      return AppTheme.corAlerta;
    case NivelRisco.emergencia:
      return AppTheme.corEmergencia;
  }
}

// Texto que fica em cima da cor forte do nível
Color corTextoDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.normal:
      return AppTheme.textoSobreNormal;
    case NivelRisco.atencao:
      return AppTheme.textoSobreAtencao;
    case NivelRisco.alerta:
      return AppTheme.textoSobreAlerta;
    case NivelRisco.emergencia:
      return AppTheme.textoSobreEmergencia;
  }
}

// Versão clara da cor, para o fundo dos cards
Color corClaraDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.normal:
      return const Color(0xFFE8F5E9);
    case NivelRisco.atencao:
      return const Color(0xFFFFF8E1);
    case NivelRisco.alerta:
      return const Color(0xFFFFF3E0);
    case NivelRisco.emergencia:
      return const Color(0xFFFFEBEE);
  }
}

IconData iconeDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.normal:
      return Icons.check_circle;
    case NivelRisco.atencao:
      return Icons.info;
    case NivelRisco.alerta:
      return Icons.warning;
    case NivelRisco.emergencia:
      return Icons.crisis_alert;
  }
}

String textoDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.normal:
      return 'NORMAL';
    case NivelRisco.atencao:
      return 'ATENÇÃO';
    case NivelRisco.alerta:
      return 'ALERTA';
    case NivelRisco.emergencia:
      return 'EMERGÊNCIA';
  }
}

// Etiqueta colorida com ícone e texto do nível
class SeloRisco extends StatelessWidget {
  final NivelRisco nivel;

  const SeloRisco({super.key, required this.nivel});

  @override
  Widget build(BuildContext context) {
    final corTexto = corTextoDoNivel(nivel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: corDoNivel(nivel),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconeDoNivel(nivel), size: 20, color: corTexto),
          const SizedBox(width: 6),
          Text(
            textoDoNivel(nivel),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
        ],
      ),
    );
  }
}
