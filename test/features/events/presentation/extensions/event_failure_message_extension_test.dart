import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/extensions/event_failure_message_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  group('EventFailureMessageX - Resolución de Mensajes', () {
    group('CoreFailure - Delegación de Errores', () {
      test('Delega correctamente el mensaje ante un fallo de servidor', () {
        const failure = ServerFailure(message: 'Error de servidor custom');
        expect(failure.toEventMessage, equals('Error de servidor custom'));
      });

      test('Delega correctamente el mensaje ante un fallo de red', () {
        const failure = NetworkFailure();
        expect(failure.toEventMessage, equals(AppConstants.networkError));
      });

      test('Delega correctamente el mensaje ante un fallo de tiempo de espera', () {
        const failure = TimeoutFailure();
        expect(failure.toEventMessage, equals(AppConstants.timeoutError));
      });
    });

    group('Fallback - Casos No Manejados', () {
      test('Utiliza el mensaje de error inesperado ante cualquier otro tipo de fallo', () {
        final unknownFailure = FakeAppFailure();
        expect(unknownFailure.toEventMessage, equals(EventsStrings.unexpectedError));
      });
    });
  });
}
