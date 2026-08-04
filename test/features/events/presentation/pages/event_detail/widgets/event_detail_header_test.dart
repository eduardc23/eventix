import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailHeader - Renderizado', () {
    testWidgets('muestra la categoría y el título del evento', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: EventDetailHeader(
            categoryName: 'Música',
            title: 'Festival de verano',
          ),
        ),
      );

      expect(find.text('Música'), findsOneWidget);
      expect(find.text('Festival de verano'), findsOneWidget);
    });

    testWidgets('renderiza un AppChip con la categoría del evento', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: EventDetailHeader(
            categoryName: 'Deportes',
            title: 'Carrera nocturna',
          ),
        ),
      );

      expect(find.bySubtype<AppChip>(), findsOneWidget);
    });
  });
}
