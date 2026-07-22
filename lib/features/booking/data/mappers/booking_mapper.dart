import '../../domain/entities/booking_entity.dart';
import '../models/booking_model.dart';

abstract interface class BookingMapper {
  BookingEntity toEntity(BookingModel model);
  BookingModel fromEntity(BookingEntity entity);
}

class BookingMapperImpl implements BookingMapper {
  const BookingMapperImpl();

  @override
  BookingEntity toEntity(BookingModel model) => BookingEntity(
        uid: model.uid ?? '',
        userId: model.userId,
        eventId: model.eventId,
        eventTitle: model.eventTitle,
        eventImageUrl: model.eventImageUrl,
        eventDate: model.eventDate,
        tickets: model.tickets,
        totalPrice: model.totalPrice,
        createdAt: model.createdAt,
      );

  @override
  BookingModel fromEntity(BookingEntity entity) => BookingModel(
        uid: entity.uid,
        userId: entity.userId,
        eventId: entity.eventId,
        eventTitle: entity.eventTitle,
        eventImageUrl: entity.eventImageUrl,
        eventDate: entity.eventDate,
        tickets: entity.tickets,
        totalPrice: entity.totalPrice,
        createdAt: entity.createdAt,
      );
}
