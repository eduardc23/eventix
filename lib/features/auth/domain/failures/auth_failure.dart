import '../../../../core/domain/failures/app_failure.dart';

/// Failures específicos del feature de autenticación.
///
/// Cada [AuthFailure] se corresponde con una [AuthException] del mismo dominio.
/// El mapeo ocurre en el repositorio (`AuthRepositoryImpl`), nunca en la
/// capa de presentación.
///
/// Para fallos de red, timeout, servidor o rate limiting, el repositorio
/// retorna los failures de Core correspondientes ([NetworkFailure],
/// [TimeoutFailure], [ServerFailure], [RateLimitFailure]).
sealed class AuthFailure extends AppFailure {
  const AuthFailure();
}

// ─── Login ───────────────────────────────────────────────────────────────────

/// La contraseña es incorrecta o el email no está registrado.
///
/// Agrupa intencionalmente ambos casos para no revelar al atacante
/// si un email existe en el sistema (enumeración de usuarios).
/// La UI debe mostrar un mensaje genérico como "Credenciales incorrectas".
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();

  @override
  List<Object?> get props => [];
}


// ─── Registro ────────────────────────────────────────────────────────────────

/// Ya existe una cuenta registrada con el email proporcionado.
///
/// La UI puede sugerir al usuario iniciar sesión o recuperar su contraseña.
///
/// Originado por [EmailAlreadyInUseException].
class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure();

  @override
  List<Object?> get props => [];
}

// ─── Estado Inesperado ──────────────────────────────────────────────────────

/// Firebase completó la operación pero no retornó un usuario válido.
///
/// Originado por [UnexpectedAuthStateException].
class UnexpectedAuthFailure extends AuthFailure {
  const UnexpectedAuthFailure();

  @override
  List<Object?> get props => [];
}


