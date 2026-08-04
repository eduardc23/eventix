import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/enums/event_booking_action_enum.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_bottom_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EventDetailBottomBar - Renderizado', () {
    testWidgets('muestra el precio total y el precio del evento', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailBottomBar(
          priceLabel: 'Gratis',
          action: EventBookingAction.bookNow,
          onPressed: null,
        ),
      );

      expect(find.text(EventsStrings.totalPrice), findsOneWidget);
      expect(find.text('Gratis'), findsOneWidget);
    });

    testWidgets('muestra el botón con la etiqueta del action', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const EventDetailBottomBar(
          priceLabel: '\$25000',
          action: EventBookingAction.payNow,
          onPressed: null,
        ),
      );

      expect(find.bySubtype<AppButton>(), findsOneWidget);
      expect(find.text(EventsStrings.payNow), findsOneWidget);
    });
  });

  group('EventDetailBottomBar - Interacción', () {
    testWidgets('llama al callback al pulsar el botón', (
      WidgetTester tester,
    ) async {
      var pressed = false;

      await tester.pumpApp(
        EventDetailBottomBar(
          priceLabel: '\$20000',
          action: EventBookingAction.bookNow,
          onPressed: () => pressed = true,
        ),
      );

      await tester.tap(find.text(EventsStrings.bookNow));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
