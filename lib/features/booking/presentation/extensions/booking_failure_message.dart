
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/failures/core_failures.dart';
import '../../../../core/presentation/utils/core_failure_message.dart';
import '../../domain/failures/booking_failures.dart';
import '../constants/booking_strings.dart';

extension BookingFailureMessageX on AppFailure {
  String get toBookingMessage {
    return switch (this) {
      BookingFailure bookingFailure => switch (bookingFailure) {
        NoSpotsAvailableFailure() => BookingStrings.noSpotsMessage,
      },
      CoreFailure coreFailure => coreFailure.errorMessage,
      _ => BookingStrings.unexpectedBookingError,
    };
  }
}