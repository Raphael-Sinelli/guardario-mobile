import 'package:flutter/material.dart';

import '../telas/tela_login.dart';

// Aviso para quem entrou sem conta e tentou enviar um relato.
// O botão "Ir para o login" abre a tela de login.
void mostrarDialogoExigeLogin(BuildContext context) {
  showDialog(
    context: context,
    builder: (contextDialogo) {
      return AlertDialog(
        icon: const Icon(Icons.lock_outline, size: 40),
        title: const Text('Entre para enviar um relato'),
        content: const Text(
          'Para enviar um relato precisamos saber quem você é. '
          'Alertas, abrigos e nível do rio continuam abertos sem conta.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(contextDialogo);
            },
            child: const Text('Agora não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(contextDialogo);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
            child: const Text('Ir para o login'),
          ),
        ],
      );
    },
  );
}
