import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/auth_test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignInUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  group('SignInUseCase - Ejecución', () {
    const tEmail = AuthTestData.tEmail;
    const tPassword = AuthTestData.tPassword;
    const tParams = SignInParams(email: tEmail, password: tPassword);

    group('SignInUseCase - Delegación', () {
      test(
        'Llamada a signInWithEmailAndPassword con los parámetros correctos',
        () async {
          when(
            () => mockRepository.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).thenAnswer((_) async => const Success(null));

          await useCase(tParams);

          verify(
            () => mockRepository.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
        },
      );
    });

    group('SignInUseCase - Éxito', () {
      setUp(() {
        when(
          () => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Success(null));
      });

      test('Retorno de Success', () async {
        final result = await useCase(tParams);
        expect(result.isSuccess, isTrue);
      });

      test('Propagación del resultado sin transformación', () async {
        final result = await useCase(tParams);
        expect(result, isA<Success<void, AppFailure>>());
      });
    });

    group('SignInUseCase - Fallo', () {
      test('Propagación de AppFailure', () async {
        final failure = FakeAppFailure();
        when(
          () => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Error(failure));

        final result = await useCase(tParams);

        expect(result.isError, isTrue);
        expect(
          result.when(success: (_) => null, error: (e) => e),
          equals(failure),
        );
      });
    });
  });
}
