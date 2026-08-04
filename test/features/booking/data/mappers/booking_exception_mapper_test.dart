import 'package:eventix/features/booking/data/exceptions/booking_exception.dart';
import 'package:eventix/features/booking/data/mappers/booking_exception_mapper.dart';
import 'package:eventix/features/booking/domain/failures/booking_failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookingExceptionMapper mapper;

  setUp(() {
    mapper = const BookingExceptionMapperImpl();
  });

  group('BookingExceptionMapperImpl - Mapeo de Excepciones de Reserva', () {
    test('NoSpotsAvailableException se transforma en NoSpotsAvailableFailure', () {
      final result = mapper.map(const NoSpotsAvailableException());

      expect(result, isA<NoSpotsAvailableFailure>());
    });
  });
}
