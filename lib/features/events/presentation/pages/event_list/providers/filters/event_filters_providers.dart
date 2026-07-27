import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/enums/quick_date_option_enum.dart';
import '../../../../../domain/filters/event_filter.dart';

part 'event_filters_providers.g.dart';

// Fuente de verdad
@riverpod
class AppliedEventFilters extends _$AppliedEventFilters {
  @override
  EventFilters build() => EventFilters.empty;

  void apply(EventFilters filters) => state = filters;

  void clearAll() => state = EventFilters.empty;

  // Clears individuales para la FiltersBar
  void clearCategory() => state = state.copyWith(category: null);

  void clearCity() => state = state.copyWith(city: null);

  void clearDate() => state = state.copyWith(date: null);
}

@riverpod
class DraftEventFilters extends _$DraftEventFilters {

  @override
  EventFilters build() => ref.watch(appliedEventFiltersProvider);

  // ─── Category ──────────────────────────────────────────────────────────────

  void toggleCategory(String id, String name) {
    final isAlreadySelected = state.category?.id == id;
    state = state.copyWith(
      category: isAlreadySelected ? null : ActiveFilter(id: id, name: name),
    );
  }

  // ─── City ──────────────────────────────────────────────────────────────────

  void toggleCity(String id, String name) {
    final isAlreadySelected = state.city?.id == id;
    state = state.copyWith(
      city: isAlreadySelected ? null : ActiveFilter(id: id, name: name),
    );
  }

  // ─── Date ──────────────────────────────────────────────────────────────────

  void toggleQuickDate(QuickDateOption option) {
    final currentQuick = switch (state.date) {
      DateFilterQuick(:final option) => option,
      _ => null,
    };
    final isAlreadySelected = currentQuick == option;
    state = state.copyWith(
      date: isAlreadySelected ? null : option.asDateFilter,
    );
  }

  void selectDateRange(DateTime from, DateTime to) {
    state = state.copyWith(
      date: DateFilter.range(from: from, to: to),
    );
  }

  void clearDateRange() {
    if (state.date is DateFilterRange) {
      state = state.copyWith(date: null);
    }
  }

  /// Limpia todos los filtros seleccionados en el draft.
  void reset() => state = EventFilters.empty;

  /// Persiste el draft como filtros aplicados y cierra el ciclo.
  void commit() => ref.read(appliedEventFiltersProvider.notifier).apply(state);
}
