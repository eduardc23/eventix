import '../../domain/failures/app_failure.dart';

extension AsyncValueFailureX on Object {
  AppFailure get asFailure => this as AppFailure;
}
