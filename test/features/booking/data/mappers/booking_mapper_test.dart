import 'package:eventix/features/booking/data/mappers/booking_mapper.dart';
import 'package:eventix/features/booking/data/models/booking_model.dart';
import 'package:eventix/features/booking/domain/entities/booking_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  late BookingMapperImpl mapper;

  final tBookingModel = BookingTestData.tBookingModel;
  final tBookingEntity = BookingTestData.tBookingEntity;
  final tEventDate = BookingTestData.tDate;
  final tCreatedAt = BookingTestData.tCreatedAt;

  setUp(() {
    mapper = const BookingMapperImpl();
  });

  group('BookingMapperImpl - Mapeo de Modelo a Entidad', () {
    test('Todos los campos se mapean correctamente', () {
      final entity = mapper.toEntity(tBookingModel);

      expect(entity.uid, tBookingModel.uid);
      expect(entity.userId, tBookingModel.userId);
      expect(entity.eventId, tBookingModel.eventId);
      expect(entity.eventTitle, tBookingModel.eventTitle);
      expect(entity.eventImageUrl, tBookingModel.eventImageUrl);
      expect(entity.eventDate, tBookingModel.eventDate);
      expect(entity.tickets, tBookingModel.tickets);
      expect(entity.totalPrice, tBookingModel.totalPrice);
      expect(entity.createdAt, tBookingModel.createdAt);
    });

    test('Un UID nulo en el modelo resulta en un UID vacío en la entidad', () {
      final model = BookingModel(
        uid: null,
        userId: tBookingModel.userId,
        eventId: tBookingModel.eventId,
        eventTitle: tBookingModel.eventTitle,
        eventImageUrl: tBookingModel.eventImageUrl,
        eventDate: tBookingModel.eventDate,
        tickets: tBookingModel.tickets,
        totalPrice: tBookingModel.totalPrice,
        createdAt: tBookingModel.createdAt,
      );

      final entity = mapper.toEntity(model);

      expect(entity.uid, '');
    });

    test('El UID se transfiere sin modificaciones cuando está presente', () {
      const tUid = 'uid-abc';
      final model = BookingModel(
        uid: tUid,
        userId: tBookingModel.userId,
        eventId: tBookingModel.eventId,
        eventTitle: tBookingModel.eventTitle,
        eventImageUrl: tBookingModel.eventImageUrl,
        eventDate: tBookingModel.eventDate,
        tickets: tBookingModel.tickets,
        totalPrice: tBookingModel.totalPrice,
        createdAt: tBookingModel.createdAt,
      );

      final entity = mapper.toEntity(model);

      expect(entity.uid, tUid);
    });

    test('El resultado es una instancia de BookingEntity', () {
      final result = mapper.toEntity(tBookingModel);

      expect(result, isA<BookingEntity>());
    });

    test('Los valores extremos se procesan sin errores', () {
      final model = BookingModel(
        uid: '',
        userId: 'user-1',
        eventId: 'event-1',
        eventTitle: '',
        eventImageUrl: 'https://img.example.com/img.png',
        eventDate: tEventDate,
        tickets: 0,
        totalPrice: 0.0,
        createdAt: tCreatedAt,
      );

      final entity = mapper.toEntity(model);

      expect(entity.uid, '');
      expect(entity.eventTitle, '');
      expect(entity.tickets, 0);
      expect(entity.totalPrice, 0.0);
    });
  });

  group('BookingMapperImpl - Mapeo de Entidad a Modelo', () {
    test('Todos los campos se mapean correctamente', () {
      final model = mapper.fromEntity(tBookingEntity);

      expect(model.uid, tBookingEntity.uid);
      expect(model.userId, tBookingEntity.userId);
      expect(model.eventId, tBookingEntity.eventId);
      expect(model.eventTitle, tBookingEntity.eventTitle);
      expect(model.eventImageUrl, tBookingEntity.eventImageUrl);
      expect(model.eventDate, tBookingEntity.eventDate);
      expect(model.tickets, tBookingEntity.tickets);
      expect(model.totalPrice, tBookingEntity.totalPrice);
      expect(model.createdAt, tBookingEntity.createdAt);
    });

    test('El UID se copia directamente sin valores por defecto', () {
      final entity = tBookingEntity.copyWith(uid: 'uid-directo');

      final model = mapper.fromEntity(entity);

      expect(model.uid, 'uid-directo');
    });

    test('El resultado es una instancia de BookingModel', () {
      final result = mapper.fromEntity(tBookingEntity);

      expect(result, isA<BookingModel>());
    });
  });

  group('BookingMapperImpl - Consistencia de Conversión', () {
    test('La conversión bidireccional desde entidad mantiene la integridad de los datos', () {
      final entityFinal = mapper.toEntity(mapper.fromEntity(tBookingEntity));

      expect(entityFinal.uid, tBookingEntity.uid);
      expect(entityFinal.userId, tBookingEntity.userId);
      expect(entityFinal.eventId, tBookingEntity.eventId);
      expect(entityFinal.eventTitle, tBookingEntity.eventTitle);
      expect(entityFinal.eventImageUrl, tBookingEntity.eventImageUrl);
      expect(entityFinal.eventDate, tBookingEntity.eventDate);
      expect(entityFinal.tickets, tBookingEntity.tickets);
      expect(entityFinal.totalPrice, tBookingEntity.totalPrice);
      expect(entityFinal.createdAt, tBookingEntity.createdAt);
    });

    test('La conversión bidireccional desde modelo mantiene la integridad de los datos', () {
      final modelFinal = mapper.fromEntity(mapper.toEntity(tBookingModel));

      expect(modelFinal.uid, tBookingModel.uid);
      expect(modelFinal.userId, tBookingModel.userId);
      expect(modelFinal.eventId, tBookingModel.eventId);
      expect(modelFinal.eventTitle, tBookingModel.eventTitle);
      expect(modelFinal.eventImageUrl, tBookingModel.eventImageUrl);
      expect(modelFinal.eventDate, tBookingModel.eventDate);
      expect(modelFinal.tickets, tBookingModel.tickets);
      expect(modelFinal.totalPrice, tBookingModel.totalPrice);
      expect(modelFinal.createdAt, tBookingModel.createdAt);
    });

    test('Un UID nulo se transforma en vacío y persiste tras la conversión de retorno', () {
      final original = BookingModel(
        uid: null,
        userId: tBookingModel.userId,
        eventId: tBookingModel.eventId,
        eventTitle: tBookingModel.eventTitle,
        eventImageUrl: tBookingModel.eventImageUrl,
        eventDate: tBookingModel.eventDate,
        tickets: tBookingModel.tickets,
        totalPrice: tBookingModel.totalPrice,
        createdAt: tBookingModel.createdAt,
      );

      final modelFinal = mapper.fromEntity(mapper.toEntity(original));

      expect(modelFinal.uid, '');
    });
  });
}
