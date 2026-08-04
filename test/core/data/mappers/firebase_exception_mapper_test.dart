import 'package:eventix/core/constants/firebase_codes_constants.dart';
import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/data/mappers/firebase_exception_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FirebaseExceptionMapper mapper;

  setUp(() {
    mapper = const FirebaseExceptionMapperImpl();
  });

  group('FirebaseExceptionMapperImpl - Mapeo de Conectividad', () {
    test('network-request-failed se transforma en NetworkException', () {
      final exception = FirebaseException(
        plugin: 'firestore',
        code: FirebaseCodesConstants.networkRequestFailed,
      );

      final result = mapper.mapFirebase(exception);

      expect(result, isA<NetworkException>());
    });

    test('unavailable se transforma en NetworkException', () {
      final exception = FirebaseException(
        plugin: 'firestore',
        code: FirebaseCodesConstants.unavailable,
      );

      final result = mapper.mapFirebase(exception);

      expect(result, isA<NetworkException>());
    });

    test('deadline-exceeded se transforma en RequestTimeoutException', () {
      final exception = FirebaseException(
        plugin: 'firestore',
        code: FirebaseCodesConstants.deadlineExceeded,
      );

      final result = mapper.mapFirebase(exception);

      expect(result, isA<RequestTimeoutException>());
    });
  });

  group('FirebaseExceptionMapperImpl - Mapeo Remoto', () {
    test('too-many-requests se transforma en RateLimitException', () {
      final exception = FirebaseException(
        plugin: 'auth',
        code: FirebaseCodesConstants.tooManyRequests,
      );

      final result = mapper.mapFirebase(exception);

      expect(result, isA<RateLimitException>());
    });
  });

  group('FirebaseExceptionMapperImpl - Fallbacks', () {
    test('Código no reconocido se transforma en ServerException', () {
      final exception = FirebaseException(
        plugin: 'cloud_functions',
        code: 'unknown-code',
      );

      final result = mapper.mapFirebase(exception);

      expect(result, isA<ServerException>());
    });

    test('ServerException preserva el mensaje original de Firebase', () {
      const message = 'Internal error occurred';
      final exception = FirebaseException(
        plugin: 'cloud_functions',
        code: 'internal',
        message: message,
      );

      final result = mapper.mapFirebase(exception);

      expect((result as ServerException).message, message);
    });
  });
}
