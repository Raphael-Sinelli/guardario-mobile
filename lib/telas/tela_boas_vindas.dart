import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Primeira tela: logo e as duas formas de entrar no app.
// Os botões ainda não navegam: o login e a casca de navegação entram nos
// próximos commits.
class TelaBoasVindas extends StatelessWidget {
  const TelaBoasVindas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.espacoG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expanded ocupa o espaço que sobra e deixa os botões embaixo
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png', width: 160, height: 160),
                    const SizedBox(height: AppTheme.espacoM),
                    Text(
                      'GuardaRio',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 32,
                            color: AppTheme.azul,
                          ),
                    ),
                    const SizedBox(height: AppTheme.espacoP),
                    Text(
                      'O rio avisa antes de subir.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Entrar'),
              ),
              const SizedBox(height: AppTheme.espacoM),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Continuar sem conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
