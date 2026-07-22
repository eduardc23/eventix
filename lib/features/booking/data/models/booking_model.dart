import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/data/utils/json_converters.dart';
import '../constants/booking_firestore_constants.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
abstract class BookingModel with _$BookingModel {
  const BookingModel._();

  const factory BookingModel({
    String? uid,
    @JsonKey(name: BookingFirestoreConstants.userIdField)
    required String userId,
    @JsonKey(name: BookingFirestoreConstants.eventIdField)
    required String eventId,
    @JsonKey(name: BookingFirestoreConstants.eventTitleField)
    required String eventTitle,
    @JsonKey(name: BookingFirestoreConstants.eventImageUrlField)
    required String eventImageUrl,
    @TimestampConverter()
    @JsonKey(name: BookingFirestoreConstants.eventDateField)
    required DateTime eventDate,
    @JsonKey(name: BookingFirestoreConstants.ticketsField)
    required int tickets,
    @JsonKey(name: BookingFirestoreConstants.totalPriceField)
    required double totalPrice,
    @TimestampConverter()
    @JsonKey(name: BookingFirestoreConstants.createdAtField)
    required DateTime createdAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
