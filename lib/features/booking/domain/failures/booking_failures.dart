import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/failures/app_failure.dart';

part 'booking_failures.freezed.dart';

@freezed
sealed class BookingFailure with _$BookingFailure implements AppFailure {
  const factory BookingFailure.noSpotsAvailable() = NoSpotsAvailableFailure;
}
