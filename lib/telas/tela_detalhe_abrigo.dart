import 'package:flutter/material.dart';

import '../models/abrigo.dart';
import '../theme/app_theme.dart';
import '../widgets/etiquetas_do_abrigo.dart';

// Detalhe de um abrigo. O objeto Abrigo chega pelo construtor.
class TelaDetalheAbrigo extends StatelessWidget {
  final Abrigo abrigo;

  const TelaDetalheAbrigo({super.key, required this.abrigo});

  @override
  Widget build(BuildContext context) {
    // Fração de 0 a 1 para o LinearProgressIndicator
    final proporcao = abrigo.ocupacao / abrigo.capacidade;
    final porcentagem = (proporcao * 100).round();

    // A barra muda de cor conforme o abrigo vai enchendo
    Color corDaBarra = AppTheme.corNormal;
    if (proporcao >= 1) {
      corDaBarra = AppTheme.corEmergencia;
    } else if (proporcao >= 0.7) {
      corDaBarra = AppTheme.corAlerta;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do abrigo')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.espacoM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    abrigo.nome,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.espacoP),
                  Wrap(
                    spacing: AppTheme.espacoP,
                    runSpacing: AppTheme.espacoP,
                    children: [
                      etiquetaDeStatus(abrigo),
                      etiquetaDePets(abrigo),
                      etiquetaDePcd(abrigo),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.espacoM),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.espacoM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ocupação',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.espacoP),
                  Text(
                    '${abrigo.ocupacao} de ${abrigo.capacidade} pessoas '
                    '($porcentagem%)',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: AppTheme.espacoP),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: proporcao,
                      minHeight: 16,
                      color: corDaBarra,
                      backgroundColor: const Color(0xFFCFD8DC),
                    ),
                  ),
                  const SizedBox(height: AppTheme.espacoP),
                  Text(
                    abrigo.lotado
                        ? 'Abrigo lotado. Procure outro abrigo com vagas.'
                        : '${abrigo.vagas} vagas livres.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.espacoM),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.espacoM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _linha(Icons.place, 'Endereço', abrigo.endereco),
                  _linha(Icons.phone, 'Telefone', abrigo.telefone),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(IconData icone, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.espacoP),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: AppTheme.azul),
          const SizedBox(width: AppTheme.espacoP),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(valor, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
