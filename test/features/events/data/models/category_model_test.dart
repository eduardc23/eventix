import 'package:eventix/features/events/data/constants/events_firestore_constants.dart';
import 'package:eventix/features/events/data/models/category_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tJson = {
    EventsFirestoreConstants.uidField: 'cat123',
    EventsFirestoreConstants.nameField: 'Conciertos',
  };

  final tModel = const CategoryModel(
    uid: 'cat123',
    name: 'Conciertos',
  );

  group('CategoryModel - Mapeo desde JSON', () {
    test('Los campos del modelo coinciden con los valores del JSON de entrada', () {
      final result = CategoryModel.fromJson(tJson);

      expect(result.uid, tModel.uid);
      expect(result.name, tModel.name);
    });
  });
}
