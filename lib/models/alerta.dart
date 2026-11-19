import 'nivel_risco.dart';

// Alerta emitido para uma área. Quando deixa de valer, `ativo` vira false.
class Alerta {
  final int id;
  final NivelRisco nivel;
  final String area;
  final String mensagem;
  final DateTime criadoEm;
  bool ativo;
  DateTime? encerradoEm;

  Alerta({
    required this.id,
    required this.nivel,
    required this.area,
    required this.mensagem,
    required this.criadoEm,
    this.ativo = true,
    this.encerradoEm,
  });
}
