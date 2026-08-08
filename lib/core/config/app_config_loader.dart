import 'dart:convert';
import 'package:flutter/services.dart';
import 'app_config.dart';

class AppConfigLoader {
  static Future<AppConfig> load() async {
    final raw = await rootBundle.loadString('assets/config/app_config.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AppConfig.fromJson(json);
  }
}