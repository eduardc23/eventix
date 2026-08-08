import 'package:eventix/features/events/domain/enums/quick_date_option_enum.dart';
import 'package:eventix/features/events/domain/filters/event_filter.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/date_filter_section.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/date_range_section.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/sections/date/quick_date_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../../helpers/pump_app.dart';

void main() {
  group('DateFilterSection - Renderizado', () {
    testWidgets('Visualiza los componentes QuickDateSection y DateRangeSection', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: DateFilterSection(
            selectedDate: null,
            onQuickOptionSelected: (_) {},
            onRangeSelected: (f, t) {},
            onRangeCleared: () {},
            dateRangeMaxDays: 0,
          ),
        ),
      );

      expect(find.byType(QuickDateSection), findsOneWidget);
      expect(find.byType(DateRangeSection), findsOneWidget);
    });

    testWidgets('Transfiere correctamente la opción rápida activa a QuickDateSection', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: DateFilterSection(
            selectedDate: DateFilter.quick(option: QuickDateOption.today),
            onQuickOptionSelected: (_) {},
            onRangeSelected: (f, t) {},
            onRangeCleared: () {},
            dateRangeMaxDays: 0,
          ),
        ),
      );

      final quickSection = tester.widget<QuickDateSection>(
        find.byType(QuickDateSection),
      );
      expect(quickSection.selected, QuickDateOption.today);
    });
  });
}
