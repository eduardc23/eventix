import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/di/core_di_providers.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/booking/di/booking_di_providers.dart';
import 'package:eventix/features/booking/domain/failures/booking_failures.dart';
import 'package:eventix/features/booking/domain/use_cases/get_bookings_by_user_usecase.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/booking_list_page.dart';
import 'package:eventix/features/booking/presentation/pages/booking_list/widgets/booking_list_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/accessibility_helper.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_app_config.dart';

void main() {
  late MockGetBookingsByUserUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const GetBookingsByUserParams(userId: ''));
  });

  setUp(() {
    mockUseCase = MockGetBookingsByUserUseCase();
  });

  group('BookingListPage - Renderizado', () {
    testWidgets(
      'Componentes principales (Scaffold, TopBar y Body) presentes en la interfaz',
      (WidgetTester tester) async {
        when(() => mockUseCase(any())).thenAnswer((_) async => const Success([]));
        await tester.pumpApp(
          const BookingListPage(),
          overrides: [
            currentUserIdProvider.overrideWithValue('user-123'),
            getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
          ],
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppScaffold), findsOneWidget);
        expect(find.byType(AppTopBar), findsOneWidget);
        expect(find.byType(BookingListBody), findsOneWidget);
      },
    );
  });

  group('BookingListPage - Contenido', () {
    testWidgets('Título de la página visible en la barra superior', (
      WidgetTester tester,
    ) async {
      when(() => mockUseCase(any())).thenAnswer((_) async => const Success([]));
      await tester.pumpApp(
        const BookingListPage(),
        overrides: [
          currentUserIdProvider.overrideWithValue('user-123'),
          getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text(testAppConfig.sections.myBookings), findsOneWidget);
    });
  });

  testWidgets('BookingListPage cumple guías de accesibilidad', (tester) async {
    when(() => mockUseCase(any())).thenAnswer((_) async => const Success([]));
    await tester.pumpApp(
      const BookingListPage(),
      overrides: [
        currentUserIdProvider.overrideWithValue('user-123'),
        getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
    await tester.pumpAndSettle();
    await tester.checkAccessibility();
  });

  testWidgets('BookingListPage cumple guías de accesibilidad en estado vacío', (
    tester,
  ) async {
    when(() => mockUseCase(any())).thenAnswer((_) async => const Success([]));
    await tester.pumpApp(
      const BookingListPage(),
      overrides: [
        currentUserIdProvider.overrideWithValue('user-123'),
        getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
    await tester.pumpAndSettle();
    await tester.checkAccessibility();
  });

  testWidgets('BookingListPage cumple guías de accesibilidad en estado de error', (
    tester,
  ) async {
    when(() => mockUseCase(any())).thenAnswer(
      (_) async => Error(BookingFailure.noSpotsAvailable()),
    );
    await tester.pumpApp(
      const BookingListPage(),
      overrides: [
        currentUserIdProvider.overrideWithValue('user-123'),
        getBookingsByUserUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
    await tester.pumpAndSettle();
    await tester.checkAccessibility();
  });
}
