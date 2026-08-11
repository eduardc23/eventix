import 'dart:async';

import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/domain/entities/category_entity.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/categories_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/fakes.dart';
import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../../../helpers/test_app_config.dart';
import '../../../../../helpers/events_test_data.dart';

void main() {
  late MockGetCategoriesUseCase mockUseCase;
  final tFailure = FakeAppFailure();
  final tCategories = [EventsTestData.tCategoryEntity];
  final tDefaultCategories = List<CategoryEntity>.unmodifiable(
    testAppConfig.defaults.categories.map(
      (category) => CategoryEntity(uid: category.uid, name: category.name),
    ),
  );

  setUp(() {
    mockUseCase = MockGetCategoriesUseCase();
  });

  group('CategoriesNotifier', () {
    test(
      'Expone categorías locales y luego las reemplaza con las del backend',
      () async {
        final completer = Completer<Result<List<CategoryEntity>, AppFailure>>();
        when(() => mockUseCase()).thenAnswer((_) => completer.future);

        final container = createContainer(
          overrides: [
            appConfigProvider.overrideWithValue(testAppConfig),
            getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        expect(
          container.read(categoriesProvider).requireValue,
          equals(tDefaultCategories),
        );

        completer.complete(Success(tCategories));
        await Future<void>.delayed(Duration.zero);

        expect(
          container.read(categoriesProvider).requireValue,
          equals(tCategories),
        );
        verify(() => mockUseCase()).called(1);
      },
    );

    test(
      'Mantiene las categorías locales si la carga inicial remota falla',
      () async {
        final completer = Completer<Result<List<CategoryEntity>, AppFailure>>();
        when(() => mockUseCase()).thenAnswer((_) => completer.future);

        final container = createContainer(
          overrides: [
            appConfigProvider.overrideWithValue(testAppConfig),
            getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        expect(
          container.read(categoriesProvider).requireValue,
          equals(tDefaultCategories),
        );

        completer.complete(Error(tFailure));
        await Future<void>.delayed(Duration.zero);

        final state = container.read(categoriesProvider);
        expect(state.requireValue, equals(tDefaultCategories));
      },
    );

    test('Recarga los datos al llamar a reload', () async {
      when(() => mockUseCase()).thenAnswer((_) async => Success(tCategories));

      final container = createContainer(
        overrides: [
          appConfigProvider.overrideWithValue(testAppConfig),
          getCategoriesUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      final initialLoadDone = Completer<void>();
      final sub = container.listen(categoriesProvider, (_, next) {
        if (next.value == tCategories && !initialLoadDone.isCompleted) {
          initialLoadDone.complete();
        }
      });

      await initialLoadDone.future;
      expect(
        container.read(categoriesProvider).requireValue,
        equals(tCategories),
      );

      final tNewCategories = [
        EventsTestData.tCategoryEntity,
        EventsTestData.tCategoryEntity.copyWith(uid: 'cat2', name: 'Other'),
      ];
      when(
        () => mockUseCase(),
      ).thenAnswer((_) async => Success(tNewCategories));

      await container.read(categoriesProvider.notifier).reload();

      expect(
        container.read(categoriesProvider).requireValue,
        equals(tNewCategories),
      );
      verify(() => mockUseCase()).called(2);
      sub.close();
    });
  });
}
