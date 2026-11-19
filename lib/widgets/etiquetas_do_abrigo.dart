import 'package:flutter/material.dart';

import '../models/abrigo.dart';
import '../theme/app_theme.dart';
import 'etiqueta.dart';

// As três etiquetas de um abrigo, usadas na lista e no detalhe.
// Cada uma tem ícone, texto e cor, nunca só cor.

Widget etiquetaDeStatus(Abrigo abrigo) {
  if (abrigo.lotado) {
    return const Etiqueta(
      texto: 'LOTADO',
      icone: Icons.block,
      cor: AppTheme.corEmergencia,
      corTexto: Colors.white,
    );
  }
  return const Etiqueta(
    texto: 'ABERTO',
    icone: Icons.check_circle,
    cor: AppTheme.corNormal,
    corTexto: Colors.white,
  );
}

Widget etiquetaDePets(Abrigo abrigo) {
  return Etiqueta(
    texto: abrigo.aceitaPets ? 'Aceita pets' : 'Não aceita pets',
    icone: abrigo.aceitaPets ? Icons.pets : Icons.do_not_disturb_alt,
    cor: abrigo.aceitaPets ? const Color(0xFFD6EAF7) : const Color(0xFFECEFF1),
    corTexto: const Color(0xFF263238),
  );
}

Widget etiquetaDePcd(Abrigo abrigo) {
  return Etiqueta(
    texto: abrigo.acessivelPcd ? 'Acessível PcD' : 'Sem acessibilidade',
    icone: abrigo.acessivelPcd ? Icons.accessible : Icons.not_accessible,
    cor: abrigo.acessivelPcd
        ? const Color(0xFFD6EAF7)
        : const Color(0xFFECEFF1),
    corTexto: const Color(0xFF263238),
  );
}
