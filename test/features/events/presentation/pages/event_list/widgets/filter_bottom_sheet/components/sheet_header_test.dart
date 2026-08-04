
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/filter_bottom_sheet/components/sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('SheetHeader - Renderizado', () {
    testWidgets('Visualiza el título y la acción de reinicio de filtros', (tester) async {
      await tester.pumpApp(const Scaffold(body: SheetHeader()));

      expect(find.text(EventsStrings.filterTitle), findsOneWidget);
      expect(find.text(EventsStrings.resetFilters), findsOneWidget);
    });
  });
}
