class AlertsConfig {
  final AlertDetailConfig bookingSuccess;
  final AlertDetailConfig noSpots;
  final String paymentProcessed;

  AlertsConfig({
    required this.bookingSuccess,
    required this.noSpots,
    required this.paymentProcessed,
  });

  factory AlertsConfig.fromJson(Map<String, dynamic> json) {
    return AlertsConfig(
      bookingSuccess: AlertDetailConfig.fromJson(json['bookingSuccess'] as Map<String, dynamic>),
      noSpots: AlertDetailConfig.fromJson(json['noSpots'] as Map<String, dynamic>),
      paymentProcessed: json['paymentProcessed'] as String,
    );
  }
}

class AlertDetailConfig {
  final String title;
  final String message;

  AlertDetailConfig({
    required this.title,
    required this.message,
  });

  factory AlertDetailConfig.fromJson(Map<String, dynamic> json) {
    return AlertDetailConfig(
      title: json['title'] as String,
      message: json['message'] as String,
    );
  }
}
