import '../../../../core/domain/failures/app_failure.dart';
import '../../../../core/domain/result/result.dart';
import '../../../../core/domain/use_cases/use_cases.dart';
import '../entities/event_entity.dart';
import '../filters/event_filter.dart';
import '../repositories/events_repository.dart';

class GetEventsUseCase implements UseCase<List<EventEntity>, GetEventsParams> {
  const GetEventsUseCase(this._repository);

  final EventsRepository _repository;

  @override
  Future<Result<List<EventEntity>, AppFailure>> call(GetEventsParams params) {
    final (
      DateTime? startDate,
      DateTime? endDate,
    ) = switch (params.dateFilter) {
      DateFilterQuick(:final option) => (option.range.start, option.range.end),
      DateFilterRange(:final from, :final to) => (from, to),
      null => (null, null),
    };

    return _repository.getEvents(
      categoryId: params.categoryId,
      cityId: params.cityId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetEventsParams {
  const GetEventsParams({this.categoryId, this.cityId, this.dateFilter});

  const GetEventsParams.empty()
    : categoryId = null,
      cityId = null,
      dateFilter = null;

  final String? categoryId;
  final String? cityId;
  final DateFilter? dateFilter;
}
