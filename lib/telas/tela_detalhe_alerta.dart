import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../models/nivel_risco.dart';
import '../theme/app_theme.dart';
import '../utils/formatar_data.dart';
import '../widgets/selo_risco.dart';

// Detalhe de um alerta. O objeto Alerta chega pelo construtor.
class TelaDetalheAlerta extends StatelessWidget {
  final Alerta alerta;

  const TelaDetalheAlerta({super.key, required this.alerta});

  // "O que fazer agora" para cada nível
  List<String> _acoesDoNivel(NivelRisco nivel) {
    switch (nivel) {
      case NivelRisco.normal:
        return [
          'Nenhuma ação necessária agora.',
          'Acompanhe o nível do rio pelo app.',
          'Deixe o kit de emergência pronto em casa.',
        ];
      case NivelRisco.atencao:
        return [
          'Acompanhe o nível do rio pelo app a cada hora.',
          'Separe documentos, remédios e lanterna.',
          'Combine com a família um ponto de encontro.',
          'Veja qual abrigo aceita pets e tem vagas.',
        ];
      case NivelRisco.alerta:
        return [
          'Guarde documentos e remédios em saco plástico.',
          'Suba móveis e eletrodomésticos para lugares altos.',
          'Prepare a saída com o kit de emergência e o pet.',
          'Veja na aba Abrigos qual tem vagas e acessibilidade.',
          'Não atravesse ruas alagadas.',
        ];
      case NivelRisco.emergencia:
        return [
          'Saia de casa agora e leve o kit, os documentos e o pet.',
          'Vá para o abrigo mais próximo que tenha vagas.',
          'Desligue a luz e o gás se der tempo.',
          'Não atravesse ruas alagadas nem tente salvar objetos.',
          'Peça ajuda à Defesa Civil pelo telefone 199.',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final corTexto = corTextoDoNivel(alerta.nivel);
    final encerradoEm = alerta.encerradoEm;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do alerta')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        children: [
          // Faixa grande com a cor, o ícone e o texto do nível
          Card(
            color: corDoNivel(alerta.nivel),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.espacoG),
              child: Column(
                children: [
                  Icon(iconeDoNivel(alerta.nivel), size: 56, color: corTexto),
                  const SizedBox(height: AppTheme.espacoP),
                  Text(
                    textoDoNivel(alerta.nivel),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    alerta.ativo ? 'Alerta ativo' : 'Alerta encerrado',
                    style: TextStyle(color: corTexto, fontSize: 18),
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
                  _linha(Icons.place, 'Área', alerta.area),
                  _linha(
                    Icons.schedule,
                    'Emitido em',
                    formatarDataHora(alerta.criadoEm),
                  ),
                  if (encerradoEm != null)
                    _linha(
                      Icons.event_available,
                      'Encerrado em',
                      formatarDataHora(encerradoEm),
                    ),
                  _linha(
                    Icons.chat_bubble_outline,
                    'Mensagem',
                    alerta.mensagem,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.espacoG),
          Text(
            'O que fazer agora',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (!alerta.ativo)
            const Padding(
              padding: EdgeInsets.only(top: AppTheme.espacoP),
              child: Text(
                'Este alerta já foi encerrado. As orientações valem se o '
                'nível do rio voltar a subir.',
              ),
            ),
          const SizedBox(height: AppTheme.espacoM),
          _listaDePassos(_acoesDoNivel(alerta.nivel)),
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
                Text(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaDePassos(List<String> acoes) {
    List<Widget> passos = [];
    for (int i = 0; i < acoes.length; i++) {
      passos.add(_passo(i + 1, acoes[i]));
    }
    return Column(children: passos);
  }

  Widget _passo(int numero, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.espacoP),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.espacoM),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.azul,
                foregroundColor: Colors.white,
                child: Text('$numero'),
              ),
              const SizedBox(width: AppTheme.espacoM),
              Expanded(
                child: Text(texto, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
