import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/filter_list.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/category_filter_section.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/city_filter_section.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/date_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/pump_app.dart';

void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetCitiesUseCase mockGetCitiesUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetCitiesUseCase = MockGetCitiesUseCase();

    when(() => mockGetCategoriesUseCase()).thenAnswer((_) async => const Success([]));
    when(() => mockGetCitiesUseCase()).thenAnswer((_) async => const Success([]));
  });

  group('FilterList - Renderizado', () {
    testWidgets('Visualiza todas las secciones de filtros', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterList(scrollController: ScrollController()),
        ),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(mockGetCategoriesUseCase),
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
          draftEventFiltersProvider.overrideWith(MockDraftEventFilters.new),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.byType(CategoryFilterSection), findsOneWidget);
      expect(find.byType(CityFilterSection), findsOneWidget);
      expect(find.byType(DateFilterSection), findsOneWidget);
    });

    testWidgets('Muestra los títulos correspondientes a cada grupo de filtros', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterList(scrollController: ScrollController()),
        ),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(mockGetCategoriesUseCase),
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('Categoría'), findsOneWidget);
      expect(find.text('Ciudad'), findsOneWidget);
      expect(find.text('Fecha'), findsOneWidget);
    });
  });
}
