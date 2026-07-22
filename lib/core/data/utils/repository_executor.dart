import '../../../core/domain/failures/app_failure.dart';
import '../../../core/domain/failures/core_failures.dart';
import '../../../core/domain/result/result.dart';
import '../exceptions/core_exceptions.dart';
import '../mappers/core_exception_mapper.dart';

/// Mixin para centralizar la ejecución de llamadas a fuentes de datos
/// en los repositorios, manejando excepciones comunes y convirtiéndolas
/// en [AppFailure].
mixin RepositoryExecutor {
  /// Ejecuta una acción asíncrona y captura excepciones de dominio.
  ///
  /// [coreMapper] se encarga de las excepciones transversales.
  /// [mapException] permite al repositorio manejar excepciones específicas.
  Future<Result<T, AppFailure>> execute<T>(
      Future<T> Function() action, {
        required CoreExceptionMapper coreMapper,
        AppFailure? Function(Object)? mapException,
      }) async {
    try {
      return Success(await action());
    } on CoreException catch (e, _) {
      return Error(coreMapper.map(e));
    } catch (e, st) {
      if (mapException != null) {
        final failure = mapException(e);
        if (failure != null) return Error(failure);
      }

      return Error(UnknownFailure(
        message: e.toString(),
        stackTrace: st,
      ));
    }
  }
}
