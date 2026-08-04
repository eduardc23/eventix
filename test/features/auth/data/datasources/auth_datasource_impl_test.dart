import 'package:eventix/features/auth/data/datasource/auth_datasource_impl.dart';
import 'package:eventix/features/auth/data/exceptions/auth_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/auth_test_data.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseAuthExceptionMapper mockAuthMapper;
  late MockFirebaseExceptionMapper mockFirebaseMapper;
  late AuthDatasourceImpl datasource;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockAuthMapper = MockFirebaseAuthExceptionMapper();
    mockFirebaseMapper = MockFirebaseExceptionMapper();

    datasource = AuthDatasourceImpl(
      auth: mockAuth,
      authMapper: mockAuthMapper,
      firebaseMapper: mockFirebaseMapper,
    );
  });

  const tEmail = AuthTestData.tEmail;
  const tPassword = AuthTestData.tPassword;
  const tName = AuthTestData.tName;

  group('AuthDatasourceImpl - Inicio de Sesión', () {
    test('Inicio de sesión exitoso al recibir credenciales válidas de Firebase', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);

      // Act & Assert
      await expectLater(
        datasource.signInWithEmailAndPassword(email: tEmail, password: tPassword),
        completes,
      );
      verify(() => mockAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword)).called(1);
    });

    test('Lanza UnexpectedAuthStateException si Firebase no retorna un usuario tras la autenticación', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      when(() => mockUserCredential.user).thenReturn(null);
      when(() => mockAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);

      await expectLater(
        datasource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<UnexpectedAuthStateException>()),
      );
    });
  });

  group('AuthDatasourceImpl - Registro de Usuario', () {
    test('Flujo de registro completo incluyendo actualización de perfil y recarga de estado', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockAuth.createUserWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);

      // Se requiere reload() para asegurar que el estado local del SDK refleje los cambios del perfil
      // updateDisplayName es asíncrono y no garantiza la actualización inmediata del currentUser
      when(() => mockUser.updateDisplayName(tName)).thenAnswer((_) async {});
      when(() => mockUser.reload()).thenAnswer((_) async {});
      
      // Mock del currentUser después del reload
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act & Assert
      await expectLater(
        datasource.signUpWithEmailAndPassword(email: tEmail, password: tPassword, name: tName),
        completes,
      );

      verify(() => mockUser.updateDisplayName(tName)).called(1);
      verify(() => mockUser.reload()).called(1);
    });

    test('Lanza UnexpectedAuthStateException si el usuario desaparece tras recargar su estado', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockAuth.createUserWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);

      when(() => mockUser.updateDisplayName(tName)).thenAnswer((_) async {});
      when(() => mockUser.reload()).thenAnswer((_) async {});
      
      // Simulamos una inconsistencia: el usuario existe al crear pero es null tras el reload
      when(() => mockAuth.currentUser).thenReturn(null);


      await expectLater(
        datasource.signUpWithEmailAndPassword(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<UnexpectedAuthStateException>()),
      );

    });
  });

  group('AuthDatasourceImpl - Cierre de Sesión', () {
    test('Cierre de sesión invoca el método correspondiente en el SDK de Firebase', () async {
      // Arrange
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      // Act & Assert
      await expectLater(datasource.signOut(), completes);
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
