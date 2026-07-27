import '../../domain/entities/event_entity.dart';
import '../../domain/enums/event_status_enum.dart';
import '../models/event_model.dart';

abstract interface class EventMapper {
  EventEntity toEntity(EventModel model);
  List<EventEntity> toEntityList(List<EventModel> models);
}

class EventMapperImpl implements EventMapper {
  const EventMapperImpl();

  @override
  EventEntity toEntity(EventModel model) => EventEntity(
        uid: model.uid ?? '',
        title: model.title,
        description: model.description,
        categoryId: model.categoryId,
        categoryName: model.categoryName,
        cityId: model.cityId,
        cityName: model.cityName,
        date: model.date,
        price: model.price,
        totalCapacity: model.totalCapacity,
        availableSpots: model.availableSpots,
        imageUrl: model.imageUrl,
        status: EventStatus.fromString(model.status),
        createdAt: model.createdAt,
      );

  @override
  List<EventEntity> toEntityList(List<EventModel> models) =>
      models.map(toEntity).toList();
}
