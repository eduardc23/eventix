import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/exceptions/app_exception.dart';
import '../../../../core/data/exceptions/core_exceptions.dart';
import '../constants/firebase_auth_codes.dart';
import '../exceptions/auth_exception.dart';

/// Contrato para mapear un [FirebaseAuthException] a una [AuthException] de dominio.
///
/// Extraer esta lógica en una interfaz permite:
/// - Testear el datasource mockeando el mapper sin depender de Firebase.
/// - Testear el mapper de forma aislada con casos unitarios simples.
/// - Intercambiar la implementación si el proveedor de auth cambia.
abstract interface class FirebaseAuthExceptionMapper {
  /// Convierte [exception] en la [AppException] correspondiente.
  AppException map(FirebaseAuthException exception);
}

/// Implementación por defecto de [FirebaseAuthExceptionMapper].
///
/// Mapea los códigos de error de Firebase Auth a las excepciones de dominio.
/// Los códigos `wrong-password` y `user-not-found` se agrupan intencionalmente
/// en [InvalidCredentialsException] para evitar la enumeración de usuarios.
class FirebaseAuthExceptionMapperImpl implements FirebaseAuthExceptionMapper {
  const FirebaseAuthExceptionMapperImpl();

  @override
  AppException map(FirebaseAuthException exception) {
    return switch (exception.code) {
      FirebaseAuthCodes.wrongPassword ||
      FirebaseAuthCodes.userNotFound ||
      FirebaseAuthCodes.invalidCredential =>
        const InvalidCredentialsException(),
      FirebaseAuthCodes.emailAlreadyInUse => const EmailAlreadyInUseException(),
      FirebaseAuthCodes.tooManyRequests => const RateLimitException(),
      FirebaseAuthCodes.networkRequestFailed => const NetworkException(),
      _ => UnknownException(message: exception.code),
    };
  }
}
