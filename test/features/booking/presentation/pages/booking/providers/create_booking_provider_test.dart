import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/di/booking_di_providers.dart';
import 'package:eventix/features/booking/domain/entities/create_booking_params.dart';
import 'package:eventix/features/booking/presentation/pages/booking/providers/booking_checkout_providers.dart';
import 'package:eventix/features/booking/presentation/pages/booking/providers/create_booking_provider.dart';
import 'package:eventix/features/booking/presentation/pages/booking/providers/create_booking_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/fakes.dart';
import '../../../../../../helpers/mocks.dart';
import '../../../../../../helpers/riverpod_helpers.dart';
import '../../../../../events/helpers/events_test_data.dart';

const tUserId = 'user-123';
const tQuantity = 2;
const tTotalPrice = 200;
final tEvent = EventsTestData.tEventEntity;

void main() {
  late MockCreateBookingUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCreateBookingUseCase();
    registerFallbackValue(
      CreateBookingParams(
        userId: tUserId,
        eventId: tEvent.uid,
        eventTitle: tEvent.title,
        eventImageUrl: tEvent.imageUrl,
        eventDate: tEvent.date,
        tickets: tQuantity,
        totalPrice: tTotalPrice.toDouble(),
      ),
    );
  });

  group('CreateBookingNotifier - Estado Inicial', () {
    test('El estado inicial es CreateBookingState.initial()', () {
      final container = createContainer(
        overrides: [
          createBookingUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      expect(
        container.read(createBookingProvider),
        const CreateBookingState.initial(),
      );
    });

    test('La propiedad isLoading es falsa en el estado inicial', () {
      final container = createContainer(
        overrides: [
          createBookingUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      expect(container.read(createBookingProvider).isLoading, isFalse);
    });
  });

  group('CreateBookingNotifier - Validación de Sesión', () {
    test(
      'No ejecuta el caso de uso si el usuario no ha iniciado sesión',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(null),
          ],
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        verifyNever(() => mockUseCase(any()));
      },
    );

    test(
      'El estado permanece inicial cuando no hay una sesión activa',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(null),
          ],
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        expect(
          container.read(createBookingProvider),
          const CreateBookingState.initial(),
        );
      },
    );
  });

  group('CreateBookingNotifier - Flujo Exitoso', () {
    setUp(() {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Success(null));
    });

    test(
      'Emite estado de carga y luego éxito tras completar la reserva',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
            bookingQuantityProvider(tEvent).overrideWithValue(tQuantity),
            bookingTotalPriceProvider(tEvent).overrideWithValue(tTotalPrice),
          ],
        );

        final states = <CreateBookingState>[];
        container.listen(
          createBookingProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        expect(states, [
          const CreateBookingState.loading(),
          const CreateBookingState.success(),
        ]);
      },
    );

    test(
      'Llama al caso de uso con los parámetros de reserva correctos',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
            bookingQuantityProvider(tEvent).overrideWithValue(tQuantity),
            bookingTotalPriceProvider(tEvent).overrideWithValue(tTotalPrice),
          ],
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        verify(
          () => mockUseCase(
            any(
              that: predicate<CreateBookingParams>(
                (p) =>
                    p.userId == tUserId &&
                    p.tickets == tQuantity &&
                    p.totalPrice == tTotalPrice.toDouble() &&
                    p.eventId == tEvent.uid,
                'Parámetros con userId, cantidad, precio y evento correctos',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('CreateBookingNotifier - Flujo de Error', () {
    final tFailure = FakeAppFailure();

    setUp(() {
      when(() => mockUseCase(any())).thenAnswer((_) async => Error(tFailure));
    });

    test(
      'Emite estado de carga y luego fallo ante un error en la operación',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
            bookingQuantityProvider(tEvent).overrideWithValue(tQuantity),
            bookingTotalPriceProvider(tEvent).overrideWithValue(tTotalPrice),
          ],
        );

        final states = <CreateBookingState>[];
        container.listen(
          createBookingProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        expect(states, [
          const CreateBookingState.loading(),
          CreateBookingState.failure(failure: tFailure),
        ]);
      },
    );

    test(
      'El estado de fallo contiene la información del error devuelto',
      () async {
        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
            bookingQuantityProvider(tEvent).overrideWithValue(tQuantity),
            bookingTotalPriceProvider(tEvent).overrideWithValue(tTotalPrice),
          ],
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        final state = container.read(createBookingProvider);

        state.whenOrNull(
          failure: (failure) => expect(failure, equals(tFailure)),
        );
      },
    );
  });

  group('CreateBookingNotifier - Llamadas Consecutivas', () {
    test(
      'Reinicia el flujo de carga ante un nuevo intento tras un fallo previo',
      () async {
        final tFailure = FakeAppFailure();

        // Primer intento fallido
        when(() => mockUseCase(any())).thenAnswer((_) async => Error(tFailure));

        final container = createContainer(
          overrides: [
            createBookingUseCaseProvider.overrideWithValue(mockUseCase),
            currentUserIdProvider.overrideWithValue(tUserId),
            bookingQuantityProvider(tEvent).overrideWithValue(tQuantity),
            bookingTotalPriceProvider(tEvent).overrideWithValue(tTotalPrice),
          ],
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        expect(
          container.read(createBookingProvider),
          CreateBookingState.failure(failure: tFailure),
        );

        // Segundo intento exitoso
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Success(null));

        final states = <CreateBookingState>[];
        container.listen(
          createBookingProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await container
            .read(createBookingProvider.notifier)
            .createBooking(tEvent);

        expect(states.first, const CreateBookingState.loading());
        expect(states.last, const CreateBookingState.success());
      },
    );
  });
}
