/// Modelo de datos que agrupa los valores del formulario de registro.
class RegisterFormData {
  const RegisterFormData({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;
}
