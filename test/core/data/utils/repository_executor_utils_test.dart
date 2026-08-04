import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/data/mappers/core_exception_mapper.dart';
import 'package:eventix/core/data/utils/repository_executor_utils.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

// Clase auxiliar

// Los mixins no pueden instanciarse directamente, por lo que se necesita
// una clase concreta auxiliar únicamente para los tests.
// No representa ninguna abstracción de producción.
class _TestRepository with RepositoryExecutor {}

// Fake de CoreExceptionMapper

// Fake manual en lugar de un mock generado, ya que la lógica es simple
// y no requiere verificación de llamadas.
class _FakeCoreMapper implements CoreExceptionMapper {
  final AppFailure failureToReturn;

  const _FakeCoreMapper(this.failureToReturn);

  @override
  AppFailure map(CoreException exception) => failureToReturn;
}

void main() {
  late _TestRepository repository;
  late _FakeCoreMapper defaultMapper;

  final fallbackFailure = UnknownFailure(
    message: 'default failure',
    stackTrace: StackTrace.empty,
  );

  setUp(() {
    repository = _TestRepository();

    defaultMapper = _FakeCoreMapper(fallbackFailure);
  });

  group('RepositoryExecutor - Ejecución Exitosa', () {
    test(
      'La ejecución exitosa retorna el valor de la acción envuelto en Success',
      () async {
        final result = await repository.execute(
          () async => 42,
          coreMapper: defaultMapper,
        );

        expect(result, isA<Success<int, AppFailure>>());
        expect((result as Success).value, 42);
      },
    );

    test(
      'La acción que retorna null se envuelve correctamente en Success',
      () async {
        final result = await repository.execute<int?>(
          () async => null,
          coreMapper: defaultMapper,
        );

        expect(result, isA<Success<int?, AppFailure>>());
        expect((result as Success).value, isNull);
      },
    );
  });

  group('RepositoryExecutor - CoreException', () {
    test(
      'CoreException delega su mapeo al coreMapper proporcionado',
      () async {
        final expectedFailure = UnknownFailure(
          message: 'mapped',
          stackTrace: StackTrace.empty,
        );
        final mapper = _FakeCoreMapper(expectedFailure);

        final result = await repository.execute<void>(
          () async => throw const UnknownException(),
          coreMapper: mapper,
        );

        expect(result, isA<Error<void, AppFailure>>());
        expect((result as Error).error, expectedFailure);
      },
    );
  });

  group('RepositoryExecutor - Callback mapException', () {
    test(
      'mapException tiene prioridad sobre otros mapeadores si retorna un fallo',
      () async {
        final expectedMappedFailure = UnknownFailure(
          message: 'custom map',
          stackTrace: StackTrace.empty,
        );

        final result = await repository.execute<void>(
          () async => throw Exception('raw error'),
          coreMapper: defaultMapper,
          mapException: (_) => expectedMappedFailure,
        );

        expect(result, isA<Error<void, AppFailure>>());
        expect((result as Error).error, expectedMappedFailure);
      },
    );

    test(
      'El flujo continúa hacia el fallback si mapException retorna null',
      () async {
        final result = await repository.execute<void>(
          () async => throw Exception('unmapped error'),
          coreMapper: defaultMapper,
          mapException: (_) => null,
        );

        expect(result, isA<Error<void, AppFailure>>());
        expect((result as Error).error, isA<UnknownFailure>());
      },
    );
  });

  group('RepositoryExecutor - Fallback de Errores Desconocidos', () {
    test(
      'Excepciones genéricas se transforman en UnknownFailure con metadatos originales',
      () async {
        final exception = Exception('completely unexpected');

        final result = await repository.execute<void>(
          () async => throw exception,
          coreMapper: defaultMapper,
        );

        expect(result, isA<Error<void, AppFailure>>());

        final failure = (result as Error).error as UnknownFailure;
        expect(failure.message, exception.toString());
        expect(failure.stackTrace, isNotNull);
      },
    );

    test(
      'Objetos de tipo Error se capturan como UnknownFailure',
      () async {
        final stateError = StateError('bad state');

        final result = await repository.execute<void>(
          () async => throw stateError,
          coreMapper: defaultMapper,
        );

        expect(result, isA<Error<void, AppFailure>>());

        final failure = (result as Error).error as UnknownFailure;
        expect(failure.message, stateError.toString());
        expect(failure.stackTrace, isNotNull);
      },
    );
  });
}
