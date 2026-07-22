import '../../../../core/validators/validators.dart';
import '../constants/auth_strings.dart';

/// Validaciones específicas del dominio de autenticación.
/// Compone reglas primitivas con mensajes de negocio.
class AuthValidators {
  AuthValidators._();

  static String? email(String? value) => Validators.compose([
    (v) => Validators.required(v, message: AuthStrings.emailRequired),
    (v) => Validators.email(v, message: AuthStrings.invalidEmail),
  ], value);

  static String? username(String? value) => Validators.compose([
    (v) => Validators.required(v, message: AuthStrings.usernameRequired),
    (v) => Validators.minLength(v, 3, message: AuthStrings.usernameMinLength),
  ], value);

  static String? password(String? value) => Validators.compose([
    (v) => Validators.required(v, message: AuthStrings.passwordRequired),
    (v) => Validators.minLength(v, 6, message: AuthStrings.passwordMinLength),
  ], value);

  static String? confirmPassword(String? value, String password) {
    return Validators.compose([
      (v) => Validators.required(v, message: AuthStrings.confirmPasswordRequired),
      (v) => v != password ? AuthStrings.passwordsDoNotMatch : null,
    ], value);
  }
}
