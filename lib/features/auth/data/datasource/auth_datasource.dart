/// Contrato de la fuente de datos de autenticación.
///
/// Define las operaciones disponibles sin acoplarse a ningún proveedor
/// concreto (Firebase, Supabase, mock, etc.).
/// La implementación concreta se inyecta en el repositorio.
abstract interface class AuthDataSource {
  /// Inicia sesión con [email] y [password].
  ///
  /// Lanza [AuthException] o [NetworkException] ante cualquier error.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registra una cuenta nueva con [email] y [password].
  ///
  /// Lanza [AuthException] o [NetworkException] ante cualquier error.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Cierra la sesión del usuario actual.
  Future<void> signOut();
}
