import 'package:eventix/features/events/presentation/pages/event_detail/widgets/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('InfoTile - Renderizado', () {
    testWidgets('muestra el título y el subtítulo del tile', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: Row(
            children: [
              InfoTile(
                icon: Icons.calendar_today_outlined,
                title: '12 Jul 2026',
                subtitle: '20:00', semanticLabel: '',
              ),
            ],
          ),
        ),
      );

      expect(find.text('12 Jul 2026'), findsOneWidget);
      expect(find.text('20:00'), findsOneWidget);
    });

    testWidgets('renderiza el icono indicado', (WidgetTester tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: Row(
            children: [
              InfoTile(
                icon: Icons.location_on_outlined,
                title: 'Madrid',
                subtitle: 'Ubicación', semanticLabel: '',
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });
  });
}
