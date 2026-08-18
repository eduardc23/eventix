import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/accessibility_helper.dart';
import '../../../../../../../../helpers/pump_app.dart';
import '../../../../../../../../helpers/test_app_config.dart';

void main() {
  group('EventListEmpty', () {
    testWidgets('renderiza AppEmptyState con los textos de "sin eventos"', (
      tester,
    ) async {
      await tester.pumpApp(const Scaffold(body: EventListEmpty()));

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(
        find.text(testAppConfig.emptyMessages.events.title),
        findsOneWidget,
      );
      expect(
        find.text(testAppConfig.emptyMessages.events.description),
        findsOneWidget,
      );
      expect(find.text(EventsStrings.clearFiltersAction), findsOneWidget);
    });

    testWidgets('renderiza el icono correcto', (tester) async {
      await tester.pumpApp(const Scaffold(body: EventListEmpty()));

      expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
    });

    testWidgets('EventListEmpty cumple guías de accesibilidad', (tester) async {
      await tester.pumpApp(const Scaffold(body: EventListEmpty()));
      await tester.pumpAndSettle();
      await tester.checkAccessibility();
    });
  });
}
