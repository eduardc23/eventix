import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/mappers/firebase_exception_mapper.dart';
import '../../../../core/data/utils/datasource_executor_utils.dart';
import '../constants/events_firestore_constants.dart';
import '../models/category_model.dart';
import '../models/city_model.dart';
import '../models/event_model.dart';
import 'events_datasource.dart';

class EventsDatasourceImpl with DatasourceExecutor implements EventsDataSource {
  const EventsDatasourceImpl({
    required this._firestore,
    required this._firebaseMapper,
  });

  final FirebaseFirestore _firestore;
  final FirebaseExceptionMapper _firebaseMapper;

  @override
  Future<List<EventModel>> getEvents({
    String? categoryId,
    String? cityId,
    DateTime? startDate,
    DateTime? endDate,
  }) => execute(() async {
    Query<Map<String, dynamic>> query = _firestore.collection(
      EventsFirestoreConstants.eventsCollection,
    );

    if (categoryId != null) {
      query = query.where(
        EventsFirestoreConstants.eventCategoryIdField,
        isEqualTo: categoryId,
      );
    }

    if (cityId != null) {
      query = query.where(
        EventsFirestoreConstants.eventCityIdField,
        isEqualTo: cityId,
      );
    }
    if (startDate != null) {
      query = query.where(
        EventsFirestoreConstants.eventDateField,
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        EventsFirestoreConstants.eventDateField,
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    final snapshot = await query
        .orderBy(EventsFirestoreConstants.eventDateField)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data[EventsFirestoreConstants.uidField] = doc.id;
      return EventModel.fromJson(data);
    }).toList();
  }, firebaseMapper: _firebaseMapper);

  @override
  Future<List<CategoryModel>> getCategories() => execute(() async {
    final snapshot = await _firestore
        .collection(EventsFirestoreConstants.categoriesCollection)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data[EventsFirestoreConstants.uidField] = doc.id;
      return CategoryModel.fromJson(data);
    }).toList();
  }, firebaseMapper: _firebaseMapper);

  @override
  Future<List<CityModel>> getCities() => execute(() async {
    final snapshot = await _firestore
        .collection(EventsFirestoreConstants.citiesCollection)
        .orderBy(EventsFirestoreConstants.nameField)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data[EventsFirestoreConstants.uidField] = doc.id;
      return CityModel.fromJson(data);
    }).toList();
  }, firebaseMapper: _firebaseMapper);
}
