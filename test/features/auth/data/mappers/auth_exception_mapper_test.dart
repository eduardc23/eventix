import 'package:eventix/features/auth/data/exceptions/auth_exception.dart';
import 'package:eventix/features/auth/data/mappers/auth_exception_mapper.dart';
import 'package:eventix/features/auth/domain/failures/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthExceptionMapper mapper;

  setUp(() {
    mapper = const AuthExceptionMapperImpl();
  });

  group('AuthExceptionMapperImpl - Mapeo de Excepciones de Auth', () {
    test('InvalidCredentialsException se transforma en InvalidCredentialsFailure', () {
      final result = mapper.map(const InvalidCredentialsException());

      expect(result, isA<InvalidCredentialsFailure>());
    });

    test('EmailAlreadyInUseException se transforma en EmailAlreadyInUseFailure', () {
      final result = mapper.map(const EmailAlreadyInUseException());

      expect(result, isA<EmailAlreadyInUseFailure>());
    });

    test('UnexpectedAuthStateException se transforma en UnexpectedAuthFailure', () {
      final result = mapper.map(const UnexpectedAuthStateException());

      expect(result, isA<UnexpectedAuthFailure>());
    });
  });
}
