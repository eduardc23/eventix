import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/auth/domain/failures/auth_failure.dart';
import 'package:eventix/features/auth/presentation/extensions/auth_failure_message_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_app_config.dart';

void main() {
  group('AuthFailureMessageX - Resolución de Mensajes', () {
    group('AuthFailure - Errores de Autenticación', () {
      test('Presenta mensaje de error para credenciales inválidas', () {
        const failure = AuthFailure.invalidCredentials();
        expect(
          failure.toAuthMessage(testAppConfig),
          equals(testAppConfig.banners.auth.invalidCredentials),
        );
      });

      test('Presenta mensaje de error cuando el email ya está en uso', () {
        const failure = AuthFailure.emailAlreadyInUse();
        expect(
          failure.toAuthMessage(testAppConfig),
          equals(testAppConfig.banners.auth.emailAlreadyInUse),
        );
      });

      test(
          'Presenta mensaje de error para fallos inesperados de autenticación', () {
        const failure = AuthFailure.unexpected();
        expect(
          failure.toAuthMessage(testAppConfig),
          equals(testAppConfig.banners.auth.unexpectedError),
        );
      });
    });

    group('CoreFailure - Delegación de Errores', () {
      test('Delega correctamente el mensaje ante un fallo de servidor', () {
        const failure = ServerFailure(message: 'Error de servidor custom');
        expect(
          failure.toAuthMessage(testAppConfig),
          equals('Error de servidor custom'),
        );
      });

      test('Delega correctamente el mensaje ante un fallo de red', () {
        const failure = NetworkFailure();
        expect(
          failure.toAuthMessage(testAppConfig),
          equals(AppConstants.networkError),
        );
      });

      test(
          'Delega correctamente el mensaje ante un fallo de tiempo de espera', () {
        const failure = TimeoutFailure();
        expect(
          failure.toAuthMessage(testAppConfig),
          equals(AppConstants.timeoutError),
        );
      });
    });

    group('Fallback - Casos No Manejados', () {
      test(
          'Utiliza el mensaje de error inesperado ante cualquier otro tipo de fallo', () {
        // Un fallo que no sea ni AuthFailure ni CoreFailure
        final unknownFailure = FakeAppFailure();
        expect(
          unknownFailure.toAuthMessage(testAppConfig),
          equals(testAppConfig.banners.auth.unexpectedError),
        );
      });
    });
  });
}
