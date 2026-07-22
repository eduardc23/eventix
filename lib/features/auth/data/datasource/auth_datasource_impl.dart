import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/mappers/firebase_exception_mapper.dart';
import '../../../../core/data/utils/datasource_executor.dart';
import '../exceptions/auth_exception.dart';
import '../mappers/firebase_auth_exception_mapper.dart';
import 'auth_datasource.dart';

/// Implementación de [AuthDataSource] sobre Firebase Authentication.
///
/// Toda llamada a Firebase pasa por [execute], que centraliza el manejo
/// de errores y delega el mapeo a los correspondientes mappers inyectados.
/// Esto mantiene el datasource libre de lógica de mapeo y facilita el testing
/// independiente de cada responsabilidad.
class AuthDatasourceImpl with DatasourceExecutor implements AuthDataSource {
  const AuthDatasourceImpl({
    required this._auth,
    required this._authMapper,
    required this._firebaseMapper,
  });

  final FirebaseAuth _auth;
  final FirebaseAuthExceptionMapper _authMapper;
  final FirebaseExceptionMapper _firebaseMapper;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => execute(
    () async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const UnexpectedAuthStateException();
      }
    },
    firebaseMapper: _firebaseMapper,
    mapException: (e) => e is FirebaseAuthException ? _authMapper.map(e) : null,
  );

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) => execute(
    () async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const UnexpectedAuthStateException();
      }

      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw const UnexpectedAuthStateException();
      }
    },
    firebaseMapper: _firebaseMapper,
    mapException: (e) => e is FirebaseAuthException ? _authMapper.map(e) : null,
  );

  @override
  Future<void> signOut() {
    return execute(() => _auth.signOut(), firebaseMapper: _firebaseMapper);
  }
}
