class SectionsConfig {
  final String events;
  final String eventDetail;
  final String myBookings;
  final String checkout;
  final String filters;
  final String bookingConfirm;

  SectionsConfig({
    required this.events,
    required this.eventDetail,
    required this.myBookings,
    required this.checkout,
    required this.filters,
    required this.bookingConfirm,
  });

  factory SectionsConfig.fromJson(Map<String, dynamic> json) {
    return SectionsConfig(
      events: json['events'] as String,
      eventDetail: json['eventDetail'] as String,
      myBookings: json['myBookings'] as String,
      checkout: json['checkout'] as String,
      filters: json['filters'] as String,
      bookingConfirm: json['bookingConfirm'] as String,
    );
  }
}
