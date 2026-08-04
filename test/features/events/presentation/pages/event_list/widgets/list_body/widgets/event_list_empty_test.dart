import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('EventListEmpty', () {
    testWidgets('renderiza AppEmptyState con los textos de "sin eventos"', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: EventListEmpty(),
        ),
      );

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text(EventsStrings.noEventsTitle), findsOneWidget);
      expect(find.text(EventsStrings.noEventsDescription), findsOneWidget);
      expect(find.text(EventsStrings.clearFiltersAction), findsOneWidget);
    });

    testWidgets('renderiza el icono correcto', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: EventListEmpty(),
        ),
      );

      expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
    });
  });
}
