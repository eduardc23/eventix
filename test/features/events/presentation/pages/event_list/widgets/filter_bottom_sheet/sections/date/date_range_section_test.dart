import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/date_range_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../../helpers/pump_app.dart';

void main() {
  group('DateRangeSection - Renderizado', () {
    testWidgets('Visualiza el chip con la etiqueta predeterminada cuando no hay un rango definido', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: DateRangeSection(
            dateFilter: null,
            onFilterChanged: (_) {},
            onFilterCleared: () {},
          ),
        ),
      );

      expect(find.text('Seleccionar rango'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('Muestra el estado seleccionado cuando existe un filtro de rango activo', (
      tester,
    ) async {
      final from = DateTime(2026, 7, 12);
      final to = DateTime(2026, 7, 15);

      await tester.pumpApp(
        Scaffold(
          body: DateRangeSection(
            dateFilter: DateFilter.range(from: from, to: to),
            onFilterChanged: (_) {},
            onFilterCleared: () {},
          ),
        ),
      );

      final chip = tester.widget<AppChip>(find.byType(AppChip));
      expect(chip.selected, isTrue);
    });

  });

  group('DateRangeSection - Interacción', () {
    testWidgets(
      'Notifica la limpieza del filtro al presionar un rango previamente seleccionado',
      (tester) async {
        var cleared = false;
        final from = DateTime(2026, 7, 12);
        final to = DateTime(2026, 7, 15);

        await tester.pumpApp(
          Scaffold(
            body: DateRangeSection(
              dateFilter: DateFilter.range(from: from, to: to),
              onFilterChanged: (_) {},
              onFilterCleared: () => cleared = true,
            ),
          ),
        );

        await tester.tap(find.byType(AppChip));
        expect(cleared, isTrue);
      },
    );
  });
}
