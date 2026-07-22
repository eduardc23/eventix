import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../core/domain/failures/app_failure.dart';


part 'create_booking_state.freezed.dart';

@freezed
class CreateBookingState with _$CreateBookingState {

  const CreateBookingState._();

  const factory CreateBookingState.initial() = _Initial;
  const factory CreateBookingState.loading() = _Loading;
  const factory CreateBookingState.success() = _Success;
  const factory CreateBookingState.failure({
    required AppFailure failure,
  }) = _Failure;

  bool get isLoading => maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
}