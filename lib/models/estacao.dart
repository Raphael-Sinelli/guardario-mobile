// Estação de medição do rio. As cotas são os níveis em centímetros
// em que o risco muda.
class Estacao {
  final String nome;
  final String rio;
  final String area;
  final String cidade;
  final int cotaAtencao;
  final int cotaAlerta;
  final int cotaTransbordo;

  const Estacao({
    required this.nome,
    required this.rio,
    required this.area,
    required this.cidade,
    required this.cotaAtencao,
    required this.cotaAlerta,
    required this.cotaTransbordo,
  });
}
