import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/auth/data/exceptions/auth_exception.dart';
import 'package:eventix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eventix/features/auth/domain/failures/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/auth_test_data.dart';

void main() {
  late MockAuthDataSource mockDataSource;
  late MockAuthExceptionMapper mockAuthMapper;
  late MockCoreExceptionMapper mockCoreMapper;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    mockAuthMapper = MockAuthExceptionMapper();
    mockCoreMapper = MockCoreExceptionMapper();

    repository = AuthRepositoryImpl(
      dataSource: mockDataSource,
      authMapper: mockAuthMapper,
      coreMapper: mockCoreMapper,
    );
  });

  const tEmail = AuthTestData.tEmail;
  const tPassword = AuthTestData.tPassword;
  const tName = AuthTestData.tName;

  group('AuthRepositoryImpl - Inicio de Sesión', () {
    test('Resultado exitoso cuando el origen de datos responde correctamente', () async {
      when(() => mockDataSource.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).thenAnswer((_) async => Future.value());

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isSuccess, isTrue);
      verify(() => mockDataSource.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).called(1);
    });

    test('Error mapeado mediante authMapper ante una AuthException', () async {
      final tException = InvalidCredentialsException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).thenThrow(tException);

      when(() => mockAuthMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
      verify(() => mockAuthMapper.map(tException)).called(1);
    });

    test('UnexpectedAuthFailure ante una excepción de estado de autenticación inesperado', () async {
      when(() => mockDataSource.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).thenThrow(UnexpectedAuthStateException());

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, isA<UnexpectedAuthFailure>()),
      );
      verifyZeroInteractions(mockAuthMapper);
    });

    test('UnknownFailure ante una AppException genérica sin mapeo específico', () async {
      final unmappedException = FakeAppException();

      when(() => mockDataSource.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).thenThrow(unmappedException);

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, isA<UnknownFailure>()),
      );
    });
  });

  group('AuthRepositoryImpl - Registro de Usuario', () {
    test('Resultado exitoso cuando el origen de datos registra al usuario correctamente', () async {
      when(() => mockDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      )).thenAnswer((_) async => Future.value());

      final result = await repository.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result.isSuccess, isTrue);
      verify(() => mockDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      )).called(1);
    });

    test('Error mapeado mediante authMapper ante una AuthException', () async {
      final tException = InvalidCredentialsException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      )).thenThrow(tException);

      when(() => mockAuthMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
      verify(() => mockAuthMapper.map(tException)).called(1);
    });

    test('UnexpectedAuthFailure ante una excepción de estado de autenticación inesperado', () async {
      when(() => mockDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      )).thenThrow(UnexpectedAuthStateException());

      final result = await repository.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, isA<UnexpectedAuthFailure>()),
      );
      verifyZeroInteractions(mockAuthMapper);
    });

    test('UnknownFailure ante una AppException genérica sin mapeo específico', () async {
      final unmappedException = FakeAppException();

      when(() => mockDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      )).thenThrow(unmappedException);

      final result = await repository.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, isA<UnknownFailure>()),
      );
    });
  });

  group('AuthRepositoryImpl - Cierre de Sesión', () {
    test('Resultado exitoso al cerrar sesión correctamente en el origen de datos', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async => Future.value());

      final result = await repository.signOut();

      expect(result.isSuccess, isTrue);
      verify(() => mockDataSource.signOut()).called(1);
    });

    test('Uso de coreMapper para transformar CoreException en un fallo', () async {
      final tException = RequestTimeoutException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.signOut()).thenThrow(tException);
      when(() => mockCoreMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.signOut();

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );

      verify(() => mockCoreMapper.map(tException)).called(1);
    });
  });
}
