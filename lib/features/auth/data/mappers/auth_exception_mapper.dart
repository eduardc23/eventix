import '../../../../core/domain/failures/app_failure.dart';
import '../../domain/failures/auth_failure.dart';
import '../exceptions/auth_exception.dart';

/// Contrato para convertir una [AuthException] en su [AppFailure] correspondiente.
///
/// La interfaz recibe [AuthException] (sealed) y retorna [AppFailure],
/// lo que permite al compilador verificar exhaustividad en la implementación.
abstract interface class AuthExceptionMapper {
  /// Convierte [exception] en el [AppFailure] correspondiente.
  AppFailure map(AuthException exception);
}

/// Implementación por defecto de [AuthExceptionMapper].
class AuthExceptionMapperImpl implements AuthExceptionMapper {
  const AuthExceptionMapperImpl();

  @override
  AppFailure map(AuthException exception) => switch (exception) {
    InvalidCredentialsException() => const InvalidCredentialsFailure(),
    EmailAlreadyInUseException() => const EmailAlreadyInUseFailure(),
    UnexpectedAuthStateException() => const UnexpectedAuthFailure(),
  };
}
