import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/domain/use_cases/create_booking_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../helpers/booking_test_data.dart';

void main() {
  late MockBookingRepository mockRepository;
  late CreateBookingUseCase useCase;

  setUpAll(() {
    registerFallbackValue(BookingTestData.tCreateBookingParams);
  });

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CreateBookingUseCase(mockRepository);
  });

  group('CreateBookingUseCase - Ejecución', () {
    final tParams = BookingTestData.tCreateBookingParams;

    test(
      'Llamada a createBooking en el repositorio con los parámetros correctos',
      () async {
        when(() => mockRepository.createBooking(any()))
            .thenAnswer((_) async => const Success(null));

        await useCase(tParams);

        verify(() => mockRepository.createBooking(tParams)).called(1);
      },
    );

    test(
      'Retorno de Success cuando la creación es exitosa',
      () async {
        when(() => mockRepository.createBooking(any()))
            .thenAnswer((_) async => const Success(null));

        final result = await useCase(tParams);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      'Propagación del fallo cuando el repositorio falla',
      () async {
        final failure = FakeAppFailure();
        when(() => mockRepository.createBooking(any()))
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
