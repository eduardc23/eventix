import '../constants/booking_strings.dart';

extension DateTimeExtensionsX on DateTime {
  String get bookingTimeLabel {
    final now = DateTime.now();
    final difference = this.difference(now).inDays;
    if (difference == 0) return BookingStrings.today;
    if (difference == 1) return BookingStrings.tomorrow;
    return BookingStrings.inDaysLabel(difference);
  }
}
