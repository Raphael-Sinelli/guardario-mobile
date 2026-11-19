import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/alerta.dart';
import '../models/nivel_risco.dart';
import '../theme/app_theme.dart';
import '../utils/formatar_data.dart';
import '../widgets/selo_risco.dart';
import 'tela_detalhe_alerta.dart';

// Lista de alertas. O alerta ativo aparece em destaque, com o card cheio na
// cor do nível. Os encerrados ficam com fundo claro.
class TelaAlertas extends StatelessWidget {
  const TelaAlertas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        // O item 0 é o resumo no topo; os alertas vêm depois
        itemCount: alertas.length + 1,
        itemBuilder: (context, indice) {
          if (indice == 0) {
            return _resumo(context);
          }
          final alerta = alertas[indice - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.espacoM),
            child: _cartaoDoAlerta(context, alerta),
          );
        },
      ),
    );
  }

  Widget _resumo(BuildContext context) {
    final temAtivo = alertas.any((alerta) => alerta.ativo);

    if (!temAtivo) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.espacoM),
        child: Card(
          color: corClaraDoNivel(NivelRisco.normal),
          child: const Padding(
            padding: EdgeInsets.all(AppTheme.espacoM),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.corNormal, size: 32),
                SizedBox(width: AppTheme.espacoM),
                Expanded(
                  child: Text(
                    'Nenhum alerta ativo. Veja o histórico abaixo.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.espacoM),
      child: Text(
        'Alerta ativo em destaque',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _cartaoDoAlerta(BuildContext context, Alerta alerta) {
    final cor = corDoNivel(alerta.nivel);
    final corTexto = corTextoDoNivel(alerta.nivel);

    return Card(
      // Ativo: cor cheia do nível. Encerrado: versão clara da cor.
      color: alerta.ativo ? cor : corClaraDoNivel(alerta.nivel),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.raioCard),
        side: BorderSide(color: cor, width: alerta.ativo ? 4 : 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.raioCard),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaDetalheAlerta(alerta: alerta),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.espacoM),
          child: alerta.ativo
              ? _conteudoAtivo(alerta, corTexto)
              : _conteudoEncerrado(alerta),
        ),
      ),
    );
  }

  Widget _conteudoAtivo(Alerta alerta, Color corTexto) {
    return Row(
      children: [
        Icon(iconeDoNivel(alerta.nivel), size: 40, color: corTexto),
        const SizedBox(width: AppTheme.espacoM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALERTA ATIVO',
                style: TextStyle(
                  color: corTexto,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${textoDoNivel(alerta.nivel)} em ${alerta.area}',
                style: TextStyle(
                  color: corTexto,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(alerta.mensagem, style: TextStyle(color: corTexto)),
              const SizedBox(height: AppTheme.espacoP),
              Text(
                'Emitido em ${formatarDataHora(alerta.criadoEm)}',
                style: TextStyle(color: corTexto),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: corTexto),
      ],
    );
  }

  Widget _conteudoEncerrado(Alerta alerta) {
    final encerradoEm = alerta.encerradoEm;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SeloRisco(nivel: alerta.nivel),
                  const SizedBox(width: AppTheme.espacoP),
                  const Text(
                    'ENCERRADO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.espacoP),
              Text(
                alerta.area,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(alerta.mensagem),
              const SizedBox(height: AppTheme.espacoP),
              Text('Emitido em ${formatarDataHora(alerta.criadoEm)}'),
              if (encerradoEm != null)
                Text('Encerrado em ${formatarDataHora(encerradoEm)}'),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}
