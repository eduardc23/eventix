import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/features/auth/data/constants/firebase_auth_codes.dart';
import 'package:eventix/features/auth/data/exceptions/auth_exception.dart';
import 'package:eventix/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FirebaseAuthExceptionMapper mapper;

  setUp(() {
    mapper = const FirebaseAuthExceptionMapperImpl();
  });

  group('FirebaseAuthExceptionMapperImpl - Mapeo de Credenciales', () {
    test('wrong-password se transforma en InvalidCredentialsException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.wrongPassword);

      final result = mapper.map(exception);

      expect(result, isA<InvalidCredentialsException>());
    });

    test('user-not-found se transforma en InvalidCredentialsException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.userNotFound);

      final result = mapper.map(exception);

      expect(result, isA<InvalidCredentialsException>());
    });

    test('invalid-credential se transforma en InvalidCredentialsException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.invalidCredential);

      final result = mapper.map(exception);

      expect(result, isA<InvalidCredentialsException>());
    });
  });

  group('FirebaseAuthExceptionMapperImpl - Mapeo de Registro', () {
    test('email-already-in-use se transforma en EmailAlreadyInUseException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.emailAlreadyInUse);

      final result = mapper.map(exception);

      expect(result, isA<EmailAlreadyInUseException>());
    });
  });

  group('FirebaseAuthExceptionMapperImpl - Mapeo de Core', () {
    test('too-many-requests se transforma en RateLimitException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.tooManyRequests);

      final result = mapper.map(exception);

      expect(result, isA<RateLimitException>());
    });

    test('network-request-failed se transforma en NetworkException', () {
      final exception = FirebaseAuthException(code: FirebaseAuthCodes.networkRequestFailed);

      final result = mapper.map(exception);

      expect(result, isA<NetworkException>());
    });
  });

  group('FirebaseAuthExceptionMapperImpl - Fallbacks', () {
    test('Código no reconocido se transforma en UnknownException con el código', () {
      const unknownCode = 'unknown-auth-code';
      final exception = FirebaseAuthException(code: unknownCode);

      final result = mapper.map(exception);

      expect(result, isA<UnknownException>());
      expect((result as UnknownException).message, unknownCode);
    });
  });
}
