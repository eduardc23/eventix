import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_info_cards.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailInfoCards - Renderizado', () {
    testWidgets('muestra la fecha, la hora y la ciudad', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailInfoCards(
          formattedDate: '12 Jul 2026',
          formattedTime: '20:00',
          cityName: 'Madrid',
        ),
      );

      expect(find.text('12 Jul 2026'), findsOneWidget);
      expect(find.text('20:00'), findsOneWidget);
      expect(find.text('Madrid'), findsOneWidget);
    });

    testWidgets('muestra el subtítulo de ubicación', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailInfoCards(
          formattedDate: '12 Jul 2026',
          formattedTime: '20:00',
          cityName: 'Madrid',
        ),
      );

      expect(find.text(EventsStrings.location), findsOneWidget);
    });
  });
}
