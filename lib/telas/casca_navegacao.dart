import 'package:flutter/material.dart';

// Casca do app: guarda qual aba está aberta e mostra a BottomNavigationBar.
// Nesta versão as quatro abas ainda são provisórias; as telas reais entram
// nos próximos commits.
class CascaNavegacao extends StatefulWidget {
  const CascaNavegacao({super.key});

  @override
  State<CascaNavegacao> createState() => _CascaNavegacaoState();
}

class _CascaNavegacaoState extends State<CascaNavegacao> {
  int _indice = 0;

  void _trocarAba(int novoIndice) {
    setState(() {
      _indice = novoIndice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final abas = [
      const _AbaProvisoria(titulo: 'Início'),
      const _AbaProvisoria(titulo: 'Alertas'),
      const _AbaProvisoria(titulo: 'Abrigos'),
      const _AbaProvisoria(titulo: 'Perfil'),
    ];

    return Scaffold(
      body: abas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: _trocarAba,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.night_shelter_outlined),
            activeIcon: Icon(Icons.night_shelter),
            label: 'Abrigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _AbaProvisoria extends StatelessWidget {
  final String titulo;

  const _AbaProvisoria({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo), automaticallyImplyLeading: false),
      body: Center(child: Text('Tela $titulo em construção')),
    );
  }
}
