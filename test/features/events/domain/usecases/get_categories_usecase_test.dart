import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late MockEventsRepository mockRepository;
  late GetCategoriesUseCase useCase;

  setUp(() {
    mockRepository = MockEventsRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  group('GetCategoriesUseCase - Ejecución', () {
    final tCategories = [EventsTestData.tCategoryEntity];

    test(
      'Llamada a getCategories en el repositorio',
      () async {
        when(() => mockRepository.getCategories())
            .thenAnswer((_) async => Success(tCategories));

        await useCase();

        verify(() => mockRepository.getCategories()).called(1);
      },
    );

    test(
      'Retorno de lista de categorías cuando la consulta es exitosa',
      () async {
        when(() => mockRepository.getCategories())
            .thenAnswer((_) async => Success(tCategories));

        final result = await useCase();

        expect(result.isSuccess, isTrue);
        expect(
          result.when(success: (val) => val, error: (_) => null),
          equals(tCategories),
        );
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(() => mockRepository.getCategories())
            .thenAnswer((_) async => Error(failure));

        final result = await useCase();

        expect(result.isError, isTrue);
        expect(
          result.when(success: (_) => null, error: (e) => e),
          equals(failure),
        );
      },
    );
  });
}
