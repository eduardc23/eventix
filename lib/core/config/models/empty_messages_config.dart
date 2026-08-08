class EmptyMessagesConfig {
  final EmptyMessageDetailConfig events;
  final EmptyMessageDetailConfig bookings;

  EmptyMessagesConfig({
    required this.events,
    required this.bookings,
  });

  factory EmptyMessagesConfig.fromJson(Map<String, dynamic> json) {
    return EmptyMessagesConfig(
      events: EmptyMessageDetailConfig.fromJson(json['events'] as Map<String, dynamic>),
      bookings: EmptyMessageDetailConfig.fromJson(json['bookings'] as Map<String, dynamic>),
    );
  }
}

class EmptyMessageDetailConfig {
  final String title;
  final String description;

  EmptyMessageDetailConfig({
    required this.title,
    required this.description,
  });

  factory EmptyMessageDetailConfig.fromJson(Map<String, dynamic> json) {
    return EmptyMessageDetailConfig(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
