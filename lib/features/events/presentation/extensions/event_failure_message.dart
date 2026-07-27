import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/failures/core_failures.dart';
import '../../../../core/presentation/extensions/core_failure_message.dart';
import '../constants/events_strings.dart';

extension EventFailureMessageX on AppFailure {
  String get toEventMessage {
    return switch (this) {
      // Cuando se tenga failures propios del feature:
      // EventFailure eventFailure => switch (eventFailure) {
      //   EventNotFoundFailure() => 'El evento no fue encontrado.',
      // },
      CoreFailure coreFailure => coreFailure.errorMessage,
      _ => EventsStrings.unexpectedError,
    };
  }
}
