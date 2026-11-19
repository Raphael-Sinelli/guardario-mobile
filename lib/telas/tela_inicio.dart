import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/alerta.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';
import '../regras/regras_risco.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogo_login.dart';
import '../widgets/selo_risco.dart';
import 'tela_detalhe_alerta.dart';
import 'tela_kit.dart';
import 'tela_meus_relatos.dart';
import 'tela_novo_relato.dart';

// Tela inicial: nível do rio, alerta ativo, atalhos e a simulação de subida.
class TelaInicio extends StatefulWidget {
  // Função que a casca de navegação passa para trocar a aba aberta
  final void Function(int) irParaAba;

  const TelaInicio({super.key, required this.irParaAba});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  NivelRisco get _risco => calcularRisco(nivelRioCm, chuvaMmH, estacaoMock);

  // Primeiro alerta ativo da lista, ou null se não houver
  Alerta? get _alertaAtivo {
    for (final alerta in alertas) {
      if (alerta.ativo) {
        return alerta;
      }
    }
    return null;
  }

  void _simularSubida() {
    // Primeiro calcula o que vai mudar, depois o setState atualiza a tela
    final novoNivel = proximoNivelCm(nivelRioCm);
    final novaChuva = chuvaMmH + passoChuvaMmH;
    final novoRisco = calcularRisco(novoNivel, novaChuva, estacaoMock);
    final novoAlerta = atualizarAlertas(
      alertas,
      novoRisco,
      estacaoMock,
      DateTime.now(),
    );

    setState(() {
      nivelRioCm = novoNivel;
      chuvaMmH = novaChuva;
    });

    if (novoAlerta != null) {
      final corTexto = corTextoDoNivel(novoAlerta.nivel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: corDoNivel(novoAlerta.nivel),
          content: Row(
            children: [
              Icon(iconeDoNivel(novoAlerta.nivel), color: corTexto),
              const SizedBox(width: AppTheme.espacoP),
              Expanded(
                child: Text(
                  'Novo alerta: ${textoDoNivel(novoAlerta.nivel)} em '
                  '${novoAlerta.area}',
                  style: TextStyle(
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'VER',
            textColor: corTexto,
            onPressed: () {
              widget.irParaAba(1);
            },
          ),
        ),
      );
    }
  }

  void _reiniciarSimulacao() {
    setState(() {
      reiniciarSimulacao();
    });
  }

  Future<void> _novoRelato() async {
    // Quem entrou sem conta recebe um aviso com o botão para o login
    if (usuarioLogado == null) {
      mostrarDialogoExigeLogin(context);
      return;
    }

    // await espera o formulário fechar. O que ele devolve com Navigator.pop
    // chega aqui, ou null se a pessoa voltou sem enviar.
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Relato enviado. Prioridade ${relato.prioridade} de 5.'),
        backgroundColor: AppTheme.corNormal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuardaRio'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.espacoM),
            child: Image.asset('assets/logo.png', width: 36, height: 36),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        children: [
          _cardNivelDoRio(),
          const SizedBox(height: AppTheme.espacoM),
          _botoesDaSimulacao(),
          const SizedBox(height: AppTheme.espacoM),
          _bannerDoAlerta(),
          const SizedBox(height: AppTheme.espacoG),
          Text('Atalhos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppTheme.espacoP),
          _atalhos(),
        ],
      ),
    );
  }

  Widget _cardNivelDoRio() {
    final estilo = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water, color: AppTheme.azul),
                const SizedBox(width: AppTheme.espacoP),
                Expanded(
                  child: Text(
                    '${estacaoMock.rio} · ${estacaoMock.nome}',
                    style: estilo.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${estacaoMock.area}, ${estacaoMock.cidade}'),
            const SizedBox(height: AppTheme.espacoM),
            Row(
              children: [
                Expanded(child: _medida('$nivelRioCm cm', 'nível do rio')),
                Expanded(child: _medida('$chuvaMmH mm/h', 'chuva agora')),
              ],
            ),
            const SizedBox(height: AppTheme.espacoM),
            SeloRisco(nivel: _risco),
            const SizedBox(height: AppTheme.espacoM),
            _regua(),
            const SizedBox(height: AppTheme.espacoP),
            Text(
              'Cotas: atenção ${estacaoMock.cotaAtencao} cm, '
              'alerta ${estacaoMock.cotaAlerta} cm, '
              'transbordo ${estacaoMock.cotaTransbordo} cm',
              style: estilo.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _medida(String valor, String legenda) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(legenda),
      ],
    );
  }

  // Régua de 0 a 330 cm. Cada trecho ocupa uma largura proporcional ao seu
  // tamanho (o flex do Expanded) e a seta marca o nível atual.
  Widget _regua() {
    final c = estacaoMock;

    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: nivelRioCm, child: const SizedBox()),
            const Icon(Icons.arrow_drop_down, size: 28),
            Expanded(flex: tetoNivelCm - nivelRioCm, child: const SizedBox()),
          ],
        ),
        Row(
          children: [
            _trecho(c.cotaAtencao, AppTheme.corNormal),
            _trecho(c.cotaAlerta - c.cotaAtencao, AppTheme.corAtencao),
            _trecho(c.cotaTransbordo - c.cotaAlerta, AppTheme.corAlerta),
            _trecho(tetoNivelCm - c.cotaTransbordo, AppTheme.corEmergencia),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _marca(c.cotaAtencao, '0'),
            _marca(c.cotaAlerta - c.cotaAtencao, '${c.cotaAtencao}'),
            _marca(c.cotaTransbordo - c.cotaAlerta, '${c.cotaAlerta}'),
            _marca(tetoNivelCm - c.cotaTransbordo, '${c.cotaTransbordo}'),
          ],
        ),
      ],
    );
  }

  Widget _trecho(int tamanho, Color cor) {
    return Expanded(
      flex: tamanho,
      child: Container(height: 16, color: cor),
    );
  }

  Widget _marca(int tamanho, String texto) {
    return Expanded(
      flex: tamanho,
      child: Text(texto, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _botoesDaSimulacao() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: _simularSubida,
            icon: const Icon(Icons.trending_up),
            label: const Text('Simular subida do rio'),
          ),
        ),
        const SizedBox(width: AppTheme.espacoP),
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: _reiniciarSimulacao,
            child: const Text(
              'Reiniciar simulação',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bannerDoAlerta() {
    final alerta = _alertaAtivo;

    if (alerta == null) {
      return Card(
        color: corClaraDoNivel(NivelRisco.normal),
        child: const Padding(
          padding: EdgeInsets.all(AppTheme.espacoM),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.corNormal, size: 32),
              SizedBox(width: AppTheme.espacoM),
              Expanded(
                child: Text(
                  'Nenhum alerta ativo no momento.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final corTexto = corTextoDoNivel(alerta.nivel);
    return Card(
      color: corDoNivel(alerta.nivel),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.raioCard),
        // Toque no banner abre o detalhe e passa o alerta para a nova tela
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
          child: Row(
            children: [
              Icon(iconeDoNivel(alerta.nivel), color: corTexto, size: 36),
              const SizedBox(width: AppTheme.espacoM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ALERTA ATIVO: ${textoDoNivel(alerta.nivel)}',
                      style: TextStyle(
                        color: corTexto,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(alerta.mensagem, style: TextStyle(color: corTexto)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: corTexto),
            ],
          ),
        ),
      ),
    );
  }

  Widget _atalhos() {
    // GridView dentro do ListView: shrinkWrap faz o grid ter só a altura
    // necessária e a rolagem fica por conta do ListView
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppTheme.espacoM,
      crossAxisSpacing: AppTheme.espacoM,
      childAspectRatio: 1.1,
      children: [
        _atalho(Icons.edit_note, 'Novo relato', _novoRelato),
        _atalho(Icons.list_alt, 'Meus relatos', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaMeusRelatos()),
          );
        }),
        _atalho(Icons.medical_services_outlined, 'Kit de emergência', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaKit()),
          );
        }),
        _atalho(Icons.night_shelter, 'Abrigos', () {
          widget.irParaAba(2);
        }),
      ],
    );
  }

  Widget _atalho(IconData icone, String texto, VoidCallback aoTocar) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.raioCard),
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.espacoP),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 40, color: AppTheme.azul),
              const SizedBox(height: AppTheme.espacoP),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
