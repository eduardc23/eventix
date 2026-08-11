import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config_loader.dart';
import 'core/config/app_config_provider.dart';
import 'core/domain/failures/config_failures.dart';
import 'core/domain/result/result.dart';
import 'core/presentation/pages/config_error_page.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppKit.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final result = await AppConfigLoader.load();

  switch (result) {
    case Success(:final value):
      runApp(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(value)],
          child: const MyApp(),
        ),
      );

    case Error(:final error):
      runApp(ConfigErrorApp(failure: error));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

class ConfigErrorApp extends StatelessWidget {
  final ConfigFailure failure;

  const ConfigErrorApp({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: ConfigErrorPage(failure: failure),
    );
  }
}
