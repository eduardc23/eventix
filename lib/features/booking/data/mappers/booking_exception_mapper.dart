import '../../../../core/domain/failures/app_failure.dart';
import '../../domain/failures/booking_failures.dart';
import '../exceptions/booking_exception.dart';

abstract interface class BookingExceptionMapper {
  AppFailure map(BookingException exception);
}

class BookingExceptionMapperImpl implements BookingExceptionMapper {
  const BookingExceptionMapperImpl();

  @override
  AppFailure map(BookingException exception) => switch (exception) {
    NoSpotsAvailableException() => const NoSpotsAvailableFailure(),
  };
}
