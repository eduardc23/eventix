import 'package:eventix/core/data/mappers/core_exception_mapper.dart';
import 'package:eventix/core/data/mappers/firebase_exception_mapper.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseExceptionMapper extends Mock implements FirebaseExceptionMapper {}
class MockCoreExceptionMapper extends Mock implements CoreExceptionMapper {}
