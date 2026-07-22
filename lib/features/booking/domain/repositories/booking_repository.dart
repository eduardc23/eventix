import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../entities/booking_entity.dart';
import '../entities/create_booking_params.dart';

abstract interface class BookingRepository {
  /// Crea una reserva y descuenta los cupos del evento de forma atómica.
  ///
  /// Retorna [NoSpotsAvailableFailure] si no hay cupos suficientes.
  Future<Result<void, AppFailure>> createBooking(
    CreateBookingParams params,
  );

  /// Obtiene todas las reservas del usuario autenticado.
  Future<Result<List<BookingEntity>, AppFailure>> getBookingsByUser({
    required String userId,
  });
}
