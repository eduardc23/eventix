import 'package:eventix/features/events/data/constants/events_firestore_constants.dart';
import 'package:eventix/features/events/data/datasources/events_datasource_impl.dart';
import 'package:eventix/features/events/data/models/category_model.dart';
import 'package:eventix/features/events/data/models/city_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/events_json_factories.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseExceptionMapper mockFirebaseMapper;
  late EventsDatasourceImpl datasource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirebaseMapper = MockFirebaseExceptionMapper();

    datasource = EventsDatasourceImpl(
      firestore: fakeFirestore,
      firebaseMapper: mockFirebaseMapper,
    );
  });

  group('EventsDatasourceImpl - Consulta de Categorías', () {
    final tCategoryMap = EventsJsonFactories.createCategoryJson();

    test('Retorno exitoso de lista de categorías desde Firestore', () async {
      await fakeFirestore
          .collection(EventsFirestoreConstants.categoriesCollection)
          .doc('cat_123')
          .set(tCategoryMap);

      final result = await datasource.getCategories();

      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 1);
      expect(result.first.uid, 'cat_123');
      expect(
        result.first.name,
        tCategoryMap[EventsFirestoreConstants.nameField],
      );
    });
  });

  group('EventsDatasourceImpl - Consulta de Ciudades', () {
    test(
      'Lista de ciudades obtenida con ordenamiento alfabético por nombre',
      () async {
        await fakeFirestore
            .collection(EventsFirestoreConstants.citiesCollection)
            .doc('city_b')
            .set(EventsJsonFactories.createCityJson(name: 'Zipaquirá'));
        await fakeFirestore
            .collection(EventsFirestoreConstants.citiesCollection)
            .doc('city_a')
            .set(EventsJsonFactories.createCityJson(name: 'Bogotá'));

        final result = await datasource.getCities();

        expect(result, isA<List<CityModel>>());
        expect(result.length, 2);
        expect(result.first.uid, 'city_a');
        expect(result.first.name, 'Bogotá');
        expect(result.last.uid, 'city_b');
      },
    );
  });

  group('EventsDatasourceImpl - Consulta de Eventos', () {
    test(
      'Consulta de colección completa con ordenamiento cronológico por defecto',
      () async {
        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_late')
            .set(
              EventsJsonFactories.createEventJson(
                title: 'Tarde',
                date: DateTime(2026, 8, 20),
              ),
            );
        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_early')
            .set(
              EventsJsonFactories.createEventJson(
                title: 'Temprano',
                date: DateTime(2026, 8, 10),
              ),
            );

        final result = await datasource.getEvents();

        expect(result.length, 2);
        expect(result.first.uid, 'event_early');
        expect(result.last.uid, 'event_late');
      },
    );

    test(
      'Aplicación secuencial de filtros dinámicos (categoría, ciudad, rango de fechas)',
      () async {
        const tCategoryId = 'cat_1';
        const tCityId = 'city_1';
        final tStartDate = DateTime(2026, 8, 1);
        final tEndDate = DateTime(2026, 8, 31);

        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_ok')
            .set(
              EventsJsonFactories.createEventJson(
                categoryId: tCategoryId,
                cityId: tCityId,
                date: DateTime(2026, 8, 10),
                title: 'Evento válido',
              ),
            );
        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_wrong_category')
            .set(
              EventsJsonFactories.createEventJson(
                categoryId: 'other',
                cityId: tCityId,
                date: DateTime(2026, 8, 10),
              ),
            );
        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_wrong_city')
            .set(
              EventsJsonFactories.createEventJson(
                categoryId: tCategoryId,
                cityId: 'other-city',
                date: DateTime(2026, 8, 10),
              ),
            );
        await fakeFirestore
            .collection(EventsFirestoreConstants.eventsCollection)
            .doc('event_wrong_date')
            .set(
              EventsJsonFactories.createEventJson(
                categoryId: tCategoryId,
                cityId: tCityId,
                date: DateTime(2026, 9, 1),
              ),
            );

        final result = await datasource.getEvents(
          categoryId: tCategoryId,
          cityId: tCityId,
          startDate: tStartDate,
          endDate: tEndDate,
        );

        expect(result.length, 1);
        expect(result.first.uid, 'event_ok');
      },
    );
  });
}
