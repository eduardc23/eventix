class UiConfig {
  final double filtersInitialSize;
  final double filtersMinSize;
  final double filtersMaxSize;
  final int dateRangeMaxDays;

  UiConfig({
    required this.filtersInitialSize,
    required this.filtersMinSize,
    required this.filtersMaxSize,
    required this.dateRangeMaxDays,
  });

  factory UiConfig.fromJson(Map<String, dynamic> json) {
    return UiConfig(
      filtersInitialSize: (json['filtersInitialSize'] as num).toDouble(),
      filtersMinSize: (json['filtersMinSize'] as num).toDouble(),
      filtersMaxSize: (json['filtersMaxSize'] as num).toDouble(),
      dateRangeMaxDays: json['dateRangeMaxDays'] as int,
    );
  }
}
