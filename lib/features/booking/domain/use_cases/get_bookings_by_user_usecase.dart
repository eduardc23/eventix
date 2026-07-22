import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsByUserUseCase
    implements UseCase<List<BookingEntity>, GetBookingsByUserParams> {
  const GetBookingsByUserUseCase(this._repository);

  final BookingRepository _repository;

  @override
  Future<Result<List<BookingEntity>, AppFailure>> call(
    GetBookingsByUserParams params,
  ) {
    return _repository.getBookingsByUser(userId: params.userId);
  }
}

class GetBookingsByUserParams {
  const GetBookingsByUserParams({required this.userId});

  final String userId;
}
