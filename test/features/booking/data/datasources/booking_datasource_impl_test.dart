import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/features/booking/data/constants/booking_firestore_constants.dart';
import 'package:eventix/features/booking/data/datasource/booking_datasource_impl.dart';
import 'package:eventix/features/booking/data/exceptions/booking_exception.dart';
import 'package:eventix/features/booking/data/models/booking_model.dart';
import 'package:eventix/features/events/data/constants/events_firestore_constants.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../events/helpers/events_json_factories.dart';
import '../../helpers/booking_json_factories.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseExceptionMapper mockFirebaseMapper;

  late BookingDataSourceImpl datasource;

  // Datos de prueba centralizados
  final tParams = BookingTestData.tCreateBookingParams;
  final tBookingId = '${tParams.userId}_${tParams.eventId}';
  final tUserId = tParams.userId;
  final tDate = BookingTestData.tDate;

  final tBookingMap = BookingJsonFactories.createBookingJson(
    userId: tParams.userId,
    eventId: tParams.eventId,
    eventTitle: tParams.eventTitle,
    eventImageUrl: tParams.eventImageUrl,
    eventDate: tParams.eventDate,
    tickets: tParams.tickets,
    totalPrice: tParams.totalPrice,
    createdAt: tDate,
    updatedAt: tDate,
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirebaseMapper = MockFirebaseExceptionMapper();

    datasource = BookingDataSourceImpl(
      firestore: fakeFirestore,
      firebaseMapper: mockFirebaseMapper,
    );
  });

  group('[BookingDataSourceImpl] - Creación de Reservas', () {
    Future<void> seedEvent({required int availableSpots}) {
      return fakeFirestore
          .collection(EventsFirestoreConstants.eventsCollection)
          .doc(tParams.eventId)
          .set({
            ...EventsJsonFactories.createEventJson(
              uid: tParams.eventId,
              availableSpots: availableSpots,
              date: tParams.eventDate,
            ),
            EventsFirestoreConstants.uidField: tParams.eventId,
          });
    }

    test(
      'La creación de una reserva nueva descuenta los cupos disponibles correctamente',
      () async {
        await seedEvent(availableSpots: 10);

        await expectLater(datasource.createBooking(tParams), completes);

        final updatedEvent = await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc(tParams.eventId)
            .get();
        final booking = await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc(tBookingId)
            .get();

        expect(
          updatedEvent
              .data()![EventsFirestoreConstants.eventAvailableSpotsField],
          10 - tParams.tickets,
        );
        expect(booking.exists, isTrue);
        expect(
          booking.data()![BookingFirestoreConstants.userIdField],
          tParams.userId,
        );
      },
    );

    test(
      'La actualización de una reserva existente ajusta los cupos proporcionalmente basándose en el delta',
      () async {
        await seedEvent(availableSpots: 5);
        await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc(tBookingId)
            .set({
              ...tBookingMap,
              BookingFirestoreConstants.ticketsField: 1,
              BookingFirestoreConstants.createdAtField: Timestamp.fromDate(
                DateTime(2026, 7, 30),
              ),
            });

        await expectLater(datasource.createBooking(tParams), completes);

        final updatedEvent = await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc(tParams.eventId)
            .get();
        final updatedBooking = await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc(tBookingId)
            .get();

        expect(
          updatedEvent
              .data()![EventsFirestoreConstants.eventAvailableSpotsField],
          5 - (tParams.tickets - 1),
        );
        expect(
          updatedBooking.data()![BookingFirestoreConstants.ticketsField],
          tParams.tickets,
        );
      },
    );

    test(
      'Se lanza NoSpotsAvailableException si la cantidad solicitada supera la disponibilidad',
      () async {
        await seedEvent(availableSpots: tParams.tickets - 1);

        expect(
          () => datasource.createBooking(tParams),
          throwsA(isA<NoSpotsAvailableException>()),
        );

        final eventAfter = await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc(tParams.eventId)
            .get();
        final bookingAfter = await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc(tBookingId)
            .get();

        expect(
          eventAfter.data()![EventsFirestoreConstants.eventAvailableSpotsField],
          tParams.tickets - 1,
        );
        expect(bookingAfter.exists, isFalse);
      },
    );
  });

  group('[BookingDataSourceImpl] - Consulta de Reservas', () {
    test(
      'Se retorna una lista de modelos cuando existen registros en el servidor',
      () async {
        await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc('doc_id_123')
            .set(tBookingMap);

        final result = await datasource.getBookingsByUser(userId: tUserId);

        expect(result, isA<List<BookingModel>>());
        expect(result.length, 1);
        expect(result.first.uid, 'doc_id_123');
      },
    );

    test(
      'Se retorna una lista vacía si el usuario no tiene reservas asociadas',
      () async {
        await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc('other_user_doc')
            .set(BookingJsonFactories.createBookingJson(userId: 'other-user'));

        final result = await datasource.getBookingsByUser(userId: tUserId);

        expect(result, isEmpty);
      },
    );

    test(
      'Las reservas se retornan ordenadas por fecha de evento descendente',
      () async {
        await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc('booking_old')
            .set(
              BookingJsonFactories.createBookingJson(
                userId: tUserId,
                eventDate: DateTime(2026, 10, 1),
              ),
            );
        await fakeFirestore
            .collection(BookingFirestoreConstants.bookingsCollection)
            .doc('booking_new')
            .set(
              BookingJsonFactories.createBookingJson(
                userId: tUserId,
                eventDate: DateTime(2026, 10, 31),
              ),
            );

        final result = await datasource.getBookingsByUser(userId: tUserId);

        expect(result.length, 2);
        expect(result.first.uid, 'booking_new');
        expect(result.last.uid, 'booking_old');
      },
    );
  });
}
