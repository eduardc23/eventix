import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../entities/create_booking_params.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase
    implements UseCase<void, CreateBookingParams> {
  const CreateBookingUseCase(this._repository);

  final BookingRepository _repository;

  @override
  Future<Result<void, AppFailure>> call(
    CreateBookingParams params,
  ) {
    return _repository.createBooking(params);
  }
}
