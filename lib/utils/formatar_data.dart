// Datas formatadas à mão, sem pacote de formatação.

String _doisDigitos(int numero) {
  return numero.toString().padLeft(2, '0');
}

// Exemplo: 27/10/2026
String formatarData(DateTime data) {
  return '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year}';
}

// Exemplo: 27/10/2026 às 18:05
String formatarDataHora(DateTime data) {
  return '${formatarData(data)} às '
      '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
}
