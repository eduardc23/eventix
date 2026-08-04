import '../filters/event_filter.dart';

enum QuickDateOption {
  today,
  thisWeek,
  thisWeekend,
  thisMonth;

  ({DateTime start, DateTime end}) range([DateTime? now]) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);

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
        end: DateTime(reference.year, reference.month + 1, 0),
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
