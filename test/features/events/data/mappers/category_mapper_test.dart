import 'package:eventix/features/events/data/mappers/category_mapper.dart';
import 'package:eventix/features/events/data/models/category_model.dart';
import 'package:eventix/features/events/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late CategoryMapperImpl mapper;

  const tCategoryModel = EventsTestData.tCategoryModel;

  setUp(() {
    mapper = const CategoryMapperImpl();
  });

  group('CategoryMapperImpl - Mapeo de Modelo a Entidad', () {
    test('Todos los campos se mapean correctamente', () {
      final entity = mapper.toEntity(tCategoryModel);

      expect(entity.uid, tCategoryModel.uid);
      expect(entity.name, tCategoryModel.name);
    });

    test('El resultado es una instancia de CategoryEntity', () {
      final result = mapper.toEntity(tCategoryModel);

      expect(result, isA<CategoryEntity>());
    });
  });

  group('CategoryMapperImpl - Mapeo de Lista de Modelos', () {
    test('La lista de modelos se transforma correctamente en una lista de entidades', () {
      final models = [
        tCategoryModel,
        const CategoryModel(uid: 'cat-456', name: 'Teatro'),
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
