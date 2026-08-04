import '../../domain/enums/quick_date_option_enum.dart';
import '../constants/events_strings.dart';

extension QuickDateOptionDisplayX on QuickDateOption {
  /// Retorna el texto legible para el usuario en la UI
  String get label {
    return switch (this) {
      QuickDateOption.today => EventsStrings.dateToday,
      QuickDateOption.thisWeek => EventsStrings.dateThisWeek,
      QuickDateOption.thisWeekend => EventsStrings.dateThisWeekend,
      QuickDateOption.thisMonth => EventsStrings.dateThisMonth,
    };
  }
}
