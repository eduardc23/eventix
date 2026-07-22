import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/data/utils/json_converters.dart';
import '../constants/events_firestore_constants.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
abstract class EventModel with _$EventModel {
  const EventModel._();

  const factory EventModel({
    String? uid,
    @JsonKey(name: EventsFirestoreConstants.eventTitleField)
    required String title,
    @JsonKey(name: EventsFirestoreConstants.eventDescriptionField)
    required String description,
    @JsonKey(name: EventsFirestoreConstants.eventCategoryIdField)
    required String categoryId,
    @JsonKey(name: EventsFirestoreConstants.eventCategoryNameField)
    required String categoryName,
    @JsonKey(name: EventsFirestoreConstants.eventCityIdField)
    required String cityId,
    @JsonKey(name: EventsFirestoreConstants.eventCityNameField)
    required String cityName,
    @TimestampConverter()
    @JsonKey(name: EventsFirestoreConstants.eventDateField)
    required DateTime date,
    @JsonKey(name: EventsFirestoreConstants.eventPriceField)
    required int price,
    @JsonKey(name: EventsFirestoreConstants.eventTotalCapacityField)
    required int totalCapacity,
    @JsonKey(name: EventsFirestoreConstants.eventAvailableSpotsField)
    required int availableSpots,
    @JsonKey(name: EventsFirestoreConstants.eventImageUrlField)
    required String imageUrl,
    @JsonKey(name: EventsFirestoreConstants.eventStatusField)
    required String status,
    @TimestampConverter()
    @JsonKey(name: EventsFirestoreConstants.createdAtField)
    required DateTime createdAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
