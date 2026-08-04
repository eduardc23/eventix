import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/domain/usecases/get_events_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late MockEventsRepository mockRepository;
  late GetEventsUseCase useCase;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockRepository = MockEventsRepository();
    useCase = GetEventsUseCase(mockRepository);
  });

  group('GetEventsUseCase - Ejecución', () {
    const tCategoryId = 'cat1';
    const tCityId = 'city1';
    final tEvents = [EventsTestData.tEventEntity];

    test(
      'Llamada a getEvents en el repositorio con los parámetros correctos (filtros básicos)',
      () async {
        when(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Success(tEvents));

        const params = GetEventsParams(categoryId: tCategoryId, cityId: tCityId);
        await useCase(params);

        verify(
          () => mockRepository.getEvents(
            categoryId: tCategoryId,
            cityId: tCityId,
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).called(1);
      },
    );

    test(
      'Debe usar el startDate del filtro si es una fecha futura',
      () async {
        final futureDate = DateTime.now().add(const Duration(days: 5));
        final endDate = futureDate.add(const Duration(days: 1));
        
        when(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Success(tEvents));

        final params = GetEventsParams(
          dateFilter: DateFilter.range(from: futureDate, to: endDate),
        );
        
        await useCase(params);

        verify(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: futureDate,
            endDate: endDate,
          ),
        ).called(1);
      },
    );

    test(
      'Debe usar DateTime.now() como startDate si la fecha del filtro es pasada',
      () async {
        final pastDate = DateTime.now().subtract(const Duration(days: 5));
        final rangeEnd = DateTime.now();
        
        when(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Success(tEvents));

        final params = GetEventsParams(
          dateFilter: DateFilter.range(from: pastDate, to: rangeEnd),
        );
        final beforeCall = DateTime.now();
        await useCase(params);
        final afterCall = DateTime.now();

        // Verificamos que el startDate NO sea pastDate, sino algo muy cercano a "ahora"
        final captured = verify(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: captureAny(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).captured.single as DateTime;

        expect(captured.isAfter(pastDate), isTrue);
        expect(
          captured.isAtSameMomentAs(beforeCall) || captured.isAfter(beforeCall),
          isTrue,
        );
        expect(
          captured.isAtSameMomentAs(afterCall) || captured.isBefore(afterCall),
          isTrue,
        );
      },
    );

    test(
      'Retorno de lista de eventos cuando la consulta es exitosa',
      () async {
        when(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Success(tEvents));

        final result = await useCase(const GetEventsParams.empty());

        expect(result.isSuccess, isTrue);
        expect(
          result.when(success: (val) => val, error: (_) => null),
          equals(tEvents),
        );
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(
          () => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            cityId: any(named: 'cityId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Error(failure));

        final result = await useCase(const GetEventsParams.empty());

        expect(result.isError, isTrue);
        expect(
          result.when(success: (_) => null, error: (e) => e),
          equals(failure),
        );
      },
    );
  });
}
