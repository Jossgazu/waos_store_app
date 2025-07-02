// lib/utils/validations.dart

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  }
  if (!value.contains('@')) {
    return 'Correo inválido';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 6) {
    return 'Mínimo 6 caracteres';
  }
  return null;
}