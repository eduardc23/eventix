import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/booking/domain/failures/booking_failures.dart';
import 'package:eventix/features/booking/presentation/constants/booking_strings.dart';
import 'package:eventix/features/booking/presentation/extensions/booking_failure_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_app_config.dart';

void main() {
  group('BookingFailureMessageX - Resolución de Mensajes', () {
    group('BookingFailure - Errores de Reserva', () {
      test('Presenta mensaje de error cuando no hay cupos disponibles', () {
        const failure = BookingFailure.noSpotsAvailable();
        expect(
          failure.toBookingMessage(testAppConfig),
          equals(testAppConfig.alerts.noSpots.message),
        );
      });
    });

    group('CoreFailure - Delegación de Errores', () {
      test('Delega correctamente el mensaje ante un fallo de servidor', () {
        const failure = ServerFailure(message: 'Error de servidor custom');
        expect(
          failure.toBookingMessage(testAppConfig),
          equals('Error de servidor custom'),
        );
      });

      test('Delega correctamente el mensaje ante un fallo de red', () {
        const failure = NetworkFailure();
        expect(
          failure.toBookingMessage(testAppConfig),
          equals(AppConstants.networkError),
        );
      });

      test(
        'Delega correctamente el mensaje ante un fallo de tiempo de espera',
        () {
          const failure = TimeoutFailure();
          expect(
            failure.toBookingMessage(testAppConfig),
            equals(AppConstants.timeoutError),
          );
        },
      );
    });

    group('Fallback - Casos No Manejados', () {
      test(
        'Utiliza el mensaje de error inesperado ante cualquier otro tipo de fallo',
        () {
          final unknownFailure = FakeAppFailure();
          expect(
            unknownFailure.toBookingMessage(testAppConfig),
            equals(BookingStrings.unexpectedBookingError),
          );
        },
      );
    });
  });
}
