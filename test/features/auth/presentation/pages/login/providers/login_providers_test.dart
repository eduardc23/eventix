import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:eventix/features/auth/presentation/pages/login/providers/login_providers.dart';
import 'package:eventix/features/auth/presentation/pages/login/providers/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/fakes.dart';
import '../../../../../../helpers/mocks.dart';
import '../../../../../../helpers/riverpod_helpers.dart';
import '../../../../helpers/auth_test_data.dart';


final tParams = SignInParams(
  email: AuthTestData.tEmail,
  password: AuthTestData.tPassword,
);


void main() {
  late MockSignInUseCase mockSignInUseCase;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    registerFallbackValue(tParams);
  });

  group('LoginNotifier - Estado Inicial', () {
    test('El estado inicial es LoginState.initial()', () {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      expect(container.read(loginProvider), const LoginState.initial());
    });
  });

  group('LoginNotifier - Flujo Exitoso', () {
    setUp(() {
      when(() => mockSignInUseCase(any()))
          .thenAnswer((_) async => const Success(null));
    });

    test('Emite loading y luego vuelve a initial tras un inicio de sesión exitoso', () async {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      final states = <LoginState>[];
      container.listen(
        loginProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      expect(states, [
        const LoginState.loading(),
        const LoginState.initial(),
      ]);
    });

    test('Llama al caso de uso con los parámetros de email y contraseña correctos', () async {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      verify(() => mockSignInUseCase(any())).called(1);
      verifyNoMoreInteractions(mockSignInUseCase);
    });
  });

  group('LoginNotifier - Flujo de Error', () {
    late AppFailure tFailure;

    setUp(() {
      tFailure = FakeAppFailure();
      when(() => mockSignInUseCase(any())).thenAnswer((_) async => Error(tFailure));
    });

    test('Emite loading y luego fallo con el error correspondiente cuando la operación falla', () async {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      final states = <LoginState>[];
      container.listen(
        loginProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      expect(states, [
        const LoginState.loading(),
        LoginState.failure(failure: tFailure),
      ]);
    });

    test('El estado de fallo contiene la información del AppFailure devuelto por el caso de uso', () async {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      final state = container.read(loginProvider);

      expect(state, isA<LoginState>());
      state.whenOrNull(failure: (failure) => expect(failure, tFailure));
    });

    test('Llama al caso de uso exactamente una vez aunque la operación falle', () async {
      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      verify(() => mockSignInUseCase(any())).called(1);
    });
  });

  group('LoginNotifier - Llamadas Consecutivas', () {
    test('Vuelve a pasar por el estado de carga en cada nuevo intento de inicio de sesión', () async {
      final tFailure = FakeAppFailure();

      // Primera llamada falla
      when(() => mockSignInUseCase(any())).thenAnswer((_) async => Error(tFailure));

      final container = createContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(mockSignInUseCase)],
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      expect(
        container.read(loginProvider),
        LoginState.failure(failure: tFailure),
      );

      // Segunda llamada exitosa
      when(() => mockSignInUseCase(any())).thenAnswer((_) async => const Success(null));

      final states = <LoginState>[];
      container.listen(
        loginProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(loginProvider.notifier).signIn(
            AuthTestData.tEmail,
            AuthTestData.tPassword,
          );

      expect(states.first, const LoginState.loading());
      expect(states.last, const LoginState.initial());
    });
  });
}
