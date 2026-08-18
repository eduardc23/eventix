import 'package:eventix/core/router/app_routes.dart';
import 'package:eventix/features/events/presentation/constants/events_strings.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/event_detail_page.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_app_bar.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_bottom_bar.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_capacity_indicator.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_description.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_header.dart';
import 'package:eventix/features/events/presentation/pages/event_detail/widgets/event_detail_info_cards.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/accessibility_helper.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../helpers/events_test_data.dart';

void main() {
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    registerFallbackValue(EventsTestData.makeEventEntity());
  });

  setUp(() {
    mockGoRouter = MockGoRouter();
  });

  group('EventDetailPage - Visualización', () {
    testWidgets('Se muestran todos los componentes obligatorios del detalle', (
      tester,
    ) async {
      final event = EventsTestData.makeEventEntity();
      await tester.pumpApp(
        InheritedGoRouter(
          goRouter: mockGoRouter,
          child: EventDetailPage(event: event),
        ),
      );

      expect(find.byType(EventDetailAppBar), findsOneWidget);
      expect(find.byType(EventDetailHeader), findsOneWidget);
      expect(find.byType(EventDetailInfoCards), findsOneWidget);
      expect(find.byType(EventDetailCapacityIndicator), findsOneWidget);
      expect(find.byType(EventDetailDescription), findsOneWidget);
      expect(find.byType(EventDetailBottomBar), findsOneWidget);
    });
  });

  group('EventDetailPage - Navegación', () {
    testWidgets(
      'El botón de acción redirige a la reserva si el evento es reservable',
      (tester) async {
        final event =
            EventsTestData.makeEventEntity(); // isBookable = true por defecto
        await tester.pumpApp(
          InheritedGoRouter(
            goRouter: mockGoRouter,
            child: EventDetailPage(event: event),
          ),
        );

        when(
          () => mockGoRouter.push(any(), extra: any(named: 'extra')),
        ).thenAnswer((_) async => null);

        // El botón muestra 'Pagar ahora' para eventos con precio > 0
        final bookingButton = find.text(EventsStrings.payNow);

        await tester.ensureVisible(bookingButton);
        await tester.tap(bookingButton);
        await tester.pumpAndSettle();

        verify(
          () => mockGoRouter.push(AppRoutes.eventBooking, extra: event),
        ).called(1);
      },
    );

    testWidgets(
      'El botón de acción está deshabilitado y no navega si el evento no es reservable',
      (tester) async {
        final event = EventsTestData.makeEventEntity(availableSpots: 0);
        await tester.pumpApp(
          InheritedGoRouter(
            goRouter: mockGoRouter,
            child: EventDetailPage(event: event),
          ),
        );

        // Si está agotado, el botón mostrará 'Agotado'
        final bookingButton = find.text(EventsStrings.soldOut);

        await tester.tap(bookingButton);
        await tester.pump();

        verifyNever(() => mockGoRouter.push(any(), extra: any(named: 'extra')));

        final bottomBarWidget = tester.widget<EventDetailBottomBar>(
          find.byType(EventDetailBottomBar),
        );
        expect(bottomBarWidget.onPressed, isNull);
      },
    );
  });

  testWidgets('EventDetailPage cumple guías de accesibilidad', (tester) async {
    final event = EventsTestData.makeEventEntity();
    await tester.pumpApp(
      InheritedGoRouter(
        goRouter: mockGoRouter,
        child: EventDetailPage(event: event),
      ),
    );
    await tester.pumpAndSettle();
    await tester.checkAccessibility();
  });

  testWidgets('EventDetailPage cumple guías de accesibilidad cuando está agotado', (tester) async {
    final event = EventsTestData.makeEventEntity(availableSpots: 0);
    await tester.pumpApp(
      InheritedGoRouter(
        goRouter: mockGoRouter,
        child: EventDetailPage(event: event),
      ),
    );
    await tester.pumpAndSettle();
    await tester.checkAccessibility();
  });
}
