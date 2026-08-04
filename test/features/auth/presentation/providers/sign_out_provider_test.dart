import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/di/auth_di_providers.dart';
import 'package:eventix/features/auth/presentation/providers/sign_out_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/riverpod_helpers.dart';

void main() {
  late MockSignOutUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSignOutUseCase();
  });

  group('SignOutNotifier - Estado Inicial', () {
    test('El estado inicial es AsyncData con valor nulo', () {
      final container = createContainer(
        overrides: [signOutUseCaseProvider.overrideWithValue(mockUseCase)],
      );

      final state = container.read(signOutProvider);

      expect(state, const AsyncData<void>(null));
    });
  });

  group('SignOutNotifier - Proceso de Cierre de Sesión', () {
    test(
      'Emite carga y luego éxito cuando el caso de uso se completa correctamente',
      () async {
        when(() => mockUseCase.call()).thenAnswer((_) async => const Success(null));

        final container = createContainer(
          overrides: [signOutUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          signOutProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await container.read(signOutProvider.notifier).signOut();

        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], const AsyncData<void>(null));
        verify(() => mockUseCase.call()).called(1);
      },
    );

    test(
      'Emite carga y luego error cuando el caso de uso devuelve un fallo',
      () async {
        final failure = FakeAppFailure();
        when(() => mockUseCase.call()).thenAnswer((_) async => Error(failure));

        final container = createContainer(
          overrides: [signOutUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          signOutProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await container.read(signOutProvider.notifier).signOut();

        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], isA<AsyncError<void>>());
        expect((states[1] as AsyncError).error, failure);
        verify(() => mockUseCase.call()).called(1);
      },
    );

    test('Ejecuta el caso de uso exactamente una vez por cada llamada', () async {
      when(() => mockUseCase.call()).thenAnswer((_) async => const Success(null));

      final container = createContainer(
        overrides: [signOutUseCaseProvider.overrideWithValue(mockUseCase)],
      );

      await container.read(signOutProvider.notifier).signOut();

      verify(() => mockUseCase.call()).called(1);
      verifyNoMoreInteractions(mockUseCase);
    });
  });
}
