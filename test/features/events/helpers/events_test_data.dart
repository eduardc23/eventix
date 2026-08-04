import 'package:eventix/features/events/data/models/category_model.dart';
import 'package:eventix/features/events/data/models/city_model.dart';
import 'package:eventix/features/events/data/models/event_model.dart';
import 'package:eventix/features/events/domain/entities/category_entity.dart';
import 'package:eventix/features/events/domain/entities/city_entity.dart';
import 'package:eventix/features/events/domain/entities/event_entity.dart';
import 'package:eventix/features/events/domain/enums/event_status_enum.dart';

class EventsTestData {
  static final tDate = DateTime(2026, 12, 1);
  static final tCreatedAt = DateTime(2026, 11, 1);

  static final tEventModel = EventModel(
    uid: 'event123',
    title: 'Rock al Parque',
    description: 'Festival de rock',
    categoryId: 'catRock',
    categoryName: 'Rock',
    cityId: 'cityBog',
    cityName: 'Bogotá',
    date: tDate,
    price: 0,
    totalCapacity: 50000,
    availableSpots: 10000,
    imageUrl: 'https://rock.com/img.png',
    status: 'active',
    createdAt: tCreatedAt,
  );

  static final tEventEntity = EventEntity(
    uid: 'event123',
    title: 'Rock al Parque',
    description: 'Festival de rock',
    categoryId: 'catRock',
    categoryName: 'Rock',
    cityId: 'cityBog',
    cityName: 'Bogotá',
    date: tDate,
    price: 0,
    totalCapacity: 50000,
    availableSpots: 10000,
    imageUrl: 'https://rock.com/img.png',
    status: EventStatus.active,
    createdAt: tCreatedAt,
  );

  static const tCategoryModel = CategoryModel(uid: 'cat1', name: 'Category');
  static const tCategoryEntity = CategoryEntity(uid: 'cat1', name: 'Category');

  static const tCityModel = CityModel(uid: 'city1', name: 'City', department: 'Dept');
  static const tCityEntity = CityEntity(uid: 'city1', name: 'City', department: 'Dept');

  static EventEntity makeEventEntity({
    String uid = 'uid-123',
    String title = 'Flutter Conference',
    int price = 100,
    int totalCapacity = 100,
    int availableSpots = 50,
    EventStatus status = EventStatus.active,
    DateTime? date,
  }) {
    return EventEntity(
      uid: uid,
      title: title,
      description: 'A great event',
      categoryId: 'cat-1',
      categoryName: 'Technology',
      cityId: 'city-1',
      cityName: 'Bogotá',
      date: date ?? DateTime(2026, 12, 1),
      price: price,
      totalCapacity: totalCapacity,
      availableSpots: availableSpots,
      imageUrl: 'https://example.com/image.png',
      status: status,
      createdAt: DateTime(2025, 1, 1),
    );
  }
}
