import 'package:eventix/core/constants/app_constants.dart';
import 'package:eventix/core/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators - Campo Requerido', () {
    test('Valor nulo retorna mensaje de error', () {
      expect(Validators.required(null), AppConstants.requiredField);
    });

    test('Cadena vacía retorna mensaje de error', () {
      expect(Validators.required(''), AppConstants.requiredField);
    });

    test('Cadena con solo espacios retorna mensaje de error', () {
      expect(Validators.required('   '), AppConstants.requiredField);
    });

    test('Texto válido no retorna error', () {
      expect(Validators.required('Contenido'), isNull);
    });

    test('Mensaje personalizado se aplica correctamente', () {
      const customMsg = 'Error custom';
      expect(Validators.required(null, message: customMsg), customMsg);
    });
  });

  group('Validators - Longitud de Texto', () {
    test('Texto inferior al mínimo retorna error con valor dinámico', () {
      expect(Validators.minLength('abc', 5), AppConstants.minLengthError(5));
    });

    test('Texto igual al mínimo no retorna error', () {
      expect(Validators.minLength('abcde', 5), isNull);
    });

    test('Texto superior al máximo retorna error con valor dinámico', () {
      expect(Validators.maxLength('abcdef', 5), AppConstants.maxLengthError(5));
    });

    test('Texto igual al máximo no retorna error', () {
      expect(Validators.maxLength('abcde', 5), isNull);
    });

    test('Espacios en blanco no cuentan para la longitud mínima', () {
      expect(Validators.minLength('  a  ', 2), AppConstants.minLengthError(2));
    });

    test('Mensaje personalizado se aplica en minLength', () {
      const customMsg = 'Muy corto';
      expect(Validators.minLength('a', 5, message: customMsg), customMsg);
    });

    test('Mensaje personalizado se aplica en maxLength', () {
      const customMsg = 'Muy largo';
      expect(Validators.maxLength('abcdef', 5, message: customMsg), customMsg);
    });

    test('Valor nulo o vacío en maxLength no retorna error', () {
      expect(Validators.maxLength(null, 5), isNull);
      expect(Validators.maxLength('', 5), isNull);
    });
  });

  group('Validators - Formato de Email', () {
    test('Email sin arroba o dominio retorna mensaje de error', () {
      expect(Validators.email('invalido'), AppConstants.invalidEmail);
      expect(Validators.email('test@'), AppConstants.invalidEmail);
      expect(Validators.email('@dominio.com'), AppConstants.invalidEmail);
    });

    test('Estructura estándar de email no retorna error', () {
      expect(Validators.email('usuario@ejemplo.com'), isNull);
    });

    test('Valor nulo o vacío se ignora (delegado a required)', () {
      expect(Validators.email(null), isNull);
      expect(Validators.email(''), isNull);
    });

    test('Mensaje personalizado se aplica correctamente', () {
      const customMsg = 'Email mal formado';
      expect(Validators.email('invalido', message: customMsg), customMsg);
    });
  });

  group('Validators - Patrones Personalizados', () {
    final numericRegex = RegExp(r'^[0-9]+$');

    test('Texto que no coincide con la expresión regular retorna error', () {
      expect(
        Validators.pattern('abc', numericRegex),
        AppConstants.invalidFormat,
      );
    });

    test('Texto coincidente no retorna error', () {
      expect(Validators.pattern('12345', numericRegex), isNull);
    });

    test('Valor nulo o vacío se ignora', () {
      expect(Validators.pattern(null, numericRegex), isNull);
      expect(Validators.pattern('', numericRegex), isNull);
    });

    test('Mensaje personalizado se aplica correctamente', () {
      const customMsg = 'Formato incorrecto';
      expect(
        Validators.pattern('abc', numericRegex, message: customMsg),
        customMsg,
      );
    });
  });

  group('Validators - Composición', () {
    test('Se detiene en el primer validador que falla', () {
      String? composite(String? v) => Validators.compose([
        (val) => Validators.required(val),
        (val) => Validators.email(val),
        (val) => Validators.minLength(val, 10),
      ], v);

      // Falla el primero (required)
      expect(composite(''), AppConstants.requiredField);

      // Falla el segundo (email) aunque sea corto
      expect(composite('abc'), AppConstants.invalidEmail);

      // Falla el tercero (longitud)
      // 'a@b.cl' tiene 6 caracteres, por lo que fallará el minLength(10)
      expect(composite('a@b.cl'), AppConstants.minLengthError(10));
    });

    test('Retorna nulo si todas las reglas se cumplen', () {
      final result = Validators.compose([
        (val) => Validators.required(val),
        (val) => Validators.minLength(val, 3),
      ], 'Texto largo');

      expect(result, isNull);
    });
  });
}
