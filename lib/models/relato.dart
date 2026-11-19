// Tipos de relato, com os mesmos nomes da API (PESSOA_ILHADA, DESLIZAMENTO...).
enum TipoRelato {
  pessoaIlhada,
  deslizamento,
  rioSubindo,
  alagamentoVia,
  bueiroEntupido,
  outro,
}

// Todo relato começa ABERTO. Os outros status são os da API, para a
// integração futura.
enum StatusRelato { aberto, emAtendimento, resolvido, descartado }

class Relato {
  final TipoRelato tipo;
  final String bairro;
  final String descricao;
  final bool pessoasEmRisco;
  final int prioridade; // de 1 a 5
  final StatusRelato status;
  final DateTime criadoEm;

  const Relato({
    required this.tipo,
    required this.bairro,
    required this.descricao,
    required this.pessoasEmRisco,
    required this.prioridade,
    required this.status,
    required this.criadoEm,
  });
}

String nomeDoTipo(TipoRelato tipo) {
  switch (tipo) {
    case TipoRelato.pessoaIlhada:
      return 'Pessoa ilhada';
    case TipoRelato.deslizamento:
      return 'Deslizamento';
    case TipoRelato.rioSubindo:
      return 'Rio subindo';
    case TipoRelato.alagamentoVia:
      return 'Alagamento na via';
    case TipoRelato.bueiroEntupido:
      return 'Bueiro entupido';
    case TipoRelato.outro:
      return 'Outro';
  }
}

String nomeDoStatus(StatusRelato status) {
  switch (status) {
    case StatusRelato.aberto:
      return 'ABERTO';
    case StatusRelato.emAtendimento:
      return 'EM ATENDIMENTO';
    case StatusRelato.resolvido:
      return 'RESOLVIDO';
    case StatusRelato.descartado:
      return 'DESCARTADO';
  }
}
