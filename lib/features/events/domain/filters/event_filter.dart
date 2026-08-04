import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/quick_date_option_enum.dart';

part 'event_filter.freezed.dart';

@freezed
abstract class EventFilters with _$EventFilters {
  const factory EventFilters({
    ActiveFilter? city,
    ActiveFilter? category,
    DateFilter? date,
  }) = _EventFilters;

  const EventFilters._();

  bool get hasActiveFilters => city != null || category != null || date != null;

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
