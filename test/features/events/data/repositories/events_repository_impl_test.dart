import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/features/events/data/models/category_model.dart';
import 'package:eventix/features/events/data/models/city_model.dart';
import 'package:eventix/features/events/data/repositories/events_repository_impl.dart';
import 'package:eventix/features/events/domain/entities/category_entity.dart';
import 'package:eventix/features/events/domain/entities/city_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/events_test_data.dart';

void main() {
  late MockEventsDataSource mockDataSource;
  late MockEventMapper mockEventMapper;
  late MockCategoryMapper mockCategoryMapper;
  late MockCityMapper mockCityMapper;
  late MockCoreExceptionMapper mockCoreMapper;
  late EventsRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockEventsDataSource();
    mockEventMapper = MockEventMapper();
    mockCategoryMapper = MockCategoryMapper();
    mockCityMapper = MockCityMapper();
    mockCoreMapper = MockCoreExceptionMapper();

    repository = EventsRepositoryImpl(
      dataSource: mockDataSource,
      eventMapper: mockEventMapper,
      categoryMapper: mockCategoryMapper,
      cityMapper: mockCityMapper,
      coreMapper: mockCoreMapper,
    );
  });

  final tEventModel = EventsTestData.tEventModel;
  final tEventEntity = EventsTestData.tEventEntity;

  final tCategoryModel = CategoryModel(uid: 'cat1', name: 'Category');
  final tCategoryEntity = CategoryEntity(uid: 'cat1', name: 'Category');

  final tCityModel = CityModel(uid: 'city1', name: 'City', department: 'Dept');
  final tCityEntity = CityEntity(uid: 'city1', name: 'City', department: 'Dept');

  group('EventsRepositoryImpl - Obtención de Eventos', () {
    test('Lista de entidades cuando la consulta de eventos es exitosa', () async {
      when(() => mockDataSource.getEvents(
        categoryId: any(named: 'categoryId'),
        cityId: any(named: 'cityId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      )).thenAnswer((_) async => [tEventModel]);
      when(() => mockEventMapper.toEntityList([tEventModel])).thenReturn([tEventEntity]);

      final result = await repository.getEvents();

      expect(result.isSuccess, isTrue);
      result.when(
        success: (events) => expect(events, equals([tEventEntity])),
        error: (_) => fail('Debería ser exitoso'),
      );
      verify(() => mockDataSource.getEvents()).called(1);
    });

    test('Fallo de infraestructura mapeado mediante coreMapper al obtener eventos', () async {
      final tException = RequestTimeoutException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.getEvents(
        categoryId: any(named: 'categoryId'),
        cityId: any(named: 'cityId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      )).thenThrow(tException);
      when(() => mockCoreMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.getEvents();

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
    });
  });

  group('EventsRepositoryImpl - Obtención de Categorías', () {
    test('Lista de categorías obtenida exitosamente desde el origen de datos', () async {
      when(() => mockDataSource.getCategories()).thenAnswer((_) async => [tCategoryModel]);
      when(() => mockCategoryMapper.toEntityList([tCategoryModel])).thenReturn([tCategoryEntity]);

      final result = await repository.getCategories();

      expect(result.isSuccess, isTrue);
      result.when(
        success: (categories) => expect(categories, equals([tCategoryEntity])),
        error: (_) => fail('Debería ser exitoso'),
      );
    });

    test('Fallo mapeado mediante coreMapper al obtener categorías', () async {
      final tException = RequestTimeoutException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.getCategories()).thenThrow(tException);
      when(() => mockCoreMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.getCategories();

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
    });
  });

  group('EventsRepositoryImpl - Obtención de Ciudades', () {
    test('Lista de ciudades obtenida exitosamente desde el origen de datos', () async {
      when(() => mockDataSource.getCities()).thenAnswer((_) async => [tCityModel]);
      when(() => mockCityMapper.toEntityList([tCityModel])).thenReturn([tCityEntity]);

      final result = await repository.getCities();

      expect(result.isSuccess, isTrue);
      result.when(
        success: (cities) => expect(cities, equals([tCityEntity])),
        error: (_) => fail('Debería ser exitoso'),
      );
    });

    test('Fallo mapeado mediante coreMapper al obtener ciudades', () async {
      final tException = RequestTimeoutException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.getCities()).thenThrow(tException);
      when(() => mockCoreMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.getCities();

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
    });
  });
}
