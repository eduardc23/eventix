import 'package:eventix/core/data/exceptions/core_exceptions.dart';
import 'package:eventix/core/domain/failures/core_failures.dart';
import 'package:eventix/features/booking/data/exceptions/booking_exception.dart';
import 'package:eventix/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  late MockBookingDataSource mockDataSource;
  late MockBookingExceptionMapper mockExceptionMapper;
  late MockBookingMapper mockMapper;
  late MockCoreExceptionMapper mockCoreMapper;
  late BookingRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockBookingDataSource();
    mockExceptionMapper = MockBookingExceptionMapper();
    mockMapper = MockBookingMapper();
    mockCoreMapper = MockCoreExceptionMapper();

    repository = BookingRepositoryImpl(
      dataSource: mockDataSource,
      bookingExceptionMapper: mockExceptionMapper,
      bookingMapper: mockMapper,
      coreMapper: mockCoreMapper,
    );
  });

  final tParams = BookingTestData.tCreateBookingParams;
  final tBookingModel = BookingTestData.tBookingModel;
  final tBookingEntity = BookingTestData.tBookingEntity;

  group('BookingRepositoryImpl - Creación de Reserva', () {
    test('Operación exitosa al crear una reserva válida', () async {
      when(
        () => mockDataSource.createBooking(tParams),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.createBooking(tParams);

      expect(result.isSuccess, isTrue);
      verify(() => mockDataSource.createBooking(tParams)).called(1);
    });

    test('Fallo mapeado correctamente ante excepciones de reserva', () async {
      const tException = NoSpotsAvailableException();
      final tFailure = FakeAppFailure();

      when(() => mockDataSource.createBooking(tParams)).thenThrow(tException);
      when(() => mockExceptionMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.createBooking(tParams);

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
      verify(() => mockExceptionMapper.map(tException)).called(1);
    });

    test('Fallo desconocido ante errores de aplicación no previstos', () async {
      final tException = FakeAppException();

      when(() => mockDataSource.createBooking(tParams)).thenThrow(tException);

      final result = await repository.createBooking(tParams);

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, isA<UnknownFailure>()),
      );
    });
  });

  group('BookingRepositoryImpl - Consulta de Reservas', () {
    const tUserId = 'user123';

    test('Retorno de lista de reservas asociadas al usuario', () async {
      when(
        () => mockDataSource.getBookingsByUser(userId: tUserId),
      ).thenAnswer((_) async => [tBookingModel]);
      when(() => mockMapper.toEntity(tBookingModel)).thenReturn(tBookingEntity);

      final result = await repository.getBookingsByUser(userId: tUserId);

      expect(result.isSuccess, isTrue);
      result.when(
        success: (bookings) => expect(bookings, equals([tBookingEntity])),
        error: (_) => fail('Debería ser exitoso'),
      );
      verify(() => mockDataSource.getBookingsByUser(userId: tUserId)).called(1);
      verify(() => mockMapper.toEntity(tBookingModel)).called(1);
    });

    test('Fallo de infraestructura mapeado mediante coreMapper', () async {
      final tException = RequestTimeoutException();
      final tFailure = FakeAppFailure();

      when(
        () => mockDataSource.getBookingsByUser(userId: tUserId),
      ).thenThrow(tException);
      when(() => mockCoreMapper.map(tException)).thenReturn(tFailure);

      final result = await repository.getBookingsByUser(userId: tUserId);

      expect(result.isError, isTrue);
      result.when(
        success: (_) => {},
        error: (failure) => expect(failure, equals(tFailure)),
      );
      verify(() => mockCoreMapper.map(tException)).called(1);
    });
  });
}
