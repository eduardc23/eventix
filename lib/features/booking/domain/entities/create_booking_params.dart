import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_booking_params.freezed.dart';

@freezed
abstract class CreateBookingParams with _$CreateBookingParams {
  const factory CreateBookingParams({
    required String userId,
    required String eventId,
    required String eventTitle,
    required String eventImageUrl,
    required DateTime eventDate,
    required int tickets,
    required double totalPrice,
  }) = _CreateBookingParams;
}
