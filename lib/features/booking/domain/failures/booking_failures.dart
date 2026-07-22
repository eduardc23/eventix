import '../../../../core/domain/failures/app_failure.dart';

sealed class BookingFailure extends AppFailure {
  const BookingFailure();
}

class NoSpotsAvailableFailure extends BookingFailure {
  const NoSpotsAvailableFailure();

  @override
  List<Object?> get props => [];
}
