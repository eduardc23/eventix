import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/events_firestore_constants.dart';

class EventModel {
  final String? uid;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String cityId;
  final String cityName;
  final DateTime date;
  final int price;
  final int totalCapacity;
  final int availableSpots;
  final String imageUrl;
  final String status;
  final DateTime createdAt;

  const EventModel({
    this.uid,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.cityId,
    required this.cityName,
    required this.date,
    required this.price,
    required this.totalCapacity,
    required this.availableSpots,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      uid: json[EventsFirestoreConstants.uidField] as String?,
      title: json[EventsFirestoreConstants.eventTitleField] as String,
      description:
          json[EventsFirestoreConstants.eventDescriptionField] as String,
      categoryId: json[EventsFirestoreConstants.eventCategoryIdField] as String,
      categoryName:
          json[EventsFirestoreConstants.eventCategoryNameField] as String,
      cityId: json[EventsFirestoreConstants.eventCityIdField] as String,
      cityName: json[EventsFirestoreConstants.eventCityNameField] as String,
      date: (json[EventsFirestoreConstants.eventDateField] as Timestamp)
          .toDate(),
      price: json[EventsFirestoreConstants.eventPriceField] as int,
      totalCapacity:
          json[EventsFirestoreConstants.eventTotalCapacityField] as int,
      availableSpots:
          json[EventsFirestoreConstants.eventAvailableSpotsField] as int,
      imageUrl: json[EventsFirestoreConstants.eventImageUrlField] as String,
      status: json[EventsFirestoreConstants.eventStatusField] as String,
      createdAt: (json[EventsFirestoreConstants.createdAtField] as Timestamp)
          .toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (uid != null) EventsFirestoreConstants.uidField: uid,
      EventsFirestoreConstants.eventTitleField: title,
      EventsFirestoreConstants.eventDescriptionField: description,
      EventsFirestoreConstants.eventCategoryIdField: categoryId,
      EventsFirestoreConstants.eventCategoryNameField: categoryName,
      EventsFirestoreConstants.eventCityIdField: cityId,
      EventsFirestoreConstants.eventCityNameField: cityName,
      EventsFirestoreConstants.eventDateField: Timestamp.fromDate(date),
      EventsFirestoreConstants.eventPriceField: price,
      EventsFirestoreConstants.eventTotalCapacityField: totalCapacity,
      EventsFirestoreConstants.eventAvailableSpotsField: availableSpots,
      EventsFirestoreConstants.eventImageUrlField: imageUrl,
      EventsFirestoreConstants.eventStatusField: status,
      EventsFirestoreConstants.createdAtField: Timestamp.fromDate(createdAt),
    };
  }
}
