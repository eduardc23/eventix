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

  CollectionReference<EventModel> get _eventsCollection => _firestore
      .collection(EventsFirestoreConstants.eventsCollection)
      .withConverter<EventModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['uid'] = snapshot.id;
          return EventModel.fromJson(data);
        },
        toFirestore: (model, _) {
          final json = model.toJson();
          json.remove('uid');
          return json;
        },
      );

  CollectionReference<CategoryModel> get _categoriesCollection => _firestore
      .collection(EventsFirestoreConstants.categoriesCollection)
      .withConverter<CategoryModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['uid'] = snapshot.id;
          return CategoryModel.fromJson(data);
        },
        toFirestore: (model, _) {
          final json = model.toJson();
          json.remove('uid');
          return json;
        },
      );

  CollectionReference<CityModel> get _citiesCollection => _firestore
      .collection(EventsFirestoreConstants.citiesCollection)
      .withConverter<CityModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['uid'] = snapshot.id;
          return CityModel.fromJson(data);
        },
        toFirestore: (model, _) {
          final json = model.toJson();
          json.remove('uid');
          return json;
        },
      );

  @override
  Future<List<EventModel>> getEvents({
    String? categoryId,
    String? cityId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      execute(
        () async {
          Query<EventModel> query = _eventsCollection;

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

          final DateTime effectiveStartDate =
              startDate != null && startDate.isAfter(DateTime.now())
                  ? startDate
                  : DateTime.now();

          query = query.where(
            EventsFirestoreConstants.eventDateField,
            isGreaterThanOrEqualTo: Timestamp.fromDate(effectiveStartDate),
          );

          if (endDate != null) {
            query = query.where(
              EventsFirestoreConstants.eventDateField,
              isLessThanOrEqualTo: Timestamp.fromDate(endDate),
            );
          }

          final snapshot = await query
              .orderBy(EventsFirestoreConstants.eventDateField)
              .get();

          return snapshot.docs.map((doc) => doc.data()).toList();
        },
        firebaseMapper: _firebaseMapper,
      );

  @override
  Future<List<CategoryModel>> getCategories() => execute(
        () async {
          final snapshot = await _categoriesCollection
              .orderBy(EventsFirestoreConstants.nameField)
              .get();

          return snapshot.docs.map((doc) => doc.data()).toList();
        },
        firebaseMapper: _firebaseMapper,
      );

  @override
  Future<List<CityModel>> getCities() => execute(
        () async {
          final snapshot = await _citiesCollection
              .orderBy(EventsFirestoreConstants.nameField)
              .get();

          return snapshot.docs.map((doc) => doc.data()).toList();
        },
        firebaseMapper: _firebaseMapper,
      );
}
