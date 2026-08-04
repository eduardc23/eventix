import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/data/mappers/core_exception_mapper.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CoreExceptionMapper mapper;

  setUp(() {
    mapper = const CoreExceptionMapperImpl();
  });

  group('CoreExceptionMapperImpl - Mapeo de Conectividad', () {
    test('NetworkException se transforma en NetworkFailure', () {
      final result = mapper.map(const NetworkException());

      expect(result, isA<NetworkFailure>());
    });

    test('RequestTimeoutException se transforma en TimeoutFailure', () {
      final result = mapper.map(const RequestTimeoutException());

      expect(result, isA<TimeoutFailure>());
    });
  });

  group('CoreExceptionMapperImpl - Mapeo Remoto', () {
    test('ServerException se transforma en ServerFailure', () {
      final result = mapper.map(const ServerException());

      expect(result, isA<ServerFailure>());
    });

    test('ServerException preserva el mensaje original para el fallo', () {
      const mensajeError = 'unavailable';
      final result = mapper.map(const ServerException(message: mensajeError));

      expect((result as ServerFailure).message, mensajeError);
    });

    test('ServerException genera un mensaje nulo si no se proporciona', () {
      final result = mapper.map(const ServerException());

      expect((result as ServerFailure).message, isNull);
    });

    test('RateLimitException se transforma en RateLimitFailure', () {
      final result = mapper.map(const RateLimitException());

      expect(result, isA<RateLimitFailure>());
    });
  });

  group('CoreExceptionMapperImpl - Seguridad', () {
    test('UnknownException se transforma en UnknownFailure', () {
      final result = mapper.map(const UnknownException());

      expect(result, isA<UnknownFailure>());
    });
  });
}
