/// Extensions úteis para String.
extension StringExtensions on String {
  /// Capitaliza a primeira letra da string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitaliza a primeira letra de cada palavra.
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Remove espaços extras e quebras de linha.
  String get clean {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Verifica se é um email válido.
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Verifica se contém apenas números.
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Converte para int com valor padrão.
  int toIntOrDefault([int defaultValue = 0]) {
    return int.tryParse(this) ?? defaultValue;
  }

  /// Converte para double com valor padrão.
  double toDoubleOrDefault([double defaultValue = 0.0]) {
    return double.tryParse(this) ?? defaultValue;
  }

  /// Trunca a string com ellipsis.
  String truncate(int maxLength, [String ellipsis = '...']) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}

/// Extensions úteis para int.
extension IntExtensions on int {
  /// Formata como moeda brasileira.
  String get toBRL {
    return 'R\$ ${toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formata como porcentagem.
  String get toPercent {
    return '$this%';
  }
}

/// Extensions úteis para double.
extension DoubleExtensions on double {
  /// Formata como moeda brasileira.
  String get toBRL {
    return 'R\$ ${toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formata como porcentagem.
  String get toPercent {
    return '${toStringAsFixed(1)}%';
  }

  /// Arredonda para uma quantidade específica de casas decimais.
  double roundToDecimals(int decimals) {
    num factor = 1;
    for (int i = 0; i < decimals; i++) {
      factor *= 10;
    }
    return (this * factor).round() / factor;
  }
}
