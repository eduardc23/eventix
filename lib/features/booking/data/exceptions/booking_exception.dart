import '../../../../core/data/exceptions/app_exception.dart';

sealed class BookingException extends AppException {
  const BookingException({super.message});
}

/// Se lanza cuando se intenta reservar un evento sin cupos disponibles.
/// Ocurre si otro usuario reservó el último cupo en el mismo instante.
class NoSpotsAvailableException extends BookingException {
  const NoSpotsAvailableException();
}
