import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('ServerException - Mensaje', () {
    test('ServerException preserva el mensaje para logging interno', () {
      const exception = ServerException(message: 'internal');

      expect(exception.message, 'internal');
    });

    test('ServerException tiene mensaje nulo por defecto', () {
      const exception = ServerException();

      expect(exception.message, isNull);
    });
  });

  group('UnknownException - Mensaje', () {
    test('UnknownException preserva el mensaje cuando se proporciona', () {
      const exception = UnknownException(message: 'codigo_inesperado_42');

      expect(exception.message, 'codigo_inesperado_42');
    });

    test('UnknownException tiene mensaje nulo por defecto', () {
      const exception = UnknownException();

      expect(exception.message, isNull);
    });
  });
}
