import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'tela_kit.dart';
import 'tela_login.dart';
import 'tela_meus_relatos.dart';

// Perfil da pessoa. Quem entrou sem conta vê o botão Entrar no lugar do Sair.
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.espacoG),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.azul,
                    foregroundColor: Colors.white,
                    child: usuario == null
                        ? const Icon(Icons.person, size: 40)
                        : Text(
                            usuario.nome.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: AppTheme.espacoM),
                  Text(
                    usuario == null ? 'Visitante' : usuario.nome,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usuario == null ? 'Você entrou sem conta.' : usuario.email,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.espacoM),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.list_alt, color: AppTheme.azul),
                  title: const Text(
                    'Meus relatos',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaMeusRelatos(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.medical_services_outlined,
                    color: AppTheme.azul,
                  ),
                  title: const Text(
                    'Kit de emergência',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaKit()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.espacoG),
          if (usuario == null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLogin()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Entrar'),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                usuarioLogado = null;
                // Volta até a primeira tela da pilha, a de boas-vindas
                Navigator.popUntil(context, (rota) => rota.isFirst);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
        ],
      ),
    );
  }
}
