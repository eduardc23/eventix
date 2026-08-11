import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/exceptions/config_exceptions.dart';
import '../domain/failures/config_failures.dart';
import '../domain/result/result.dart';
import 'app_config.dart';

class AppConfigLoader {
  static Future<Result<AppConfig, ConfigFailure>> load() async {
    try {
      final raw = await rootBundle.loadString('assets/config/app_config.json');
      final decoded = jsonDecode(raw);

      if (decoded is! Map<String, dynamic>) {
        return Error(const ConfigFailure.load());
      }

      return Success(AppConfig.fromJson(decoded));

    } on ConfigSectionException catch (e) {
      return Error(ConfigFailure.section(section: e.section));

    } catch (e) {
      return Error(const ConfigFailure.load());
    }
  }
}