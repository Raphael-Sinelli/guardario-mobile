import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/abrigo.dart';
import '../theme/app_theme.dart';
import '../widgets/etiquetas_do_abrigo.dart';
import 'tela_detalhe_abrigo.dart';

// Lista de abrigos com filtros e favoritos. O estado dos filtros e dos
// favoritos muda com setState.
class TelaAbrigos extends StatefulWidget {
  const TelaAbrigos({super.key});

  @override
  State<TelaAbrigos> createState() => _TelaAbrigosState();
}

class _TelaAbrigosState extends State<TelaAbrigos> {
  bool _soPets = false;
  bool _soPcd = false;
  bool _soComVagas = false;
  bool _soFavoritos = false;

  // Devolve só os abrigos que passam em todos os filtros ligados
  List<Abrigo> _abrigosFiltrados() {
    List<Abrigo> resultado = [];
    for (final abrigo in abrigos) {
      final passaPets = !_soPets || abrigo.aceitaPets;
      final passaPcd = !_soPcd || abrigo.acessivelPcd;
      final passaVagas = !_soComVagas || !abrigo.lotado;
      final passaFavoritos = !_soFavoritos || abrigo.favorito;

      if (passaPets && passaPcd && passaVagas && passaFavoritos) {
        resultado.add(abrigo);
      }
    }
    return resultado;
  }

  void _limparFiltros() {
    setState(() {
      _soPets = false;
      _soPcd = false;
      _soComVagas = false;
      _soFavoritos = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lista = _abrigosFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abrigos'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.espacoM),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: AppTheme.espacoP,
                runSpacing: AppTheme.espacoP,
                children: [
                  FilterChip(
                    avatar: const Icon(Icons.pets),
                    label: const Text('Aceita pets'),
                    selected: _soPets,
                    onSelected: (valor) {
                      setState(() {
                        _soPets = valor;
                      });
                    },
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.accessible),
                    label: const Text('Acessível PcD'),
                    selected: _soPcd,
                    onSelected: (valor) {
                      setState(() {
                        _soPcd = valor;
                      });
                    },
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.event_seat),
                    label: const Text('Com vagas'),
                    selected: _soComVagas,
                    onSelected: (valor) {
                      setState(() {
                        _soComVagas = valor;
                      });
                    },
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.star),
                    label: const Text('Favoritos'),
                    selected: _soFavoritos,
                    onSelected: (valor) {
                      setState(() {
                        _soFavoritos = valor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? _listaVazia()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.espacoM,
                      0,
                      AppTheme.espacoM,
                      AppTheme.espacoM,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (context, indice) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppTheme.espacoM,
                        ),
                        child: _cartaoDoAbrigo(lista[indice]),
                      );
                    },
                  ),
          ),
        ],
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
            const Icon(Icons.search_off, size: 64, color: Color(0xFF78909C)),
            const SizedBox(height: AppTheme.espacoM),
            Text(
              'Nenhum abrigo atende a esses filtros.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.espacoM),
            OutlinedButton(
              onPressed: _limparFiltros,
              child: const Text('Limpar filtros'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartaoDoAbrigo(Abrigo abrigo) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.raioCard),
        // Toque no card abre o detalhe e passa o abrigo para a nova tela
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaDetalheAbrigo(abrigo: abrigo),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.espacoM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      abrigo.nome,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(abrigo.endereco),
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
                    const SizedBox(height: AppTheme.espacoP),
                    Text(
                      abrigo.lotado
                          ? 'Sem vagas (${abrigo.capacidade} de ${abrigo.capacidade})'
                          : '${abrigo.vagas} vagas livres de ${abrigo.capacidade}',
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: abrigo.favorito
                    ? 'Tirar dos favoritos'
                    : 'Adicionar aos favoritos',
                iconSize: 32,
                icon: Icon(
                  abrigo.favorito ? Icons.star : Icons.star_border,
                  color: abrigo.favorito
                      ? const Color(0xFFF9A825)
                      : const Color(0xFF546E7A),
                ),
                onPressed: () {
                  setState(() {
                    abrigo.favorito = !abrigo.favorito;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
