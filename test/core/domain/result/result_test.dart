import 'package:eventix/core/domain/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result - Estado', () {
    test('Success es identificado como éxito y no como error', () {
      final Result<int, String> result = Success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
    });

    test('Error es identificado como error y no como éxito', () {
      final Result<int, String> result = Error('Ocurrió un fallo');

      expect(result.isError, isTrue);
      expect(result.isSuccess, isFalse);
    });
  });

  group('Success - Gestión de Valor', () {
    test('Almacena y expone el valor correctamente', () {
      const value = 42;
      final success = Success<int, String>(value);

      expect(success.value, equals(value));
    });
  });

  group('Error - Gestión de Error', () {
    test('Almacena y expone el error correctamente', () {
      const errorMessage = 'Ocurrió un fallo';
      final error = Error<int, String>(errorMessage);

      expect(error.error, equals(errorMessage));
    });
  });

  group('Result - Control de Flujo', () {
    test('when ejecuta el callback "success" y retorna su resultado ante un Success', () {
      final Result<int, String> result = Success(100);

      final stringResult = result.when(
        success: (value) => 'El valor es $value',
        error: (error) => 'Falló con: $error',
      );

      expect(stringResult, equals('El valor es 100'));
    });

    test('when ejecuta el callback "error" y retorna su resultado ante un Error', () {
      final Result<int, String> result = Error('Timeout');

      final stringResult = result.when(
        success: (value) => 'El valor es $value',
        error: (error) => 'Falló con: $error',
      );

      expect(stringResult, equals('Falló con: Timeout'));
    });

    test('when soporta diferentes tipos de retorno mediante genéricos', () {
      final Result<String, Exception> result = Success('Datos cargados');

      final bool isDataValid = result.when<bool>(
        success: (value) => value.isNotEmpty,
        error: (error) => false,
      );

      expect(isDataValid, isTrue);
    });
  });
}
