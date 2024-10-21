class Validators {
  static String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    return null;
  }

  static String? validarTelefone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o telefone';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }
}
