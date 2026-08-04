import '../constants/events_firestore_constants.dart';

class CityModel {
  final String uid;
  final String name;
  final String department;

  const CityModel({required this.uid, required this.name, required this.department});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      uid: json[EventsFirestoreConstants.uidField] as String,
      name: json[EventsFirestoreConstants.nameField] as String,
      department: json[EventsFirestoreConstants.cityDepartmentField] as String,
    );
  }
}
