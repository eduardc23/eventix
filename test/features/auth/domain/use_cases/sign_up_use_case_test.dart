import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/auth_test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignUpUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  group('SignUpUseCase - Comportamiento', () {
    const tName = AuthTestData.tName;
    const tEmail = AuthTestData.tEmail;
    const tPassword = AuthTestData.tPassword;
    const tParams = SingUpParams(
      name: tName,
      email: tEmail,
      password: tPassword,
    );

    test(
      'Llamada a signUpWithEmailAndPassword con los parámetros correctos',
      () async {
        when(
          () => mockRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          ),
        ).thenAnswer((_) async => const Success(null));

        await useCase(tParams);

        verify(
          () => mockRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          ),
        ).called(1);
      },
    );

    test('Retorno de Success cuando el registro es exitoso', () async {
      when(
        () => mockRepository.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(tParams);

      expect(result.isSuccess, isTrue);
    });

    test('Propagación del fallo cuando el repositorio falla', () async {
      final failure = FakeAppFailure();
      when(
        () => mockRepository.signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
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
}
