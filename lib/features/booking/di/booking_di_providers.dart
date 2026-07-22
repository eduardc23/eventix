import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/core_di_providers.dart';
import '../data/datasource/booking_datasource.dart';
import '../data/datasource/booking_datasource_impl.dart';
import '../data/mappers/booking_exception_mapper.dart';
import '../data/mappers/booking_mapper.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/use_cases/create_booking_usecase.dart';
import '../domain/use_cases/get_bookings_by_user_usecase.dart';

part 'booking_di_providers.g.dart';

@riverpod
BookingExceptionMapper bookingExceptionMapper(Ref ref) {
  return const BookingExceptionMapperImpl();
}

@riverpod
BookingMapper bookingMapper(Ref ref) {
  return const BookingMapperImpl();
}

@riverpod
BookingDataSource bookingDataSource(Ref ref) {
  return BookingDataSourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
    firebaseMapper: ref.watch(firebaseExceptionMapperProvider),
  );
}

@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepositoryImpl(
    dataSource: ref.watch(bookingDataSourceProvider),
    bookingExceptionMapper: ref.watch(bookingExceptionMapperProvider),
    bookingMapper: ref.watch(bookingMapperProvider),
    coreMapper: ref.watch(coreExceptionMapperProvider),
  );
}

@riverpod
CreateBookingUseCase createBookingUseCase(Ref ref) {
  return CreateBookingUseCase(ref.watch(bookingRepositoryProvider));
}

@riverpod
GetBookingsByUserUseCase getBookingsByUserUseCase(Ref ref) {
  return GetBookingsByUserUseCase(ref.watch(bookingRepositoryProvider));
}
