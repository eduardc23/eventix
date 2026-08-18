import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/di/booking_di_providers.dart';
import 'package:eventix/features/booking/domain/entities/booking_entity.dart';
import 'package:eventix/features/booking/domain/failures/booking_failures.dart';
import 'package:eventix/features/booking/domain/use_cases/get_bookings_by_user_usecase.dart';
import 'package:eventix/features/booking/presentation/constants/booking_strings.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_list_body.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_list_empty_state.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_list_error.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/accessibility_helper.dart';
import '../../../../../../helpers/mocks.dart';
import '../../../../../../helpers/pump_app.dart';
import '../../../../../../helpers/test_app_config.dart';
import '../../../../helpers/booking_test_data.dart';

void main() {
  late MockGetBookingsByUserUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const GetBookingsByUserParams(userId: ''));
  });

  setUp(() {
    mockUseCase = MockGetBookingsByUserUseCase();
  });

  const userId = 'user-123';

  group('BookingListBody - Estados de la Interfaz', () {
    testWidgets(
      'Muestra el indicador de carga al iniciar la obtención de datos',
      (tester) async {
        final completer = Completer<Result<List<BookingEntity>, AppFailure>>();
        when(() => mockUseCase(any())).thenAnswer((_) => completer.future);

        await tester.pumpApp(
          const Scaffold(body: BookingListBody()),
          overrides: [
            currentUserIdProvider.overrideWithValue(userId),
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        expect(find.bySubtype<AppLoader>(), findsOneWidget);
      },
    );

    testWidgets(
      'Visualiza el estado de error cuando la carga de reservas falla',
      (tester) async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Error(BookingFailure.noSpotsAvailable()));

        await tester.pumpApp(
          const Scaffold(body: BookingListBody()),
          overrides: [
            currentUserIdProvider.overrideWithValue(userId),
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await tester.pumpAndSettle();

        expect(find.byType(BookingListError), findsOneWidget);
        expect(find.text(testAppConfig.alerts.noSpots.message), findsOneWidget);
      },
    );

    testWidgets(
      'Muestra el estado vacío si la lista de reservas no contiene elementos',
      (tester) async {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Success([]));

        await tester.pumpApp(
          const Scaffold(body: BookingListBody()),
          overrides: [
            currentUserIdProvider.overrideWithValue(userId),
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await tester.pumpAndSettle();

        expect(find.byType(BookingListEmptyState), findsOneWidget);
        expect(
          find.text(testAppConfig.emptyMessages.bookings.title),
          findsOneWidget,
        );
      },
    );
  });

  group('BookingListBody - Organización de Contenido', () {
    testWidgets(
      'Divide y presenta las reservas en secciones de próximas y pasadas',
      (tester) async {
        final upcoming = BookingTestData.makeBookingEntity(
          uid: '1',
          eventDate: DateTime.now().add(const Duration(days: 2)),
          eventTitle: 'Futuro Evento',
        );
        final past = BookingTestData.makeBookingEntity(
          uid: '2',
          eventDate: DateTime.now().subtract(const Duration(days: 2)),
          eventTitle: 'Pasado Evento',
        );

        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => Success([upcoming, past]));

        await tester.pumpApp(
          const Scaffold(body: BookingListBody()),
          overrides: [
            currentUserIdProvider.overrideWithValue(userId),
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );

        await tester.pumpAndSettle();

        expect(find.text(BookingStrings.upcomingSection), findsOneWidget);
        expect(find.text(BookingStrings.pastSection), findsOneWidget);
        expect(find.text('Futuro Evento'), findsOneWidget);
        expect(find.text('Pasado Evento'), findsOneWidget);
        expect(find.byType(BookingSection), findsNWidgets(2));
      },
    );
  });

  testWidgets('BookingListBody cumple guías de accesibilidad', (tester) async {
    final upcoming = BookingTestData.makeBookingEntity(
      uid: '1',
      eventDate: DateTime.now().add(const Duration(days: 2)),
      eventTitle: 'Futuro Evento',
    );
    final past = BookingTestData.makeBookingEntity(
      uid: '2',
      eventDate: DateTime.now().subtract(const Duration(days: 2)),
      eventTitle: 'Pasado Evento',
    );

    when(
      () => mockUseCase(any()),
    ).thenAnswer((_) async => Success([upcoming, past]));

    await tester.pumpApp(
      const Scaffold(body: BookingListBody()),
      overrides: [
        currentUserIdProvider.overrideWithValue(userId),
        getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );

    await tester.pumpAndSettle();

    await tester.checkAccessibility();
  });

  testWidgets('BookingListBody cumple guías de accesibilidad en estado vacío', (
    tester,
  ) async {
    when(() => mockUseCase(any())).thenAnswer((_) async => const Success([]));

    await tester.pumpApp(
      const Scaffold(body: BookingListBody()),
      overrides: [
        currentUserIdProvider.overrideWithValue(userId),
        getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );

    await tester.pumpAndSettle();

    await tester.checkAccessibility();
  });

  testWidgets(
    'BookingListBody cumple guías de accesibilidad en estado de error',
    (tester) async {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => Error(BookingFailure.noSpotsAvailable()));

      await tester.pumpApp(
        const Scaffold(body: BookingListBody()),
        overrides: [
          currentUserIdProvider.overrideWithValue(userId),
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      await tester.pumpAndSettle();

      await tester.checkAccessibility();
    },
  );
}
