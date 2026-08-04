import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/domain/usecases/get_cities_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late MockEventsRepository mockRepository;
  late GetCitiesUseCase useCase;

  setUp(() {
    mockRepository = MockEventsRepository();
    useCase = GetCitiesUseCase(mockRepository);
  });

  group('GetCitiesUseCase - Ejecución', () {
    final tCities = [EventsTestData.tCityEntity];

    test(
      'Llamada a getCities en el repositorio',
      () async {
        when(() => mockRepository.getCities())
            .thenAnswer((_) async => Success(tCities));

        await useCase();

        verify(() => mockRepository.getCities()).called(1);
      },
    );

    test(
      'Retorno de lista de ciudades cuando la consulta es exitosa',
      () async {
        when(() => mockRepository.getCities())
            .thenAnswer((_) async => Success(tCities));

        final result = await useCase();

        expect(result.isSuccess, isTrue);
        expect(
          result.when(success: (val) => val, error: (_) => null),
          equals(tCities),
        );
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(() => mockRepository.getCities())
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
