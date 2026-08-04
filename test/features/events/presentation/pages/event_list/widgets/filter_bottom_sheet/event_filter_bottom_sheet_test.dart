import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/providers/filters/event_filters_providers.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/event_filter_bottom_sheet.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/filter_list.dart';
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

    when(
      () => mockGetCategoriesUseCase(),
    ).thenAnswer((_) async => const Success([]));
    when(
      () => mockGetCitiesUseCase(),
    ).thenAnswer((_) async => const Success([]));
  });

  group('EventFilterBottomSheet - Renderizado', () {
    testWidgets('Visualiza el contenido completo del bottom sheet', (
      tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(body: EventFilterBottomSheet()),
        overrides: [
          getCategoriesUseCaseProvider.overrideWithValue(
            mockGetCategoriesUseCase,
          ),
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
          draftEventFiltersProvider.overrideWith(MockDraftEventFilters.new),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
      expect(find.byType(FilterList), findsOneWidget);
      expect(find.text(EventsStrings.applyFilters), findsOneWidget);
    });
  });
}
