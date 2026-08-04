import 'package:eventix/core/data/exceptions/app_exception.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:mocktail/mocktail.dart';

/// Fakes genéricos para errores y fallos
class FakeAppFailure extends Fake implements AppFailure {}

class FakeAppException extends Fake implements AppException {}
