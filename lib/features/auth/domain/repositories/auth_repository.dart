import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
/// Contrato del repositorio de autenticación.
abstract interface class AuthRepository {
  /// Inicia sesión con [email] y [password].
  Future<Result<void, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registra una cuenta nueva con [email] y [password].
  Future<Result<void, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Cierra la sesión del usuario actual.
  Future<Result<void, AppFailure>> signOut();
}
