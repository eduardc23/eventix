import 'package:eventix/features/events/data/constants/events_firestore_constants.dart';
import 'package:eventix/features/events/data/models/city_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tJson = {
    EventsFirestoreConstants.uidField: 'city123',
    EventsFirestoreConstants.nameField: 'Medellín',
    EventsFirestoreConstants.cityDepartmentField: 'Antioquia',
  };

  final tModel = const CityModel(
    uid: 'city123',
    name: 'Medellín',
    department: 'Antioquia',
  );

  group('CityModel - Mapeo desde JSON', () {
    test('Los campos del modelo coinciden con los valores del JSON de entrada', () {
      final result = CityModel.fromJson(tJson);

      expect(result.uid, tModel.uid);
      expect(result.name, tModel.name);
      expect(result.department, tModel.department);
    });
  });
}
