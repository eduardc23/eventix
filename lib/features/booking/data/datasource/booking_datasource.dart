import '../../domain/entities/create_booking_params.dart';
import '../models/booking_model.dart';

abstract interface class BookingDataSource {
  Future<void> createBooking(CreateBookingParams params);
  Future<List<BookingModel>> getBookingsByUser({required String userId});
}
