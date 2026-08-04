import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignOutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockRepository);
  });

  group('SignOutUseCase - Comportamiento', () {
    test(
      'Llamada a signOut en el repositorio',
      () async {
        when(() => mockRepository.signOut())
            .thenAnswer((_) async => const Success(null));

        await useCase();

        verify(() => mockRepository.signOut()).called(1);
      },
    );

    test(
      'Retorno de Success cuando la operación es exitosa',
      () async {
        when(() => mockRepository.signOut())
            .thenAnswer((_) async => const Success(null));

        final result = await useCase();

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(() => mockRepository.signOut())
            .thenAnswer((_) async => Error(failure));

        final result = await useCase();

        expect(result.isError, isTrue);
        expect(result.when(success: (_) => null, error: (e) => e), equals(failure));
      },
    );
  });
}
