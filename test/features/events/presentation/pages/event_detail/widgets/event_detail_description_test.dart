import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_description.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailDescription - Renderizado', () {
    testWidgets('muestra el título “Acerca del evento” y la descripción', (
      WidgetTester tester,
    ) async {
      const description = 'Descripción del evento';

      await tester.pumpApp(
        const EventDetailDescription(description: description),
      );

      expect(find.text(EventsStrings.aboutEvent), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });
  });
}
