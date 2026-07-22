import '../../../../core/data/exceptions/app_exception.dart';

/// Excepciones específicas del feature de autenticación.
///
/// Cada subclase se corresponde con un código de error de Firebase Auth.
/// El mapeo desde el [FirebaseAuthException] crudo hacia estas excepciones
/// ocurre en el datasource (`AuthRemoteDataSource`), nunca en capas superiores.
///
/// Para errores de red, timeout o servidor, se usan las excepciones de Core
/// ([NetworkException], [TimeoutAppException], [ServerException]).
sealed class AuthException extends AppException {
  const AuthException({super.message});
}

// ─── Login ───────────────────────────────────────────────────────────────────

/// La contraseña proporcionada es incorrecta para el email dado.
///
/// Código Firebase: `wrong-password`.
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException();
}

// ─── Registro ────────────────────────────────────────────────────────────────

/// Ya existe una cuenta registrada con el email proporcionado.
///
/// Código Firebase: `email-already-in-use`.
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException();
}

// ─── Estado Inesperado ──────────────────────────────────────────────────────

/// Firebase completó la operación pero no retornó un usuario válido.
/// Indica una inconsistencia inesperada de la SDK.
class UnexpectedAuthStateException extends AuthException {
  const UnexpectedAuthStateException();
}
