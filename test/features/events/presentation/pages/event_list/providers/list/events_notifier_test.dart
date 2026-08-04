import 'dart:async';

import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/domain/usecases/get_events_usecase.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/list/events_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/fakes.dart';
import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../helpers/events_test_data.dart';

void main() {
  late MockGetEventsUseCase mockUseCase;
  final tFailure = FakeAppFailure();
  final tEvents = [
    EventsTestData.makeEventEntity(uid: '1'),
    EventsTestData.makeEventEntity(uid: '2'),
  ];

  setUpAll(() {
    registerFallbackValue(const GetEventsParams.empty());
  });

  setUp(() {
    mockUseCase = MockGetEventsUseCase();
  });

  group('EventsNotifier - Carga de Eventos', () {
    test(
      'Obtiene y retorna la lista de eventos desde el caso de uso con filtros vacíos por defecto',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tEvents));

        final container = createContainer(
          overrides: [getEventsUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        final result = await container.read(eventsProvider.future);

        expect(result, equals(tEvents));
        verify(() => mockUseCase(any(that: isA<GetEventsParams>()))).called(1);
      },
    );

    test('Refleja un estado de error cuando el caso de uso falla', () async {
      when(() => mockUseCase(any())).thenAnswer((_) async => Error(tFailure));

      final container = createContainer(
        overrides: [getEventsUseCaseProvider.overrideWithValue(mockUseCase)],
      );

      final done = Completer<void>();
      final sub = container.listen(eventsProvider, (_, next) {
        if (next.hasError && !done.isCompleted) {
          done.complete();
        }
      });

      await done.future;

      final state = container.read(eventsProvider);
      expect(state.hasError, isTrue);
      expect(state.error, same(tFailure));

      sub.close();
    });
  });

  group('EventsNotifier - Reactividad con Filtros', () {
    test(
      'Vuelve a cargar los eventos cuando cambian los filtros aplicados',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tEvents));

        final container = createContainer(
          overrides: [getEventsUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        // Primera carga (filtros vacíos)
        await container.read(eventsProvider.future);
        verify(() => mockUseCase(any())).called(1);

        // Cambiamos un filtro
        const tCityFilter = ActiveFilter(id: 'city-1', name: 'Bogotá');
        container
            .read(appliedEventFiltersProvider.notifier)
            .apply(const EventFilters(city: tCityFilter));

        // Esperamos a que el notifier se actualice
        await container.read(eventsProvider.future);

        // Verificamos que se llamó una segunda vez con los parámetros correctos
        verify(
          () => mockUseCase(
            any(
              that: predicate<GetEventsParams>(
                (p) => p.cityId == tCityFilter.id,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'Vuelve a cargar los eventos cuando cambia el filtro de fecha',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tEvents));

        final container = createContainer(
          overrides: [getEventsUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        await container.read(eventsProvider.future);

        final tDateFilter = DateFilter.range(
          from: DateTime(2025, 1, 1),
          to: DateTime(2025, 1, 7),
        );

        container
            .read(appliedEventFiltersProvider.notifier)
            .apply(EventFilters(date: tDateFilter));

        await container.read(eventsProvider.future);

        verify(
          () => mockUseCase(
            any(
              that: predicate<GetEventsParams>(
                (p) => p.dateFilter == tDateFilter,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('EventsNotifier - Actualización (Refresh)', () {
    test(
      'Invalida el estado y recarga los datos al llamar a refresh',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tEvents));

        final container = createContainer(
          overrides: [getEventsUseCaseProvider.overrideWithValue(mockUseCase)],
        );

        await container.read(eventsProvider.future);

        final tNewEvents = [tEvents.first];
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tNewEvents));

        await container.read(eventsProvider.notifier).refresh();

        expect(await container.read(eventsProvider.future), equals(tNewEvents));
        verify(() => mockUseCase(any())).called(2);
      },
    );
  });
}
