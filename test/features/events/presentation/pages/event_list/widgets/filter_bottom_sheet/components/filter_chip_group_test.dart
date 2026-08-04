import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/components/filter_chip_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('FilterChipGroup - Renderizado', () {
    testWidgets('Visualiza la lista de elementos utilizando el constructor de ítems', (
      tester,
    ) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpApp(
        Scaffold(
          body: FilterChipGroup<String>(
            items: items,
            itemBuilder: (item) => AppChip.filter(
              label: item,
              selected: false,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
      expect(find.byType(AppChip), findsNWidgets(3));
    });

    testWidgets('Organiza los elementos utilizando un componente de tipo Wrap', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterChipGroup<String>(
            items: const ['A'],
            itemBuilder: (item) => Text(item),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}
