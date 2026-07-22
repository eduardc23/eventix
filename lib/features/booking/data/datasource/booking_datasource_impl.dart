import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/mappers/firebase_exception_mapper.dart';
import '../../../../core/data/utils/datasource_executor.dart';
import '../../../events/data/constants/events_firestore_constants.dart';
import '../../domain/entities/create_booking_params.dart';
import '../constants/booking_firestore_constants.dart';
import '../exceptions/booking_exception.dart';
import '../models/booking_model.dart';
import 'booking_datasource.dart';

class BookingDataSourceImpl with DatasourceExecutor implements BookingDataSource {
  const BookingDataSourceImpl({
    required this._firestore,
    required this._firebaseMapper,
  });

  final FirebaseFirestore _firestore;
  final FirebaseExceptionMapper _firebaseMapper;

  // Ref centralizado con convertidor
  CollectionReference<BookingModel> get _bookingsCollection => _firestore
      .collection(BookingFirestoreConstants.bookingsCollection)
      .withConverter<BookingModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['uid'] = snapshot.id;
          return BookingModel.fromJson(data);
        },
        toFirestore: (model, _) {
          final json = model.toJson();
          json.remove('uid');
          return json;
        },
      );

  DocumentReference<Map<String, dynamic>> _eventRef(String eventId) =>
      _firestore
          .collection(EventsFirestoreConstants.eventsCollection)
          .doc(eventId);

  @override
  Future<void> createBooking(
    CreateBookingParams params,
  ) =>
      execute(
        () async {
          // 1. ID compuesto en lugar de auto-generado
          final bookingId = '${params.userId}_${params.eventId}';
          final bookingRef = _firestore
              .collection(BookingFirestoreConstants.bookingsCollection)
              .doc(bookingId);

          await _firestore.runTransaction((tx) async {
            final eventSnap = await tx.get(_eventRef(params.eventId));
            final availableSpots = eventSnap.data()![
                EventsFirestoreConstants.eventAvailableSpotsField] as int;

            // 2. Leer booking existente dentro de la misma transacción
            final existingBookingSnap = await tx.get(bookingRef);
            final previousTickets = existingBookingSnap.exists
                ? existingBookingSnap
                    .data()![BookingFirestoreConstants.ticketsField] as int
                : 0;

            // 3. Calcular delta real de cupos
            final delta = params.tickets - previousTickets;

            // 4. Validar cupos solo por el delta
            if (availableSpots < delta) {
              throw const NoSpotsAvailableException();
            }

            // 5. Descontar solo el delta (puede ser negativo si reduce tiquetes)
            tx.update(_eventRef(params.eventId), {
              EventsFirestoreConstants.eventAvailableSpotsField:
                  availableSpots - delta,
            });

            // 6. set() crea o sobreescribe — garantiza unicidad
            tx.set(bookingRef, {
              BookingFirestoreConstants.userIdField: params.userId,
              BookingFirestoreConstants.eventIdField: params.eventId,
              BookingFirestoreConstants.eventTitleField: params.eventTitle,
              BookingFirestoreConstants.eventImageUrlField:
                  params.eventImageUrl,
              BookingFirestoreConstants.eventDateField:
                  Timestamp.fromDate(params.eventDate),
              BookingFirestoreConstants.ticketsField: params.tickets,
              BookingFirestoreConstants.totalPriceField: params.totalPrice,
              BookingFirestoreConstants.createdAtField:
                  existingBookingSnap.exists
                      ? existingBookingSnap
                          .data()![BookingFirestoreConstants.createdAtField]
                      : FieldValue.serverTimestamp(),
              BookingFirestoreConstants.updatedAtField:
                  FieldValue.serverTimestamp(),
            });
          });
        },
        firebaseMapper: _firebaseMapper,
        mapException: (e) => e is BookingException ? e : null,
      );

  @override
  Future<List<BookingModel>> getBookingsByUser({required String userId}) =>
      execute(
        () async {
          final snap = await _bookingsCollection
              .where(BookingFirestoreConstants.userIdField, isEqualTo: userId)
              .orderBy(
                BookingFirestoreConstants.eventDateField,
                descending: true,
              )
              .get();

          return snap.docs.map((doc) => doc.data()).toList();
        },
        firebaseMapper: _firebaseMapper,
      );
}
