import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_capacity_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailCapacityIndicator - Renderizado', () {
    testWidgets('muestra el título de disponibilidad y los lugares restantes', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailCapacityIndicator(
          capacityPercentage: 0.6,
          availableSpots: 12,
        ),
      );

      expect(find.text(EventsStrings.availability), findsOneWidget);
      expect(find.text(EventsStrings.remainingSpots(12)), findsOneWidget);
    });

    testWidgets('renderiza la barra de progreso con el valor indicado', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailCapacityIndicator(
          capacityPercentage: 0.6,
          availableSpots: 12,
        ),
      );

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressIndicator.value, 0.6);
    });

    testWidgets('limita el valor de la barra de progreso entre 0 y 1', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailCapacityIndicator(
          capacityPercentage: 1.8,
          availableSpots: 3,
        ),
      );

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progressIndicator.value, 1.0);
    });
  });
}
