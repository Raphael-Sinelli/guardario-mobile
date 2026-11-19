import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

// Kit de emergência: a pessoa marca o que já separou e o contador muda com
// setState.
class TelaKit extends StatefulWidget {
  const TelaKit({super.key});

  @override
  State<TelaKit> createState() => _TelaKitState();
}

class _TelaKitState extends State<TelaKit> {
  int _quantosProntos() {
    int total = 0;
    for (final item in itensKit) {
      if (item.pronto) {
        total = total + 1;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final prontos = _quantosProntos();
    final total = itensKit.length;
    final completo = prontos == total;

    return Scaffold(
      appBar: AppBar(title: const Text('Kit de emergência')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.espacoM),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.espacoM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Itens prontos: $prontos de $total',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.espacoP),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: prontos / total,
                        minHeight: 12,
                        color: completo ? AppTheme.corNormal : AppTheme.azul,
                        backgroundColor: const Color(0xFFCFD8DC),
                      ),
                    ),
                    const SizedBox(height: AppTheme.espacoP),
                    Text(
                      completo
                          ? 'Kit completo. Deixe num lugar de fácil acesso.'
                          : 'Marque o que você já separou.',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.espacoM,
                0,
                AppTheme.espacoM,
                AppTheme.espacoM,
              ),
              itemCount: itensKit.length,
              itemBuilder: (context, indice) {
                final item = itensKit[indice];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.espacoP),
                  child: Card(
                    child: CheckboxListTile(
                      title: Text(
                        item.nome,
                        style: const TextStyle(fontSize: 18),
                      ),
                      value: item.pronto,
                      onChanged: (valor) {
                        setState(() {
                          item.pronto = valor ?? false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
