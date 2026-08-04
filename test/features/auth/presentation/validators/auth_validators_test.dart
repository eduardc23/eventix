import 'package:eventix/features/auth/presentation/constants/auth_strings.dart';
import 'package:eventix/features/auth/presentation/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators - Email', () {
    test('Retorna error de obligatoriedad cuando el valor es nulo', () {
      expect(AuthValidators.email(null), AuthStrings.emailRequired);
    });

    test('Retorna error de obligatoriedad cuando el valor está vacío', () {
      expect(AuthValidators.email(''), AuthStrings.emailRequired);
    });

    test('Retorna error de formato cuando el email no es válido', () {
      expect(AuthValidators.email('noesuncorreo'), AuthStrings.invalidEmail);
    });

    test('No retorna error cuando el formato del email es correcto', () {
      expect(AuthValidators.email('test@example.com'), isNull);
    });
  });

  group('AuthValidators - Nombre de Usuario', () {
    test('Retorna error de obligatoriedad cuando el valor es nulo', () {
      expect(AuthValidators.username(null), AuthStrings.usernameRequired);
    });

    test('Retorna error de obligatoriedad cuando el valor está vacío', () {
      expect(AuthValidators.username(''), AuthStrings.usernameRequired);
    });

    test('Retorna error de longitud mínima cuando tiene menos de 3 caracteres', () {
      expect(AuthValidators.username('ab'), AuthStrings.usernameMinLength);
    });

    test('No retorna error cuando tiene exactamente 3 caracteres', () {
      expect(AuthValidators.username('abc'), isNull);
    });

    test('No retorna error cuando el nombre de usuario es válido', () {
      expect(AuthValidators.username('john_doe'), isNull);
    });
  });

  group('AuthValidators - Contraseña', () {
    test('Retorna error de obligatoriedad cuando el valor es nulo', () {
      expect(AuthValidators.password(null), AuthStrings.passwordRequired);
    });

    test('Retorna error de obligatoriedad cuando el valor está vacío', () {
      expect(AuthValidators.password(''), AuthStrings.passwordRequired);
    });

    test('Retorna error de longitud mínima cuando tiene menos de 6 caracteres', () {
      expect(AuthValidators.password('12345'), AuthStrings.passwordMinLength);
    });

    test('No retorna error cuando tiene exactamente 6 caracteres', () {
      expect(AuthValidators.password('123456'), isNull);
    });

    test('No retorna error cuando la contraseña cumple con los requisitos', () {
      expect(AuthValidators.password('securePass1'), isNull);
    });
  });

  group('AuthValidators - Confirmación de Contraseña', () {
    const password = 'myPassword123';

    test('Retorna error de obligatoriedad cuando el valor es nulo', () {
      expect(
        AuthValidators.confirmPassword(null, password),
        AuthStrings.confirmPasswordRequired,
      );
    });

    test('Retorna error de obligatoriedad cuando el valor está vacío', () {
      expect(
        AuthValidators.confirmPassword('', password),
        AuthStrings.confirmPasswordRequired,
      );
    });

    test('Retorna error de coincidencia cuando las contraseñas son distintas', () {
      expect(
        AuthValidators.confirmPassword('otraPassword', password),
        AuthStrings.passwordsDoNotMatch,
      );
    });

    test('No retorna error cuando ambas contraseñas son idénticas', () {
      expect(
        AuthValidators.confirmPassword(password, password),
        isNull,
      );
    });
  });
}
