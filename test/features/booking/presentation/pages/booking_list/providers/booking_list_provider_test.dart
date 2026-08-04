import 'dart:async';

import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/di/booking_di_providers.dart';
import 'package:eventix/features/booking/domain/entities/booking_entity.dart';
import 'package:eventix/features/booking/domain/use_cases/get_bookings_by_user_usecase.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/providers/booking_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/fakes.dart';
import '../../../../../../helpers/mocks.dart';
import '../../../../../../helpers/riverpod_helpers.dart';
import '../../../../helpers/booking_test_data.dart';

const tUserId = 'user-123';

final tUpcoming1 = BookingTestData.makeBookingEntity(
  uid: 'b-future-1',
  eventDate: DateTime(2030, 3, 1), // Futuro lejano
);

final tUpcoming2 = BookingTestData.makeBookingEntity(
  uid: 'b-future-2',
  eventDate: DateTime(2030, 1, 1), // Más próximo que tUpcoming1
);

final tPast1 = BookingTestData.makeBookingEntity(
  uid: 'b-past-1',
  eventDate: DateTime(2020, 6, 1), // Pasado lejano
);

final tPast2 = BookingTestData.makeBookingEntity(
  uid: 'b-past-2',
  eventDate: DateTime(2020, 12, 1), // Más reciente que tPast1
);

final tAllBookings = [tUpcoming1, tUpcoming2, tPast1, tPast2];

void main() {
  late MockGetBookingsByUserUseCase mockUseCase;
  final tFailure = FakeAppFailure();

  setUp(() {
    mockUseCase = MockGetBookingsByUserUseCase();
    registerFallbackValue(const GetBookingsByUserParams(userId: tUserId));
  });

  group('BookingList - Carga de Reservas', () {
    test(
      'Retorna una lista vacía sin invocar el caso de uso cuando no se puede cargar el id del usuario',
      () async {
        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(null),
          ],
        );

        final result = await container.read(bookingListProvider.future);

        expect(result, isEmpty);
        verifyNever(() => mockUseCase(any()));
      },
    );

    test(
      'Obtiene y retorna la lista completa de reservas desde el caso de uso para el usuario activo',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tAllBookings));

        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
          ],
        );

        final result = await container.read(bookingListProvider.future);

        expect(result, equals(tAllBookings));
        verify(
          () => mockUseCase(
            any(
              that: predicate<GetBookingsByUserParams>(
                (p) => p.userId == tUserId,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'El estado del provider refleja un fallo cuando el caso de uso devuelve un error',
      () async {
        when(() => mockUseCase(any())).thenAnswer((_) async => Error(tFailure));

        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
          ],
        );

        final done = Completer<void>();
        final sub = container.listen(bookingListProvider, (_, next) {
          if (next.hasError && !done.isCompleted) {
            done.complete();
          }
        });

        await done.future;

        final state = container.read(bookingListProvider);
        expect(state.hasError, isTrue);
        expect(state.error, same(tFailure));

        sub.close();
      },
    );
  });

  group('BookingList - Actualización (Refresh)', () {
    test(
      'Recarga los datos invocando nuevamente al caso de uso y actualiza el estado',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tAllBookings));

        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
          ],
        );

        await container.read(bookingListProvider.future);

        final tNewBookings = [tUpcoming1];
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tNewBookings));

        await container.read(bookingListProvider.notifier).refresh();

        expect(
          await container.read(bookingListProvider.future),
          equals(tNewBookings),
        );
        verify(() => mockUseCase(any())).called(2);
      },
    );
  });

  group('UpcomingBookings - Filtrado y Orden', () {
    test('Retorna exclusivamente las reservas marcadas como futuras', () async {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => Success(tAllBookings));

      final container = createContainer(
        overrides: [
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          currentUserIdProvider.overrideWithValue(tUserId),
        ],
      );

      await container.read(bookingListProvider.future);
      final upcoming = container.read(upcomingBookingsProvider);

      expect(upcoming.every((b) => b.isFuture), isTrue);
      expect(upcoming.any((b) => b.isPast), isFalse);
    });

    test(
      'Ordena las reservas futuras de forma ascendente por fecha de evento',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tAllBookings));

        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
          ],
        );

        await container.read(bookingListProvider.future);
        final upcoming = container.read(upcomingBookingsProvider);

        // tUpcoming2 (Jan 2030) < tUpcoming1 (Mar 2030)
        expect(upcoming.first.uid, equals(tUpcoming2.uid));
        expect(upcoming.last.uid, equals(tUpcoming1.uid));
      },
    );

    test('Retorna una lista vacía si la carga principal está en proceso', () {
      final pendingResult =
          Completer<Result<List<BookingEntity>, AppFailure>>();

      when(() => mockUseCase(any())).thenAnswer((_) => pendingResult.future);

      final container = createContainer(
        overrides: [
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          currentUserIdProvider.overrideWithValue(tUserId),
        ],
      );

      expect(container.read(upcomingBookingsProvider), isEmpty);
    });

    test('Refleja un estado de error cuando el caso de uso falla', () async {
      when(() => mockUseCase(any())).thenAnswer((_) async => Error(tFailure));

      final container = createContainer(
        overrides: [
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          currentUserIdProvider.overrideWithValue(tUserId),
        ],
      );

      final done = Completer<void>();
      final sub = container.listen(bookingListProvider, (_, next) {
        if (next.error != null && !done.isCompleted) {
          done.complete();
        }
      });

      await done.future;

      final state = container.read(bookingListProvider);
      expect(state.error, isNotNull);
      expect(state.error, same(tFailure));
      expect(container.read(upcomingBookingsProvider), isEmpty);

      sub.close();
    });
  });

  group('PastBookings - Filtrado y Orden', () {
    test('Retorna exclusivamente las reservas marcadas como pasadas', () async {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => Success(tAllBookings));

      final container = createContainer(
        overrides: [
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          currentUserIdProvider.overrideWithValue(tUserId),
        ],
      );

      await container.read(bookingListProvider.future);
      final past = container.read(pastBookingsProvider);

      expect(past.every((b) => b.isPast), isTrue);
      expect(past.any((b) => b.isFuture), isFalse);
    });

    test(
      'Ordena las reservas pasadas de forma descendente (la más reciente primero)',
      () async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success(tAllBookings));

        final container = createContainer(
          overrides: [
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
          ],
        );

        await container.read(bookingListProvider.future);
        final past = container.read(pastBookingsProvider);

        // tPast2 (Dec 2020) > tPast1 (Jun 2020)
        expect(past.first.uid, equals(tPast2.uid));
        expect(past.last.uid, equals(tPast1.uid));
      },
    );
  });
}
