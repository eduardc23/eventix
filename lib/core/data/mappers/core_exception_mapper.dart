import '../../domain/failures/app_failure.dart';
import '../../domain/failures/core_failures.dart';
import '../exceptions/core_exceptions.dart';

/// Contrato para convertir una [CoreException] en su [AppFailure] correspondiente.
///
/// Vive en Core porque es transversal: cualquier repositorio que capture
/// [CoreException] puede inyectarlo y reutilizarlo sin duplicar lógica.
abstract interface class CoreExceptionMapper {
  /// Convierte [exception] en el [AppFailure] correspondiente.
  AppFailure map(CoreException exception);
}

/// Implementación por defecto de [CoreExceptionMapper].
class CoreExceptionMapperImpl implements CoreExceptionMapper {
  const CoreExceptionMapperImpl();

  @override
  AppFailure map(CoreException exception) => switch (exception) {
    NetworkException() => const NetworkFailure(),
    RequestTimeoutException() => const TimeoutFailure(),
    RateLimitException() => const RateLimitFailure(),
    ServerException(:final message) => ServerFailure(message: message),
    UnknownException() => const UnknownFailure(),
  };
}
