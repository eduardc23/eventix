import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/di/booking_di_providers.dart';
import 'package:eventix/features/booking/domain/entities/create_booking_params.dart';
import 'package:eventix/features/booking/presentation/constants/booking_strings.dart';
import 'package:eventix/features/booking/presentation/pages/booking/booking_page.dart';
import 'package:eventix/features/booking/presentation/pages/booking/widgets/booking_success_dialog.dart';
import 'package:eventix/features/booking/presentation/pages/booking/widgets/quantity_selector.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../events/helpers/events_test_data.dart';

void main() {
  late MockCreateBookingUseCase mockUseCase;
  late EventEntity testEvent;

  setUp(() {
    mockUseCase = MockCreateBookingUseCase();
    testEvent = EventsTestData.makeEventEntity(price: 100, availableSpots: 5);

    registerFallbackValue(
      CreateBookingParams(
        userId: 'user-123',
        eventId: testEvent.uid,
        eventTitle: testEvent.title,
        eventImageUrl: testEvent.imageUrl,
        eventDate: testEvent.date,
        tickets: 1,
        totalPrice: 100,
      ),
    );
  });

  group('BookingPage - Estado Inicial', () {
    testWidgets('Presenta la vista inicial con los datos básicos de reserva', (tester) async {
      await tester.pumpApp(
        BookingPage(event: testEvent),
        overrides: [
          currentUserIdProvider.overrideWithValue('user-123'),
          createBookingUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      expect(find.text(BookingStrings.checkoutTitle), findsOneWidget);
      expect(find.byType(QuantitySelector), findsOneWidget);
      expect(find.text(BookingStrings.payNow), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('BookingPage - Interacciones', () {
    testWidgets('Incrementa la cantidad de tickets al pulsar el botón de suma', (tester) async {
      await tester.pumpApp(
        BookingPage(event: testEvent),
        overrides: [
          currentUserIdProvider.overrideWithValue('user-123'),
          createBookingUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });
  });

  group('BookingPage - Flujo de Pago', () {
    testWidgets(
      'Visualiza el diálogo de éxito cuando el proceso de reserva finaliza correctamente',
      (tester) async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Success(null));

        await tester.pumpApp(
          BookingPage(event: testEvent),
          overrides: [
            currentUserIdProvider.overrideWithValue('user-123'),
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await tester.ensureVisible(find.text(BookingStrings.payNow));
        await tester.pump();
        await tester.tap(find.text(BookingStrings.payNow));
        await tester.pumpAndSettle();

        expect(find.byType(BookingSuccessDialog), findsOneWidget);
      },
    );

    testWidgets('Muestra un mensaje de error cuando la creación de la reserva falla', (tester) async {
      final failure = CoreFailure.server(message: 'Booking failed');
      when(() => mockUseCase(any())).thenAnswer((_) async => Error(failure));

      await tester.pumpApp(
        BookingPage(event: testEvent),
        overrides: [
          currentUserIdProvider.overrideWithValue('user-123'),
          createBookingUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      await tester.ensureVisible(find.text(BookingStrings.payNow));
      await tester.pump();
      await tester.tap(find.text(BookingStrings.payNow));
      await tester.pumpAndSettle();

      expect(find.text('Booking failed'), findsOneWidget);
    });
  });
}
