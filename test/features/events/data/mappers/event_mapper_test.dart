import 'package:eventix/features/events/data/mappers/event_mapper.dart';
import 'package:eventix/features/events/data/models/event_model.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:eventix/features/events/domain/enums/event_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late EventMapperImpl mapper;

  final tEventModel = EventsTestData.tEventModel;

  setUp(() {
    mapper = const EventMapperImpl();
  });

  group('EventMapperImpl - Mapeo de Modelo a Entidad', () {
    test('Todos los campos se mapean correctamente', () {
      final entity = mapper.toEntity(tEventModel);

      expect(entity.uid, tEventModel.uid);
      expect(entity.title, tEventModel.title);
      expect(entity.description, tEventModel.description);
      expect(entity.categoryId, tEventModel.categoryId);
      expect(entity.categoryName, tEventModel.categoryName);
      expect(entity.cityId, tEventModel.cityId);
      expect(entity.cityName, tEventModel.cityName);
      expect(entity.date, tEventModel.date);
      expect(entity.price, tEventModel.price);
      expect(entity.totalCapacity, tEventModel.totalCapacity);
      expect(entity.availableSpots, tEventModel.availableSpots);
      expect(entity.imageUrl, tEventModel.imageUrl);
      expect(entity.status, EventStatus.active);
      expect(entity.createdAt, tEventModel.createdAt);
    });

    test('Un UID nulo en el modelo resulta en un UID vacío en la entidad', () {
      final model = EventModel(
        uid: null,
        title: tEventModel.title,
        description: tEventModel.description,
        categoryId: tEventModel.categoryId,
        categoryName: tEventModel.categoryName,
        cityId: tEventModel.cityId,
        cityName: tEventModel.cityName,
        date: tEventModel.date,
        price: tEventModel.price,
        totalCapacity: tEventModel.totalCapacity,
        availableSpots: tEventModel.availableSpots,
        imageUrl: tEventModel.imageUrl,
        status: tEventModel.status,
        createdAt: tEventModel.createdAt,
      );

      final entity = mapper.toEntity(model);

      expect(entity.uid, '');
    });

    test('El estado se mapea correctamente desde un String a EventStatus', () {
      final model = EventModel(
        uid: tEventModel.uid,
        title: tEventModel.title,
        description: tEventModel.description,
        categoryId: tEventModel.categoryId,
        categoryName: tEventModel.categoryName,
        cityId: tEventModel.cityId,
        cityName: tEventModel.cityName,
        date: tEventModel.date,
        price: tEventModel.price,
        totalCapacity: tEventModel.totalCapacity,
        availableSpots: tEventModel.availableSpots,
        imageUrl: tEventModel.imageUrl,
        status: 'cancelled',
        createdAt: tEventModel.createdAt,
      );

      final entity = mapper.toEntity(model);

      expect(entity.status, EventStatus.cancelled);
    });

    test('El resultado es una instancia de EventEntity', () {
      final result = mapper.toEntity(tEventModel);

      expect(result, isA<EventEntity>());
    });
  });

  group('EventMapperImpl - Mapeo de Lista de Modelos', () {
    test('La lista de modelos se transforma correctamente en una lista de entidades', () {
      final models = [
        tEventModel,
        tEventModel,
      ];

      final entities = mapper.toEntityList(models);

      expect(entities.length, models.length);
      expect(entities[0].uid, models[0].uid);
      expect(entities[1].uid, models[1].uid);
    });

    test('Una lista vacía de modelos resulta en una lista vacía de entidades', () {
      final entities = mapper.toEntityList([]);

      expect(entities, isEmpty);
    });
  });
}
