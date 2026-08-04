import 'package:eventix/features/auth/data/datasource/auth_datasource.dart';
import 'package:eventix/features/auth/data/mappers/auth_exception_mapper.dart';
import 'package:eventix/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:eventix/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:mocktail/mocktail.dart';

// --- Feature DataSources ---
class MockAuthDataSource extends Mock implements AuthDataSource {}

// --- Feature Repositories ---
class MockAuthRepository extends Mock implements AuthRepository {}

// --- Feature Use Cases ---
class MockSignOutUseCase extends Mock implements SignOutUseCase {}
class MockSignInUseCase extends Mock implements SignInUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}

// --- Feature Mappers ---
class MockAuthExceptionMapper extends Mock implements AuthExceptionMapper {}
class MockFirebaseAuthExceptionMapper extends Mock implements FirebaseAuthExceptionMapper {}
