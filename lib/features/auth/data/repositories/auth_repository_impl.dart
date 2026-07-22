import '../../../../core/data/mappers/core_exception_mapper.dart';
import '../../../../core/data/utils/repository_executor.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_datasource.dart';
import '../exceptions/auth_exception.dart';
import '../mappers/auth_exception_mapper.dart';

/// Implementación de [AuthRepository].
///
/// Actúa como frontera entre la capa de datos y la de dominio:
/// - Delega las llamadas de red en [AuthDataSource].
/// - Convierte modelos en entidades mediante [UserMapper].
/// - Convierte excepciones en failures mediante los mappers inyectados.
///
/// No contiene ningún switch sobre excepciones — esa responsabilidad
/// pertenece exclusivamente a [AuthExceptionMapper] y [CoreExceptionMapper],
/// donde el compilador garantiza exhaustividad gracias a las sealed classes.
class AuthRepositoryImpl with RepositoryExecutor implements AuthRepository {
  const AuthRepositoryImpl({
    required this._dataSource,
    required this._authMapper,
    required this._coreMapper,
  });

  final AuthDataSource _dataSource;
  final AuthExceptionMapper _authMapper;
  final CoreExceptionMapper _coreMapper;

  @override
  Future<Result<void, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await execute(
      () => _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      coreMapper: _coreMapper,
      mapException: (e) => switch (e) {
        UnexpectedAuthStateException() => const UnexpectedAuthFailure(),
        AuthException() => _authMapper.map(e),
        _ => null,
      },
    );
  }

  @override
  Future<Result<void, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return await execute(
      () => _dataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      ),
      coreMapper: _coreMapper,
      mapException: (e) => switch (e) {
        UnexpectedAuthStateException() => const UnexpectedAuthFailure(),
        AuthException() => _authMapper.map(e),
        _ => null,
      },
    );
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    return await execute(
      _dataSource.signOut,
      coreMapper: _coreMapper,
    );
  }
}
