import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_info_cards.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailInfoCards - Renderizado', () {
    testWidgets('muestra la fecha, la hora y la ciudad', (
      WidgetTester tester,
    ) async {
      final testDate = DateTime(2026, 7, 12, 20); // 12 de julio de 2026, 20:00
      await tester.pumpApp(
        EventDetailInfoCards(
          date: testDate,
          cityName: 'Madrid',
        ),
      );

      expect(find.text('dom 12 jul'), findsOneWidget);
      expect(find.text('20:00 h'), findsOneWidget);
      expect(find.text('Madrid'), findsOneWidget);
    });

    testWidgets('muestra el subtítulo de ubicación', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        EventDetailInfoCards(
          date: DateTime(2026, 7, 12, 20),
          cityName: 'Madrid',
        ),
      );

      expect(find.text(EventsStrings.location), findsOneWidget);
    });
  });
}
