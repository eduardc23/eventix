class DefaultsConfig {
  final List<DefaultCategoryConfig> categories;

  DefaultsConfig({required this.categories});

  factory DefaultsConfig.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'] as List<dynamic>;

    return DefaultsConfig(
      categories: List<DefaultCategoryConfig>.unmodifiable(
        rawCategories.map(
          (category) =>
              DefaultCategoryConfig.fromJson(category as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class DefaultCategoryConfig {
  final String uid;
  final String name;

  const DefaultCategoryConfig({required this.uid, required this.name});

  factory DefaultCategoryConfig.fromJson(Map<String, dynamic> json) {
    return DefaultCategoryConfig(
      uid: json['uid'] as String,
      name: json['name'] as String,
    );
  }
}
