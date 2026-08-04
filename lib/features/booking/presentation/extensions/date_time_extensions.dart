import '../constants/booking_strings.dart';

extension DateTimeExtensionsX on DateTime {
  String get bookingTimeLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisDate = DateTime(year, month, day);
    final difference = thisDate.difference(today).inDays;

    if (difference == 0) return BookingStrings.today;
    if (difference == 1) return BookingStrings.tomorrow;
    return BookingStrings.inDaysLabel(difference);
  }
}