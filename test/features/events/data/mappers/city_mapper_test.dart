import 'package:eventix/features/events/data/mappers/city_mapper.dart';
import 'package:eventix/features/events/data/models/city_model.dart';
import 'package:eventix/features/events/domain/entities/city_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late CityMapperImpl mapper;

  const tCityModel = EventsTestData.tCityModel;

  setUp(() {
    mapper = const CityMapperImpl();
  });

  group('CityMapperImpl - Mapeo de Modelo a Entidad', () {
    test('Todos los campos se mapean correctamente', () {
      final entity = mapper.toEntity(tCityModel);

      expect(entity.uid, tCityModel.uid);
      expect(entity.name, tCityModel.name);
      expect(entity.department, tCityModel.department);
    });

    test('El resultado es una instancia de CityEntity', () {
      final result = mapper.toEntity(tCityModel);

      expect(result, isA<CityEntity>());
    });
  });

  group('CityMapperImpl - Mapeo de Lista de Modelos', () {
    test('La lista de modelos se transforma correctamente en una lista de entidades', () {
      final models = [
        tCityModel,
        const CityModel(uid: 'city-456', name: 'Envigado', department: 'Antioquia'),
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
