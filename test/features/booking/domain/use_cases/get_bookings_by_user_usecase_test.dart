import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/domain/use_cases/get_bookings_by_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  late MockBookingRepository mockRepository;
  late GetBookingsByUserUseCase useCase;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetBookingsByUserUseCase(mockRepository);
  });

  group('GetBookingsByUserUseCase - Ejecución', () {
    const tUserId = 'user123';
    const tParams = GetBookingsByUserParams(userId: tUserId);
    final tBookingList = [BookingTestData.tBookingEntity];

    test(
      'Llamada a getBookingsByUser en el repositorio con el userId correcto',
      () async {
        when(() => mockRepository.getBookingsByUser(userId: any(named: 'userId')))
            .thenAnswer((_) async => Success(tBookingList));

        await useCase(tParams);

        verify(() => mockRepository.getBookingsByUser(userId: tUserId)).called(1);
      },
    );

    test(
      'Retorno de lista de reservas cuando la consulta es exitosa',
      () async {
        when(() => mockRepository.getBookingsByUser(userId: any(named: 'userId')))
            .thenAnswer((_) async => Success(tBookingList));

        final result = await useCase(tParams);

        expect(result.isSuccess, isTrue);
        expect(
          result.when(success: (val) => val, error: (_) => null),
          equals(tBookingList),
        );
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(() => mockRepository.getBookingsByUser(userId: any(named: 'userId')))
            .thenAnswer((_) async => Error(failure));

        final result = await useCase(tParams);

        expect(result.isError, isTrue);
        expect(
          result.when(success: (_) => null, error: (e) => e),
          equals(failure),
        );
      },
    );
  });
}
