import 'app_failure.dart';

/// Failures transversales a toda la aplicación.
///
/// Cada [CoreFailure] se corresponde con una [CoreException] del mismo dominio.
/// El mapeo de excepción → failure ocurre en el datasource o repositorio,
/// nunca en la capa de dominio o presentación.
///
/// Los failures específicos de un feature deben extender [AppFailure]
/// directamente y vivir dentro de su propia carpeta `domain/failures/`.
sealed class CoreFailure extends AppFailure {
  const CoreFailure();
}

// ─── Conectividad ────────────────────────────────────────────────────────────

/// El dispositivo no tiene conexión a internet.
class NetworkFailure extends CoreFailure {
  const NetworkFailure();

  @override
  List<Object?> get props => [];
}

/// Una operación superó su tiempo límite permitido.
class TimeoutFailure extends CoreFailure {
  const TimeoutFailure();

  @override
  List<Object?> get props => [];
}

// ─── Remoto ──────────────────────────────────────────────────────────────────

/// El servidor retornó un error inesperado.
///
/// [message] puede contener un detalle técnico para mostrar en entornos
/// de desarrollo o registrar en herramientas de monitoreo (por ejemplo Crashlytics).
class ServerFailure extends CoreFailure {
  final String? message;

  const ServerFailure({this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Rate limiting ───────────────────────────────────────────────────────────

/// Un servicio remoto rechazó la solicitud por exceso de peticiones.
///
/// La UI debe informar al usuario que espere antes de reintentar.
/// No reintentar automáticamente sin un backoff adecuado.
class RateLimitFailure extends CoreFailure {
  const RateLimitFailure();

  @override
  List<Object?> get props => [];
}

// ─── Red de seguridad ────────────────────────────────────────────────────────

/// Error de último recurso para cualquier fallo que no coincida con un tipo conocido.
///
/// Su presencia en producción suele indicar un mapeo faltante en el repositorio.
/// Siempre registrar el contexto completo cuando se origine este failure.
class UnknownFailure extends CoreFailure {
  final String? message;
  final StackTrace? stackTrace;

  const UnknownFailure({this.message, this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}
