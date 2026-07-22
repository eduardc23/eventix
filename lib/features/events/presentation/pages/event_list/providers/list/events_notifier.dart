import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../../core/domain/result/result.dart';
import '../../../../../di/events_di_providers.dart';
import '../../../../../domain/entities/event_entity.dart';
import '../../../../../domain/usecases/get_events_usecase.dart';
import '../filters/event_filters_providers.dart';

part 'events_notifier.g.dart';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  Future<List<EventEntity>> build() async {
    final filters = ref.watch(appliedEventFiltersProvider);

    final params = GetEventsParams(
      categoryId: filters.category?.id,
      cityId: filters.city?.id,
      dateFilter: filters.date,
    );

    return _fetchEvents(params);
  }

  Future<List<EventEntity>> _fetchEvents(GetEventsParams params) async {
    final result = await ref.read(getEventsUseCaseProvider)(params);

    return switch (result) {
      Success(:final value) => value,
      Error(:final error) => throw error,
    };
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
