import 'dart:async';
import 'dart:io';

import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/data/mappers/firebase_exception_mapper.dart';
import 'package:eventix/core/data/utils/datasource_executor_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

// Clase auxiliar

// Los mixins no pueden instanciarse directamente, por lo que se necesita
// una clase concreta auxiliar únicamente para los tests.
// No representa ninguna abstracción de producción.
class _TestDatasource with DatasourceExecutor {}

// Fake de FirebaseExceptionMapper

// Fake manual en lugar de un mock generado, ya que la lógica es simple
// y no requiere verificación de llamadas.
class _FakeFirebaseMapper implements FirebaseExceptionMapper {
  final CoreException exceptionToReturn;

  const _FakeFirebaseMapper(this.exceptionToReturn);

  @override
  CoreException mapFirebase(FirebaseException exception) => exceptionToReturn;
}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late _TestDatasource datasource;

  setUp(() {
    datasource = _TestDatasource();
  });

  group('DatasourceExecutor - Ejecución Exitosa', () {
    test(
      'Retorna el valor de la acción cuando no se lanza ninguna excepción',
      () async {
        final result = await datasource.execute(() async => 42);

        expect(result, 42);
      },
    );

    test('Retorna null cuando la acción completa con null', () async {
      final result = await datasource.execute<int?>(() async => null);

      expect(result, isNull);
    });
  });

  group('DatasourceExecutor - Callback mapException', () {
    test(
      'Lanza la excepción mapeada cuando mapException retorna un valor no nulo',
      () {
        final future = datasource.execute<void>(
          () async => throw Exception('raw error'),
          mapException: (_) => const NetworkException(),
        );

        expect(future, throwsA(isA<NetworkException>()));
      },
    );

    test('Continúa al siguiente manejador cuando mapException retorna null', () {
      // mapException retorna null → el flujo continúa y cae en SocketException
      final future = datasource.execute<void>(
        () async => throw const SocketException('no connection'),
        mapException: (_) => null,
      );

      // Debe llegar al bloque de SocketException y lanzar NetworkException
      expect(future, throwsA(isA<NetworkException>()));
    });
  });

  group('DatasourceExecutor - FirebaseException', () {
    test('Delega en firebaseMapper cuando se proporciona', () {
      final mapper = _FakeFirebaseMapper(const RateLimitException());

      final future = datasource.execute<void>(
        () async =>
            throw FirebaseException(plugin: 'auth', code: 'too-many-requests'),
        firebaseMapper: mapper,
      );

      expect(future, throwsA(isA<RateLimitException>()));
    });

    test('Lanza UnknownException cuando no se proporciona firebaseMapper', () {
      final future = datasource.execute<void>(
        () async =>
            throw FirebaseException(plugin: 'firestore', code: 'unavailable'),
      );

      expect(future, throwsA(isA<UnknownException>()));
    });
  });

  group('DatasourceExecutor - Excepciones de Infraestructura', () {
    test('Lanza NetworkException ante un SocketException', () {
      final future = datasource.execute<void>(
        () async => throw const SocketException('no internet'),
      );

      expect(future, throwsA(isA<NetworkException>()));
    });

    test('Lanza RequestTimeoutException ante un TimeoutException', () {
      final future = datasource.execute<void>(
        () async => throw TimeoutException('timed out'),
      );

      expect(future, throwsA(isA<RequestTimeoutException>()));
    });
  });

  group('DatasourceExecutor - Relanzamiento de AppException', () {
    test('Relanza AppException tal cual sin envolverla', () {
      const originalException = ServerException(message: 'internal');

      final future = datasource.execute<void>(
        () async => throw originalException,
      );

      // Verifica que la excepción no es envuelta en UnknownException
      expect(
        future,
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'internal',
          ),
        ),
      );
    });

    test(
      'Relanza cualquier subtipo de AppException preservando su identidad',
      () {
        final future = datasource.execute<void>(
          () async => throw const RateLimitException(),
        );

        expect(future, throwsA(isA<RateLimitException>()));
      },
    );
  });

  group('DatasourceExecutor - Fallback de Errores Desconocidos', () {
    test('Lanza UnknownException ante cualquier error no reconocido', () {
      final future = datasource.execute<void>(
        () async => throw Exception('completely unexpected'),
      );

      expect(future, throwsA(isA<UnknownException>()));
    });

    test('Lanza UnknownException ante errores que no son excepciones', () {
      final future = datasource.execute<void>(
        () async => throw StateError('bad state'),
      );

      expect(future, throwsA(isA<UnknownException>()));
    });
  });

  group('DatasourceExecutor - Preservación de Stack Trace', () {
    // Capturamos el stack trace en el punto exacto donde ocurre el error
    // para compararlo con el que llega a la excepción de dominio.
    // Si Error.throwWithStackTrace no estuviera, el stack trace apuntaría
    // al interior del mixin en lugar de aquí.
    test(
      'Preserva el stack trace original al mapear SocketException',
      () async {
        late StackTrace originalStackTrace;

        final future = datasource.execute<void>(() async {
          try {
            throw const SocketException('no internet');
          } catch (_, st) {
            originalStackTrace = st;
            rethrow;
          }
        });

        try {
          await future;
          fail('Se esperaba NetworkException');
        } on NetworkException catch (_, st) {
          expect(st.toString(), equals(originalStackTrace.toString()));
        }
      },
    );

    test(
      'Preserva el stack trace original al mapear TimeoutException',
      () async {
        late StackTrace originalStackTrace;

        final future = datasource.execute<void>(() async {
          try {
            throw TimeoutException('timed out');
          } catch (_, st) {
            originalStackTrace = st;
            rethrow;
          }
        });

        try {
          await future;
          fail('Se esperaba RequestTimeoutException');
        } on RequestTimeoutException catch (_, st) {
          expect(st.toString(), equals(originalStackTrace.toString()));
        }
      },
    );

    test(
      'Preserva el stack trace original cuando mapException intercepta el error',
      () async {
        late StackTrace originalStackTrace;

        final future = datasource.execute<void>(() async {
          try {
            throw Exception('raw error');
          } catch (_, st) {
            originalStackTrace = st;
            rethrow;
          }
        }, mapException: (_) => const NetworkException());

        try {
          await future;
          fail('Se esperaba NetworkException');
        } on NetworkException catch (_, st) {
          expect(st.toString(), equals(originalStackTrace.toString()));
        }
      },
    );

    test(
      'Preserva el stack trace original al relanzar AppException sin transformación',
      () async {
        late StackTrace originalStackTrace;

        final future = datasource.execute<void>(() async {
          try {
            throw const ServerException(message: 'internal');
          } catch (_, st) {
            originalStackTrace = st;
            rethrow;
          }
        });

        try {
          await future;
          fail('Se esperaba ServerException');
        } on ServerException catch (_, st) {
          expect(st.toString(), equals(originalStackTrace.toString()));
        }
      },
    );
  });
}
