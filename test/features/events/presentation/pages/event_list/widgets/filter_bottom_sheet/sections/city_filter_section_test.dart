import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/domain/entities/city_entity.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/city_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../../helpers/mocks.dart';
import '../../../../../../../../helpers/pump_app.dart';

void main() {
  late MockGetCitiesUseCase mockGetCitiesUseCase;

  const mockCities = [
    CityEntity(uid: '1', name: 'Asunción', department: 'Central'),
    CityEntity(uid: '2', name: 'Encarnación', department: 'Itapúa'),
  ];

  setUp(() {
    mockGetCitiesUseCase = MockGetCitiesUseCase();
    when(
      () => mockGetCitiesUseCase(),
    ).thenAnswer((_) async => const Success(mockCities));
  });

  group('CityFilterSection - Renderizado', () {
    testWidgets('Visualiza la lista de ciudades al cargar con éxito', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CityFilterSection(
            selectedCityId: null,
            onCitySelected: (id, name) {},
          ),
        ),
        overrides: [
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('Asunción'), findsOneWidget);
      expect(find.text('Encarnación'), findsOneWidget);
    });

    testWidgets('Resalta el chip de la ciudad que se encuentra seleccionada', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CityFilterSection(
            selectedCityId: '1',
            onCitySelected: (id, name) {},
          ),
        ),
        overrides: [
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
        ],
      );

      await tester.pumpAndSettle();

      final chipFinder = find.widgetWithText(AppChip, 'Asunción');
      final chip = tester.widget<AppChip>(chipFinder);
      expect(chip.selected, isTrue);

      final otherChipFinder = find.widgetWithText(AppChip, 'Encarnación');
      final otherChip = tester.widget<AppChip>(otherChipFinder);
      expect(otherChip.selected, isFalse);
    });

  });

  group('CityFilterSection - Interacción', () {
    testWidgets('Notifica la selección de una ciudad al ser presionada', (
      tester,
    ) async {
      String? selectedId;
      String? selectedName;

      await tester.pumpApp(
        Scaffold(
          body: CityFilterSection(
            selectedCityId: null,
            onCitySelected: (id, name) {
              selectedId = id;
              selectedName = name;
            },
          ),
        ),
        overrides: [
          getCitiesUseCaseProvider.overrideWithValue(mockGetCitiesUseCase),
        ],
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Encarnación'));

      expect(selectedId, '2');
      expect(selectedName, 'Encarnación');
    });
  });
}
