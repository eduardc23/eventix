import 'package:eventix/features/booking/data/datasource/booking_datasource.dart';
import 'package:eventix/features/booking/data/mappers/booking_exception_mapper.dart';
import 'package:eventix/features/booking/data/mappers/booking_mapper.dart';
import 'package:eventix/features/booking/domain/repositories/booking_repository.dart';
import 'package:eventix/features/booking/domain/use_cases/create_booking_usecase.dart';
import 'package:eventix/features/booking/domain/use_cases/get_bookings_by_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

// --- Feature DataSources ---
class MockBookingDataSource extends Mock implements BookingDataSource {}

// --- Feature Repositories ---
class MockBookingRepository extends Mock implements BookingRepository {}

// --- Feature Use Cases ---
class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}
class MockGetBookingsByUserUseCase extends Mock implements GetBookingsByUserUseCase {}

// --- Feature Mappers ---
class MockBookingMapper extends Mock implements BookingMapper {}
class MockBookingExceptionMapper extends Mock implements BookingExceptionMapper {}
