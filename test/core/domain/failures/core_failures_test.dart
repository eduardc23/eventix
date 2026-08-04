import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerFailure - Mensaje', () {
    test('ServerFailure preserva el mensaje proporcionado', () {
      const message = 'error_interno_500';
      const failure = ServerFailure(message: message);

      expect(failure.message, message);
    });

    test('ServerFailure tiene mensaje nulo por defecto', () {
      const failure = ServerFailure();

      expect(failure.message, isNull);
    });
  });

  group('UnknownFailure - Metadatos', () {
    test('UnknownFailure preserva el mensaje y el stack trace', () {
      const message = 'error_desconocido';
      final st = StackTrace.current;
      final failure = UnknownFailure(message: message, stackTrace: st);

      expect(failure.message, message);
      expect(failure.stackTrace, st);
    });

    test('UnknownFailure tiene metadatos nulos por defecto', () {
      const failure = UnknownFailure();

      expect(failure.message, isNull);
      expect(failure.stackTrace, isNull);
    });
  });
}
