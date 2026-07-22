import '../failures/app_failure.dart';
import '../result/result.dart';

/// Caso de uso asíncrono con parámetros.
///
/// Clase base para operaciones de negocio que requieren parámetros
/// y retornan un resultado de forma asíncrona.
///
/// [R] es el tipo del valor en caso de éxito.
/// [P] es el tipo de los parámetros de entrada.
abstract class UseCase<R, P> {
  const UseCase();

  /// Ejecuta el caso de uso con los [params] dados.
  ///
  /// Retorna un [Result] con el valor de tipo [R] si tuvo éxito,
  /// o un [AppFailure] si ocurrió un error.
  Future<Result<R, AppFailure>> call(P params);
}

/// Caso de uso síncrono con parámetros.
///
/// Clase base para operaciones de negocio que requieren parámetros
/// y retornan un resultado de forma inmediata, sin necesidad de `await`.
///
/// [R] es el tipo del valor en caso de éxito.
/// [P] es el tipo de los parámetros de entrada.
abstract class SyncUseCase<R, P> {
  const SyncUseCase();

  /// Ejecuta el caso de uso de forma síncrona con los [params] dados.
  ///
  /// Retorna un [Result] con el valor de tipo [R] si tuvo éxito,
  /// o un [AppFailure] si ocurrió un error.
  Result<R, AppFailure> call(P params);
}

/// Caso de uso asíncrono sin parámetros.
///
/// Clase base para operaciones de negocio que no requieren datos de entrada
/// y retornan un resultado de forma asíncrona.
///
/// [R] es el tipo del valor en caso de éxito.
abstract class NoParamsUseCase<R> {
  const NoParamsUseCase();

  /// Ejecuta el caso de uso sin parámetros.
  ///
  /// Retorna un [Result] con el valor de tipo [R] si tuvo éxito,
  /// o un [AppFailure] si ocurrió un error.
  Future<Result<R, AppFailure>> call();
}
