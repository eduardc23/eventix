import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/core/presentation/extensions/core_failure_message_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoreFailureMessageX - Resolución de Mensajes', () {
    group('ServerFailure - Mensajes de Servidor', () {
      test('El mensaje personalizado prevalece sobre el valor por defecto', () {
        final failure = const ServerFailure(message: 'Error 502 Bad Gateway');
        expect(failure.errorMessage, equals('Error 502 Bad Gateway'));
      });

      test('Los fallos de servidor sin mensaje específico utilizan el texto predefinido', () {
        final failure = const ServerFailure(message: null);
        expect(failure.errorMessage, equals(AppConstants.serverError));
      });
    });

    group('NetworkFailure - Mensajes de Conectividad', () {
      test('Los fallos de red presentan el mensaje de conectividad global', () {
        const failure = NetworkFailure();
        expect(failure.errorMessage, equals(AppConstants.networkError));
      });
    });

    group('TimeoutFailure - Mensajes de Tiempo de Espera', () {
      test('Los fallos por tiempo agotado presentan el mensaje de timeout global', () {
        const failure = TimeoutFailure();
        expect(failure.errorMessage, equals(AppConstants.timeoutError));
      });
    });

    group('RateLimitFailure - Mensajes de Límite de Peticiones', () {
      test('Los fallos por exceso de peticiones presentan el mensaje de saturación global', () {
        const failure = RateLimitFailure();
        expect(failure.errorMessage, equals(AppConstants.rateLimitError));
      });
    });

    group('UnknownFailure - Mensajes de Error Desconocido', () {
      test('Los fallos no categorizados presentan el mensaje genérico de la aplicación', () {
        const failure = UnknownFailure();
        expect(failure.errorMessage, equals(AppConstants.unknownError));
      });
    });
  });
}
