import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_failure.dart';

part 'core_failures.freezed.dart';

/// Failures transversales a toda la aplicación.
///
/// Cada [CoreFailure] se corresponde con una [CoreException] del mismo dominio.
/// El mapeo de excepción → failure ocurre en el datasource o repositorio,
/// nunca en la capa de dominio o presentación.
///
/// Los failures específicos de un feature deben extender [AppFailure]
/// directamente y vivir dentro de su propia carpeta `domain/failures/`.
@freezed
sealed class CoreFailure with _$CoreFailure implements AppFailure {
  // ─── Conectividad ────────────────────────────────────────────────────────────

  /// El dispositivo no tiene conexión a internet.
  const factory CoreFailure.network() = NetworkFailure;

  /// Una operación superó su tiempo límite permitido.
  const factory CoreFailure.timeout() = TimeoutFailure;

  // ─── Remoto ──────────────────────────────────────────────────────────────────

  /// El servidor retornó un error inesperado.
  ///
  /// [message] puede contener un detalle técnico para mostrar en entornos
  /// de desarrollo o registrar en herramientas de monitoreo (por ejemplo Crashlytics).
  const factory CoreFailure.server({String? message}) = ServerFailure;

  // ─── Rate limiting ───────────────────────────────────────────────────────────

  /// Un servicio remoto rechazó la solicitud por exceso de peticiones.
  ///
  /// La UI debe informar al usuario que espere antes de reintentar.
  /// No reintentar automáticamente sin un backoff adecuado.
  const factory CoreFailure.rateLimit() = RateLimitFailure;

  // ─── Red de seguridad ────────────────────────────────────────────────────────

  /// Error de último recurso para cualquier fallo que no coincida con un tipo conocido.
  ///
  /// Su presencia en producción suele indicar un mapeo faltante en el repositorio.
  /// Siempre registrar el contexto completo cuando se origine este failure.
  const factory CoreFailure.unknown({
    String? message,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}
