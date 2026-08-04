import 'dart:async';

import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/cities_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/fakes.dart';
import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../helpers/events_test_data.dart';

void main() {
  late MockGetCitiesUseCase mockUseCase;
  final tFailure = FakeAppFailure();
  final tCities = [
    EventsTestData.tCityEntity,
  ];

  setUp(() {
    mockUseCase = MockGetCitiesUseCase();
  });

  group('CitiesNotifier', () {
    test(
      'Obtiene y retorna la lista de ciudades desde el caso de uso',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Success(tCities));

        final container = createContainer(
          overrides: [
            getCitiesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        final result = await container.read(citiesProvider.future);

        expect(result, equals(tCities));
        verify(() => mockUseCase()).called(1);
      },
    );

    test(
      'Refleja un estado de error cuando el caso de uso falla',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Error(tFailure));

        final container = createContainer(
          overrides: [
            getCitiesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        final done = Completer<void>();
        final sub = container.listen(citiesProvider, (_, next) {
          if (next.error != null && !done.isCompleted) {
            done.complete();
          }
        });

        await done.future;

        final state = container.read(citiesProvider);
        expect(state.error, isNotNull);
        expect(state.error, same(tFailure));

        sub.close();
      },
    );

    test(
      'Recarga los datos al llamar a reload',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Success(tCities));

        final container = createContainer(
          overrides: [
            getCitiesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await container.read(citiesProvider.future);

        final tNewCities = [
          EventsTestData.tCityEntity,
          EventsTestData.tCityEntity.copyWith(uid: 'city2', name: 'Other'),
        ];
        when(() => mockUseCase()).thenAnswer((_) async => Success(tNewCities));

        await container.read(citiesProvider.notifier).reload();

        expect(
          await container.read(citiesProvider.future),
          equals(tNewCities),
        );
        verify(() => mockUseCase()).called(2);
      },
    );
  });
}
