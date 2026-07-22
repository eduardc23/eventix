import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/core_di_providers.dart';
import '../data/datasource/auth_datasource.dart';
import '../data/datasource/auth_datasource_impl.dart';
import '../data/mappers/auth_exception_mapper.dart';
import '../data/mappers/firebase_auth_exception_mapper.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/auth_use_cases.dart';

part 'auth_di_providers.g.dart';

@riverpod
AuthExceptionMapper authExceptionMapper(Ref ref) {
  return AuthExceptionMapperImpl();
}

@riverpod
FirebaseAuthExceptionMapper firebaseAuthExceptionMapper(Ref ref) {
  return FirebaseAuthExceptionMapperImpl();
}

@riverpod
AuthDataSource authDataSource(Ref ref) {
  return AuthDatasourceImpl(
    auth: ref.watch(firebaseAuthProvider),
    authMapper: ref.watch(firebaseAuthExceptionMapperProvider),
    firebaseMapper: ref.watch(firebaseExceptionMapperProvider),
  );
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    dataSource: ref.watch(authDataSourceProvider),
    authMapper: ref.watch(authExceptionMapperProvider),
    coreMapper: ref.watch(coreExceptionMapperProvider),
  );
}

@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}
