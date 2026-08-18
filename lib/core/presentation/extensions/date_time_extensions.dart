import 'package:intl/intl.dart';

import '../../constants/app_locale.dart';

extension AppDateTimeX on DateTime {
  /// "sáb 20 sep"
  String toEventDatePart({String locale = AppLocale.code}) {
    return DateFormat('EEE d MMM', locale).format(this);
  }

  /// "20:00 h"
  String toEventTimePart({String locale = AppLocale.code}) {
    return '${DateFormat('HH:mm', locale).format(this)} h';
  }

  /// "sáb 20 sep · 20:00 h"
  String toEventDate({String locale = AppLocale.code}) =>
      '${toEventDatePart(locale: locale)} · ${toEventTimePart(locale: locale)}';

  /// Para screen readers: "sábado 20 de septiembre a las 20:00"
  String toEventDateSemantic({String locale = AppLocale.code}) {
    final datePart = DateFormat("EEEE d 'de' MMMM", locale).format(this);
    final timePart = DateFormat('HH:mm', locale).format(this);
    return '$datePart a las $timePart';
  }
}
