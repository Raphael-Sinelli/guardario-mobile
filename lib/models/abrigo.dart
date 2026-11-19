// Abrigo da região. `favorito` muda quando a pessoa toca na estrela.
class Abrigo {
  final String nome;
  final String endereco;
  final String telefone;
  final int capacidade;
  final int ocupacao;
  final bool aceitaPets;
  final bool acessivelPcd;
  bool favorito;

  Abrigo({
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.capacidade,
    required this.ocupacao,
    required this.aceitaPets,
    required this.acessivelPcd,
    this.favorito = false,
  });

  // Lotado quando a ocupação chega na capacidade
  bool get lotado => ocupacao >= capacidade;

  int get vagas => capacidade - ocupacao;
}
