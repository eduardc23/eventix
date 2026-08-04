import 'package:eventix/features/events/data/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/json_reader.dart';
import '../../helpers/events_test_data.dart';

void main() {
  final tJson = jsonReader('features/events/fixtures/event.json', toFirestore: true);
  final tModel = EventsTestData.tEventModel;

  group('EventModel - Mapeo desde JSON', () {
    test('Los campos del modelo coinciden con los valores del JSON de entrada', () {
      final result = EventModel.fromJson(tJson);

      expect(result.uid, tModel.uid);
      expect(result.title, tModel.title);
      expect(result.description, tModel.description);
      expect(result.categoryId, tModel.categoryId);
      expect(result.categoryName, tModel.categoryName);
      expect(result.cityId, tModel.cityId);
      expect(result.cityName, tModel.cityName);
      expect(result.date, tModel.date);
      expect(result.price, tModel.price);
      expect(result.totalCapacity, tModel.totalCapacity);
      expect(result.availableSpots, tModel.availableSpots);
      expect(result.imageUrl, tModel.imageUrl);
      expect(result.status, tModel.status);
      expect(result.createdAt, tModel.createdAt);
    });
  });
}
