import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_entity.freezed.dart';

@freezed
abstract class BookingEntity with _$BookingEntity {
  const factory BookingEntity({
    required String uid,
    required String userId,
    required String eventId,
    required String eventTitle,
    required String eventImageUrl,
    required DateTime eventDate,
    required int tickets,
    required double totalPrice,
    required DateTime createdAt,
  }) = _BookingEntity;

  const BookingEntity._();

  bool get isPast => eventDate.isBefore(DateTime.now());

  bool get isFuture => !isPast;
}
