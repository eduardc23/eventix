import 'app_exception.dart';

/// Excepciones transversales a toda la aplicación.
///
/// Pueden ocurrir en cualquier feature sin importar el contexto de dominio.
/// Las excepciones específicas de un feature deben extender [AppException]
/// directamente y vivir dentro de su propia carpeta `data/exceptions/`.
sealed class CoreException extends AppException {
  const CoreException({super.message});
}

// ─── Conectividad ────────────────────────────────────────────────────────────

/// Se lanza cuando el dispositivo no tiene conexión a internet.
class NetworkException extends CoreException {
  const NetworkException();
}

/// Se lanza cuando una operación supera su tiempo límite permitido.
class RequestTimeoutException extends CoreException {
  const RequestTimeoutException();
}

// ─── Remoto ──────────────────────────────────────────────────────────────────

/// Se lanza cuando el servidor retorna un error inesperado (equivalente a 5xx).
///
/// [message] debe contener el código de error crudo del servidor para logging
/// interno (por ejemplo `"internal"`, `"unavailable"`).
/// Nunca exponer este valor directamente en la UI.
class ServerException extends CoreException {
  const ServerException({super.message});
}

// ─── Rate limiting ───────────────────────────────────────────────────────────

/// Se lanza cuando un servicio remoto rechaza solicitudes por exceso de peticiones.
///
/// Fuentes típicas: Firebase Auth (`too-many-requests`),
/// Firestore o Firebase Storage bajo cuota de lectura/escritura.
/// La UI debe informar al usuario que espere antes de reintentar
class RateLimitException extends CoreException {
  const RateLimitException();
}

// ─── Red de seguridad ────────────────────────────────────────────────────────

/// Excepción de último recurso para cualquier error que no coincida con un tipo conocido.
///
/// Siempre registrar el stack trace al capturar esta excepción — su presencia
/// suele indicar un mapeo faltante en algún datasource.
class UnknownException extends CoreException {
  const UnknownException({super.message});
}
