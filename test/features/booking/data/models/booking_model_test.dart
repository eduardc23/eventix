import 'package:eventix/features/booking/data/constants/booking_firestore_constants.dart';
import 'package:eventix/features/booking/data/models/booking_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/json_reader.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  final tJson = jsonReader('features/booking/fixtures/booking.json', toFirestore: true);
  final tModel = BookingTestData.tBookingModel;

  group('BookingModel - Mapeo desde JSON', () {
    test('Los campos del modelo coinciden con los valores del JSON de entrada', () {
      final result = BookingModel.fromJson(tJson);

      expect(result.uid, tModel.uid);
      expect(result.userId, tModel.userId);
      expect(result.eventId, tModel.eventId);
      expect(result.eventTitle, tModel.eventTitle);
      expect(result.eventImageUrl, tModel.eventImageUrl);
      expect(result.eventDate, tModel.eventDate);
      expect(result.tickets, tModel.tickets);
      expect(result.totalPrice, tModel.totalPrice);
      expect(result.createdAt, tModel.createdAt);
    });

    test('El precio total admite valores con punto flotante (double)', () {
      final mapWithDouble = Map<String, dynamic>.from(tJson);
      mapWithDouble[BookingFirestoreConstants.totalPriceField] = 150.99;

      final result = BookingModel.fromJson(mapWithDouble);

      expect(result.totalPrice, 150.99);
    });
  });
}
