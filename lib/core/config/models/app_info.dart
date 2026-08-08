class AppInfo {
  final String name;

  AppInfo({required this.name});

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      name: json['name'] as String,
    );
  }
}
