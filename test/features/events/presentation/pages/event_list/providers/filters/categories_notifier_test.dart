import 'dart:async';

import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/categories_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/fakes.dart';
import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../helpers/events_test_data.dart';

void main() {
  late MockGetCategoriesUseCase mockUseCase;
  final tFailure = FakeAppFailure();
  final tCategories = [
    EventsTestData.tCategoryEntity,
  ];

  setUp(() {
    mockUseCase = MockGetCategoriesUseCase();
  });

  group('CategoriesNotifier', () {
    test(
      'Obtiene y retorna la lista de categorías desde el caso de uso',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Success(tCategories));

        final container = createContainer(
          overrides: [
            getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        final result = await container.read(categoriesProvider.future);

        expect(result, equals(tCategories));
        verify(() => mockUseCase()).called(1);
      },
    );

    test(
      'Refleja un estado de error cuando el caso de uso falla',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Error(tFailure));

        final container = createContainer(
          overrides: [
            getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        final done = Completer<void>();
        final sub = container.listen(categoriesProvider, (_, next) {
          if (next.error != null && !done.isCompleted) {
            done.complete();
          }
        });

        await done.future;

        final state = container.read(categoriesProvider);
        expect(state.error, isNotNull);
        expect(state.error, same(tFailure));

        sub.close();
      },
    );

    test(
      'Recarga los datos al llamar a reload',
      () async {
        when(() => mockUseCase()).thenAnswer((_) async => Success(tCategories));

        final container = createContainer(
          overrides: [
            getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await container.read(categoriesProvider.future);

        final tNewCategories = [
          EventsTestData.tCategoryEntity,
          EventsTestData.tCategoryEntity.copyWith(uid: 'cat2', name: 'Other'),
        ];
        when(() => mockUseCase()).thenAnswer((_) async => Success(tNewCategories));

        await container.read(categoriesProvider.notifier).reload();

        expect(
          await container.read(categoriesProvider.future),
          equals(tNewCategories),
        );
        verify(() => mockUseCase()).called(2);
      },
    );
  });
}
