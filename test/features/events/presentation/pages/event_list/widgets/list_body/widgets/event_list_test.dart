import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/pump_app.dart';
import '../../../../../../helpers/events_test_data.dart';

void main() {
  final events = [
    EventsTestData.makeEventEntity(uid: '1', title: 'Evento 1'),
    EventsTestData.makeEventEntity(uid: '2', title: 'Evento 2'),
  ];

  group('EventList', () {
    testWidgets('renderiza una lista de eventos', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EventList(events: events),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(EventListItem), findsNWidgets(2));
      expect(find.text('Evento 1'), findsOneWidget);
      expect(find.text('Evento 2'), findsOneWidget);
    });

    testWidgets('tiene scroll habilitado incluso si hay pocos elementos (physics)', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EventList(events: events),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.physics, isA<AlwaysScrollableScrollPhysics>());
    });
  });
}
