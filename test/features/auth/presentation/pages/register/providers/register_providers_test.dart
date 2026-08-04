import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:eventix/features/auth/presentation/pages/register/providers/register_providers.dart';
import 'package:eventix/features/auth/presentation/pages/register/providers/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/fakes.dart';
import '../../../../../../helpers/mocks.dart';
import '../../../../../../helpers/riverpod_helpers.dart';
import '../../../../helpers/auth_test_data.dart';

final tParams = SingUpParams(
  name: AuthTestData.tName,
  email: AuthTestData.tEmail,
  password: AuthTestData.tPassword,
);


void main() {
  late MockSignUpUseCase mockSignUpUseCase;

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
    registerFallbackValue(tParams);
  });

  group('RegisterNotifier - Estado Inicial', () {
    test('El estado inicial es RegisterState.initial()', () {
      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      expect(container.read(registerProvider), const RegisterState.initial());
    });
  });

  group('RegisterNotifier - Flujo Exitoso', () {
    setUp(() {
      when(() => mockSignUpUseCase(any()))
          .thenAnswer((_) async => const Success(null));
    });

    test('Emite loading y luego vuelve a initial tras un registro exitoso', () async {
      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      final states = <RegisterState>[];
      container.listen(
        registerProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      expect(states, [
        const RegisterState.loading(),
        const RegisterState.initial(),
      ]);
    });

    test('Llama al caso de uso con los parámetros de registro correctos', () async {
      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      verify(() => mockSignUpUseCase(any())).called(1);
      verifyNoMoreInteractions(mockSignUpUseCase);
    });
  });

  group('RegisterNotifier - Flujo de Error', () {
    late AppFailure tFailure;

    setUp(() {
      tFailure = FakeAppFailure();
      when(() => mockSignUpUseCase(any())).thenAnswer((_) async => Error(tFailure));
    });

    test('Emite loading y luego fallo con el error correspondiente cuando el registro falla', () async {
      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      final states = <RegisterState>[];
      container.listen(
        registerProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      expect(states, [
        const RegisterState.loading(),
        RegisterState.failure(failure: tFailure),
      ]);
    });

    test('El estado de fallo contiene la información del AppFailure devuelto por el caso de uso', () async {
      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      final state = container.read(registerProvider);

      expect(state, isA<RegisterState>());
      state.whenOrNull(failure: (failure) => expect(failure, tFailure));
    });
  });

  group('RegisterNotifier - Llamadas Consecutivas', () {
    test('Vuelve a pasar por el estado de carga en cada nuevo intento de registro', () async {
      final tFailure = FakeAppFailure();

      // Primera llamada falla
      when(() => mockSignUpUseCase(any())).thenAnswer((_) async => Error(tFailure));

      final container = createContainer(
        overrides: [signUpUseCaseProvider.overrideWithValue(mockSignUpUseCase)],
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      expect(
        container.read(registerProvider),
        RegisterState.failure(failure: tFailure),
      );

      // Segunda llamada exitosa
      when(() => mockSignUpUseCase(any())).thenAnswer((_) async => const Success(null));

      final states = <RegisterState>[];
      container.listen(
        registerProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(registerProvider.notifier).signUp(
            name: AuthTestData.tName,
            email: AuthTestData.tEmail,
            password: AuthTestData.tPassword,
          );

      expect(states.first, const RegisterState.loading());
      expect(states.last, const RegisterState.initial());
    });
  });
}
