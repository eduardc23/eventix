import '../../../../core/config/app_config.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/failures/core_failures.dart';
import '../../../../core/presentation/extensions/core_failure_message_extension.dart';
import '../../domain/failures/booking_failures.dart';

extension BookingFailureMessageX on AppFailure {
  String toBookingMessage(AppConfig config) {
    return switch (this) {
      BookingFailure bookingFailure => switch (bookingFailure) {
        NoSpotsAvailableFailure() => config.alerts.noSpots.message,
      },
      CoreFailure coreFailure => coreFailure.errorMessage,
      _ => config.banners.booking.unexpectedError,
    };
  }
}
