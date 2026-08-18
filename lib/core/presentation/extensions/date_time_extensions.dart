import 'package:intl/intl.dart';

extension AppDateTimeX on DateTime {
  /// Para mostrar en UI: "Sáb 20 Sep · 20:00 h"
  String toEventDate({String locale = 'es'}) {
    final datePart = DateFormat('EEE d MMM', locale).format(this);
    final timePart = DateFormat('HH:mm', locale).format(this);
    return '$datePart · $timePart h';
  }

  /// Para screen readers: "sábado 20 de septiembre a las 20:00"
  String toEventDateSemantic({String locale = 'es'}) {
    final datePart = DateFormat("EEEE d 'de' MMMM", locale).format(this);
    final timePart = DateFormat('HH:mm', locale).format(this);
    return '$datePart a las $timePart';
  }
}
