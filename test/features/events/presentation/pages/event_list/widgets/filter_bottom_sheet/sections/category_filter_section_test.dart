import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/domain/entities/category_entity.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/category_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../../helpers/mocks.dart';
import '../../../../../../../../helpers/pump_app.dart';

void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;

  const mockCategories = [
    CategoryEntity(uid: '1', name: 'Música'),
    CategoryEntity(uid: '2', name: 'Deportes'),
  ];

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    when(
      () => mockGetCategoriesUseCase(),
    ).thenAnswer((_) async => const Success(mockCategories));
  });

  group('CategoryFilterSection - Renderizado', () {
    testWidgets('Visualiza la lista de categorías al cargar con éxito', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CategoryFilterSection(
            selectedCategoryId: null,
            onCategorySelected: (id, name) {},
          ),
        ),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(
            mockGetCategoriesUseCase,
          ),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('Música'), findsOneWidget);
      expect(find.text('Deportes'), findsOneWidget);
    });

    testWidgets('Resalta el chip de la categoría que se encuentra seleccionada', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CategoryFilterSection(
            selectedCategoryId: '2',
            onCategorySelected: (id, name) {},
          ),
        ),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(
            mockGetCategoriesUseCase,
          ),
        ],
      );

      await tester.pumpAndSettle();

      final chipMusic = tester.widget<AppChip>(
        find.widgetWithText(AppChip, 'Música'),
      );
      final chipSports = tester.widget<AppChip>(
        find.widgetWithText(AppChip, 'Deportes'),
      );

      expect(chipMusic.selected, isFalse);
      expect(chipSports.selected, isTrue);
    });

  });

  group('CategoryFilterSection - Interacción', () {
    testWidgets('Notifica la selección de una categoría al ser presionada', (
      tester,
    ) async {
      String? selectedId;
      String? selectedName;

      await tester.pumpApp(
        Scaffold(
          body: CategoryFilterSection(
            selectedCategoryId: null,
            onCategorySelected: (id, name) {
              selectedId = id;
              selectedName = name;
            },
          ),
        ),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(
            mockGetCategoriesUseCase,
          ),
        ],
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Música'));

      expect(selectedId, '1');
      expect(selectedName, 'Música');
    });
  });
}
