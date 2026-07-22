import '../../../../core/data/mappers/core_exception_mapper.dart';
import '../../../../core/data/utils/repository_executor.dart';
import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/create_booking_params.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasource/booking_datasource.dart';
import '../exceptions/booking_exception.dart';
import '../mappers/booking_exception_mapper.dart';
import '../mappers/booking_mapper.dart';

class BookingRepositoryImpl with RepositoryExecutor implements BookingRepository {
  const BookingRepositoryImpl({
    required this._dataSource,
    required this._bookingExceptionMapper,
    required this._bookingMapper,
    required this._coreMapper,
  });

  final BookingDataSource _dataSource;
  final BookingExceptionMapper _bookingExceptionMapper;
  final BookingMapper _bookingMapper;
  final CoreExceptionMapper _coreMapper;

  @override
  Future<Result<void, AppFailure>> createBooking(CreateBookingParams params,) =>
      execute(
            () => _dataSource.createBooking(params),
        coreMapper: _coreMapper,
        mapException: (e) =>
        e is BookingException ? _bookingExceptionMapper.map(e) : null,
      );

  @override
  Future<Result<List<BookingEntity>, AppFailure>> getBookingsByUser({
    required String userId,
  }) =>
      execute(
            () async {
          final models = await _dataSource.getBookingsByUser(userId: userId);
          return models.map(_bookingMapper.toEntity).toList();
        },
        coreMapper: _coreMapper,
        mapException: (e) =>
        e is BookingException ? _bookingExceptionMapper.map(e) : null,
      );
}
