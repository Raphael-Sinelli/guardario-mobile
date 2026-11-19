import 'package:flutter/material.dart';

// Etiqueta arredondada com ícone e texto. Serve para status (ABERTO, LOTADO),
// características do abrigo e prioridade do relato.
class Etiqueta extends StatelessWidget {
  final String texto;
  final IconData icone;
  final Color cor;
  final Color corTexto;

  const Etiqueta({
    super.key,
    required this.texto,
    required this.icone,
    required this.cor,
    required this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 18, color: corTexto),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
        ],
      ),
    );
  }
}
