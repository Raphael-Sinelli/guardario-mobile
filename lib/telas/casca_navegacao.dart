import 'package:flutter/material.dart';

import 'tela_abrigos.dart';
import 'tela_alertas.dart';
import 'tela_inicio.dart';
import 'tela_perfil.dart';

// Casca do app: guarda qual aba está aberta e mostra a BottomNavigationBar.
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
    // Uma tela para cada item da barra, na mesma ordem
    final abas = [
      TelaInicio(irParaAba: _trocarAba),
      const TelaAlertas(),
      const TelaAbrigos(),
      const TelaPerfil(),
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
