import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/domain/result/result.dart';
import 'package:eventix/features/events/di/events_di_providers.dart';
import 'package:eventix/features/events/domain/usecases/get_events_usecase.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/event_list_body.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_empty.dart';
import 'package:eventix/features/events/presentation/pages/event_list/widgets/list_body/widgets/event_list_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/fakes.dart';
import '../../../../../../../helpers/mocks.dart';
import '../../../../../../../helpers/pump_app.dart';
import '../../../../../helpers/events_test_data.dart';


void main() {
  late MockGetEventsUseCase mockGetEventsUseCase;

  setUpAll(() {
    registerFallbackValue(const GetEventsParams.empty());
  });

  setUp(() {
    mockGetEventsUseCase = MockGetEventsUseCase();
  });

  group('EventListBody', () {
    testWidgets('muestra un loader cuando está cargando', (tester) async {
      when(() => mockGetEventsUseCase(any())).thenAnswer(
        (_) async => const Success([]),
      );

      await tester.pumpApp(
        const Scaffold(body: EventListBody()),
        overrides: [
          getEventsUseCaseProvider.overrideWithValue(mockGetEventsUseCase),
        ],
      );

      expect(find.bySubtype<AppLoader>(), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('muestra EventListEmpty si la lista está vacía', (tester) async {
      when(() => mockGetEventsUseCase(any())).thenAnswer(
        (_) async => const Success([]),
      );

      await tester.pumpApp(
        const Scaffold(body: EventListBody()),
        overrides: [
          getEventsUseCaseProvider.overrideWithValue(mockGetEventsUseCase),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.byType(EventListEmpty), findsOneWidget);
    });

    testWidgets('muestra EventList si hay eventos', (tester) async {
      final events = [EventsTestData.makeEventEntity()];
      when(() => mockGetEventsUseCase(any())).thenAnswer(
        (_) async => Success(events),
      );

      await tester.pumpApp(
        setupIntl: true,
        const Scaffold(body: EventListBody()),
        overrides: [
          getEventsUseCaseProvider.overrideWithValue(mockGetEventsUseCase),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.byType(EventList), findsOneWidget);
    });

    testWidgets('muestra EventListError si hay una falla', (tester) async {
      when(() => mockGetEventsUseCase(any())).thenAnswer(
        (_) async => Error(FakeAppFailure()),
      );

      await tester.pumpApp(
        const Scaffold(body: EventListBody()),
        overrides: [
          getEventsUseCaseProvider.overrideWithValue(mockGetEventsUseCase),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.byType(EventListError), findsOneWidget);
    });
  });
}
