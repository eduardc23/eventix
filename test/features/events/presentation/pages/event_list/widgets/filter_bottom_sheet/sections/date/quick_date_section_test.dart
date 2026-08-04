import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/presentation/extensions/quick_date_option_display.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/quick_date_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../../helpers/pump_app.dart';

void main() {
  group('QuickDateSection - Renderizado', () {
    testWidgets('Visualiza todas las opciones de filtrado rápido por fecha', (tester) async {
      await tester.pumpApp(
        Scaffold(body: QuickDateSection(selected: null, onSelected: (_) {})),
      );

      for (final option in QuickDateOption.values) {
        expect(find.text(option.label), findsOneWidget);
      }
    });

    testWidgets('Resalta la opción que se encuentra actualmente seleccionada', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: QuickDateSection(
            selected: QuickDateOption.today,
            onSelected: (_) {},
          ),
        ),
      );

      final chipToday = tester.widget<AppChip>(
        find.widgetWithText(AppChip, QuickDateOption.today.label),
      );
      expect(chipToday.selected, isTrue);

      final chipThisWeek = tester.widget<AppChip>(
        find.widgetWithText(AppChip, QuickDateOption.thisWeek.label),
      );
      expect(chipThisWeek.selected, isFalse);
    });

  });

  group('QuickDateSection - Interacción', () {
    testWidgets('Notifica la selección de una opción rápida al ser presionada', (tester) async {
      QuickDateOption? selectedOption;

      await tester.pumpApp(
        Scaffold(
          body: QuickDateSection(
            selected: null,
            onSelected: (option) => selectedOption = option,
          ),
        ),
      );

      await tester.tap(find.text(QuickDateOption.thisWeekend.label));

      expect(selectedOption, QuickDateOption.thisWeekend);
    });
  });
}
