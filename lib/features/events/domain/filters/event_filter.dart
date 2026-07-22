import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';


@freezed
abstract class EventFilters with _$EventFilters {
  const factory EventFilters({
    ActiveFilter? city,
    ActiveFilter? category,
    DateFilter? date,
  }) = _EventFilters;

  const EventFilters._();

  bool get hasActiveFilters =>
      city != null || category != null || date != null;

  static const empty = EventFilters();
}


@freezed
abstract class ActiveFilter with _$ActiveFilter {
  const factory ActiveFilter({required String id, required String name}) =
      _ActiveFilter;
}

// ─── Date filter ────────────────────────────────────────────

@freezed
sealed class DateFilter with _$DateFilter {
  /// Opción rápida predefinida (Hoy, Esta semana, etc.).
  const factory DateFilter.quick({required QuickDateOption option}) =
      DateFilterQuick;

  /// Rango personalizado seleccionado por el usuario.
  const factory DateFilter.range({
    required DateTime from,
    required DateTime to,
  }) = DateFilterRange;
}

// ─── Quick date options ───────────────────────────────────────────────────────

enum QuickDateOption {
  today,
  thisWeek,
  thisWeekend,
  thisMonth;

  ({DateTime start, DateTime end}) get range {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (this) {
      QuickDateOption.today => (
        start: today,
        end: today.add(const Duration(days: 1)),
      ),
      QuickDateOption.thisWeek => (
        start: today,
        end: today.add(Duration(days: 7 - today.weekday)),
      ),
      QuickDateOption.thisWeekend => _weekendRange(today),
      QuickDateOption.thisMonth => (
        start: today,
        end: DateTime(now.year, now.month + 1, 0),
      ),
    };
  }

  static ({DateTime start, DateTime end}) _weekendRange(DateTime today) {
    final daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
    final saturday = today.add(Duration(days: daysUntilSaturday));
    return (start: saturday, end: saturday.add(const Duration(days: 2)));
  }

  DateFilter get asDateFilter => DateFilter.quick(option: this);
}
