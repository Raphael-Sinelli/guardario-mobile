import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';
import '../regras/regras_risco.dart';
import '../theme/app_theme.dart';
import '../widgets/selo_risco.dart';

// Formulário de novo relato. Quando o envio é confirmado, a tela devolve o
// relato para a tela anterior com Navigator.pop.
class TelaNovoRelato extends StatefulWidget {
  const TelaNovoRelato({super.key});

  @override
  State<TelaNovoRelato> createState() => _TelaNovoRelatoState();
}

class _TelaNovoRelatoState extends State<TelaNovoRelato> {
  final _formKey = GlobalKey<FormState>();
  final _bairroController = TextEditingController();
  final _descricaoController = TextEditingController();
  TipoRelato? _tipo;
  bool _pessoasEmRisco = false;

  @override
  void dispose() {
    _bairroController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  String? _validarTipo(TipoRelato? valor) {
    if (valor == null) {
      return 'Escolha o tipo do relato';
    }
    return null;
  }

  String? _validarBairro(String? valor) {
    final bairro = (valor ?? '').trim();
    if (bairro.isEmpty) {
      return 'Informe o bairro';
    }
    if (bairro.length < 3) {
      return 'O bairro precisa ter no mínimo 3 letras';
    }
    return null;
  }

  String? _validarDescricao(String? valor) {
    final descricao = (valor ?? '').trim();
    if (descricao.length < 10) {
      return 'Descreva com pelo menos 10 caracteres';
    }
    if (descricao.length > 500) {
      return 'Use no máximo 500 caracteres';
    }
    return null;
  }

  // Uma opção do dropdown para cada tipo de relato
  List<DropdownMenuItem<TipoRelato>> _opcoesDeTipo() {
    List<DropdownMenuItem<TipoRelato>> opcoes = [];
    for (final tipo in TipoRelato.values) {
      opcoes.add(DropdownMenuItem(value: tipo, child: Text(nomeDoTipo(tipo))));
    }
    return opcoes;
  }

  Future<void> _enviar() async {
    // validate() roda todos os validators e mostra os erros em vermelho
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrija os campos em vermelho para enviar.'),
          backgroundColor: AppTheme.corEmergencia,
        ),
      );
      return;
    }

    // O validator do tipo garante que ele não é null aqui
    final tipo = _tipo!;
    final riscoDaArea = calcularRisco(nivelRioCm, chuvaMmH, estacaoMock);
    final prioridade = calcularPrioridade(tipo, riscoDaArea);
    final areaEmRisco =
        riscoDaArea == NivelRisco.alerta ||
        riscoDaArea == NivelRisco.emergencia;

    // O dialogo devolve true se a pessoa confirmou o envio
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextDialogo) {
        return AlertDialog(
          title: const Text('Confirmar relato'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo: ${nomeDoTipo(tipo)}'),
                Text('Bairro: ${_bairroController.text.trim()}'),
                Text('Pessoas em risco: ${_pessoasEmRisco ? 'sim' : 'não'}'),
                const SizedBox(height: AppTheme.espacoP),
                Text('Descrição: ${_descricaoController.text.trim()}'),
                const SizedBox(height: AppTheme.espacoM),
                Text(
                  'Prioridade calculada: $prioridade de 5',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (areaEmRisco) const SizedBox(height: AppTheme.espacoP),
                if (areaEmRisco)
                  Text(
                    'A área está em ${textoDoNivel(riscoDaArea)}, '
                    'por isso a prioridade subiu 1.',
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialogo, false);
              },
              child: const Text('Revisar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(contextDialogo, true);
              },
              child: const Text('Confirmar envio'),
            ),
          ],
        );
      },
    );

    // Depois de um await a tela pode ter saído da memória
    if (confirmou != true || !mounted) {
      return;
    }

    final relato = Relato(
      tipo: tipo,
      bairro: _bairroController.text.trim(),
      descricao: _descricaoController.text.trim(),
      pessoasEmRisco: _pessoasEmRisco,
      prioridade: prioridade,
      status: StatusRelato.aberto,
      criadoEm: DateTime.now(),
    );

    // Devolve o relato para a tela que abriu o formulário
    Navigator.pop(context, relato);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo relato')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'O que está acontecendo?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.espacoM),
              DropdownButtonFormField<TipoRelato>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Tipo do relato',
                  prefixIcon: Icon(Icons.report_problem_outlined),
                ),
                items: _opcoesDeTipo(),
                onChanged: (valor) {
                  setState(() {
                    _tipo = valor;
                  });
                },
                validator: _validarTipo,
              ),
              const SizedBox(height: AppTheme.espacoM),
              TextFormField(
                controller: _bairroController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: _validarBairro,
              ),
              const SizedBox(height: AppTheme.espacoM),
              TextFormField(
                controller: _descricaoController,
                maxLength: 500, // mostra o contador de caracteres
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                ),
                validator: _validarDescricao,
              ),
              Card(
                child: SwitchListTile(
                  title: const Text('Há pessoas em risco?'),
                  subtitle: const Text(
                    'Ligue se alguém precisa de ajuda agora.',
                  ),
                  value: _pessoasEmRisco,
                  onChanged: (valor) {
                    setState(() {
                      _pessoasEmRisco = valor;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppTheme.espacoG),
              ElevatedButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.send),
                label: const Text('Enviar relato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
