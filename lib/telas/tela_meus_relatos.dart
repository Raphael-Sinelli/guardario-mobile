import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/relato.dart';
import '../theme/app_theme.dart';
import '../utils/formatar_data.dart';
import '../widgets/dialogo_login.dart';
import '../widgets/etiqueta.dart';
import 'tela_login.dart';
import 'tela_novo_relato.dart';

// Lista dos relatos da pessoa. Quando o formulário devolve um relato novo,
// ele entra no topo da lista com setState.
class TelaMeusRelatos extends StatefulWidget {
  const TelaMeusRelatos({super.key});

  @override
  State<TelaMeusRelatos> createState() => _TelaMeusRelatosState();
}

class _TelaMeusRelatosState extends State<TelaMeusRelatos> {
  Future<void> _novoRelato() async {
    if (usuarioLogado == null) {
      mostrarDialogoExigeLogin(context);
      return;
    }

    // await espera o formulário fechar e recebe o relato do Navigator.pop
    final Relato? relato = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaNovoRelato()),
    );

    if (relato == null || !mounted) {
      return;
    }

    setState(() {
      relatos.insert(0, relato);
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Relato enviado. Prioridade ${relato.prioridade} de 5.'),
        backgroundColor: AppTheme.corNormal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget corpo;
    if (usuarioLogado == null) {
      corpo = _avisoSemConta();
    } else if (relatos.isEmpty) {
      corpo = _listaVazia();
    } else {
      corpo = ListView.builder(
        // espaço extra embaixo para o botão flutuante não cobrir o último card
        padding: const EdgeInsets.fromLTRB(
          AppTheme.espacoM,
          AppTheme.espacoM,
          AppTheme.espacoM,
          88,
        ),
        itemCount: relatos.length,
        itemBuilder: (context, indice) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.espacoM),
            child: _cartaoDoRelato(relatos[indice]),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Meus relatos')),
      body: corpo,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.azul,
        foregroundColor: Colors.white,
        onPressed: _novoRelato,
        icon: const Icon(Icons.add),
        label: const Text('Novo relato'),
      ),
    );
  }

  Widget _avisoSemConta() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.espacoG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Color(0xFF78909C)),
            const SizedBox(height: AppTheme.espacoM),
            Text(
              'Entre na sua conta para ver e enviar relatos.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.espacoM),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLogin()),
                );
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.espacoG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox, size: 64, color: Color(0xFF78909C)),
            const SizedBox(height: AppTheme.espacoM),
            Text(
              'Você ainda não enviou nenhum relato.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartaoDoRelato(Relato relato) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconeDoTipo(relato.tipo), color: AppTheme.azul),
                const SizedBox(width: AppTheme.espacoP),
                Expanded(
                  child: Text(
                    nomeDoTipo(relato.tipo),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${relato.bairro} · ${formatarDataHora(relato.criadoEm)}'),
            const SizedBox(height: AppTheme.espacoP),
            Text(relato.descricao),
            const SizedBox(height: AppTheme.espacoP),
            Wrap(
              spacing: AppTheme.espacoP,
              runSpacing: AppTheme.espacoP,
              children: [
                _etiquetaDePrioridade(relato.prioridade),
                _etiquetaDeStatus(relato.status),
                if (relato.pessoasEmRisco)
                  const Etiqueta(
                    texto: 'Pessoas em risco',
                    icone: Icons.warning,
                    cor: Color(0xFFFFEBEE),
                    corTexto: Color(0xFFB71C1C),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconeDoTipo(TipoRelato tipo) {
    switch (tipo) {
      case TipoRelato.pessoaIlhada:
        return Icons.sos;
      case TipoRelato.deslizamento:
        return Icons.landslide;
      case TipoRelato.rioSubindo:
        return Icons.water;
      case TipoRelato.alagamentoVia:
        return Icons.flood;
      case TipoRelato.bueiroEntupido:
        return Icons.plumbing;
      case TipoRelato.outro:
        return Icons.report_problem;
    }
  }

  // Quanto maior a prioridade, mais forte a cor
  Widget _etiquetaDePrioridade(int prioridade) {
    Color cor = const Color(0xFFD6EAF7);
    Color corTexto = const Color(0xFF263238);
    if (prioridade >= 5) {
      cor = AppTheme.corEmergencia;
      corTexto = Colors.white;
    } else if (prioridade == 4) {
      cor = AppTheme.corAlerta;
      corTexto = AppTheme.textoSobreAlerta;
    } else if (prioridade == 3) {
      cor = AppTheme.corAtencao;
      corTexto = AppTheme.textoSobreAtencao;
    }
    return Etiqueta(
      texto: 'Prioridade $prioridade de 5',
      icone: Icons.flag,
      cor: cor,
      corTexto: corTexto,
    );
  }

  Widget _etiquetaDeStatus(StatusRelato status) {
    Color cor;
    Color corTexto = Colors.white;
    IconData icone;
    switch (status) {
      case StatusRelato.aberto:
        cor = AppTheme.azul;
        icone = Icons.schedule;
      case StatusRelato.emAtendimento:
        cor = AppTheme.corAlerta;
        corTexto = AppTheme.textoSobreAlerta;
        icone = Icons.build;
      case StatusRelato.resolvido:
        cor = AppTheme.corNormal;
        icone = Icons.check_circle;
      case StatusRelato.descartado:
        cor = const Color(0xFF546E7A);
        icone = Icons.cancel;
    }
    return Etiqueta(
      texto: nomeDoStatus(status),
      icone: icone,
      cor: cor,
      corTexto: corTexto,
    );
  }
}
