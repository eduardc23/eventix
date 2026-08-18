import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/extensions/event_failure_message_extension.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../../../helpers/accessibility_helper.dart';
import '../../../../../../../../helpers/pump_app.dart';

void main() {
  group('EventListError', () {
    final failure = CoreFailure.network();

    testWidgets(
      'renderiza AppEmptyState con el título de error y el mensaje de la falla',
      (tester) async {
        await tester.pumpApp(Scaffold(body: EventListError(failure: failure)));

        expect(find.byType(AppEmptyState), findsOneWidget);
        expect(find.text(EventsStrings.errorTitle), findsOneWidget);
        expect(find.text(failure.toEventMessage), findsOneWidget);
        expect(find.text(EventsStrings.retryAction), findsOneWidget);
      },
    );

    testWidgets('renderiza el icono de wifi off', (tester) async {
      await tester.pumpApp(Scaffold(body: EventListError(failure: failure)));

      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
    });

    testWidgets('EventListError cumple guías de accesibilidad', (tester) async {
      await tester.pumpApp(Scaffold(body: EventListError(failure: failure)));
      await tester.pumpAndSettle();
      await tester.checkAccessibility();
    });
  });
}
