import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';
import '../../../../../../helpers/events_test_data.dart';

void main(){
  final event = EventsTestData.makeEventEntity(
    uid: '1',
    price: 50,
  );

  group('EventListItem', () {
    testWidgets('renderiza un EventCard con la información del evento', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EventListItem(event: event),
        ),
      );

      expect(find.byType(EventCard), findsOneWidget);
      expect(find.text(event.title), findsOneWidget);
      expect(find.text(event.cityName), findsOneWidget);
    });
  });
}
