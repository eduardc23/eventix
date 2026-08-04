import '../constants/events_firestore_constants.dart';

class CategoryModel {
  final String uid;
  final String name;

  const CategoryModel({
    required this.uid,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      uid: json[EventsFirestoreConstants.uidField] as String,
      name: json[EventsFirestoreConstants.nameField] as String,
    );
  }
}
