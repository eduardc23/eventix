import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/app_config_loader.dart';
import 'core/config/app_config_provider.dart';
import 'core/constants/app_locale.dart';
import 'core/domain/failures/config_failures.dart';
import 'core/domain/result/result.dart';
import 'core/presentation/pages/config_error_page.dart';
import 'core/presentation/widgets/environment_banner.dart';
import 'core/router/app_router.dart';

Future<void> mainCommon(FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppKit.initialize();
  await initializeDateFormatting();
  await Firebase.initializeApp(options: firebaseOptions);
  final result = await AppConfigLoader.load();

  switch (result) {
    case Success(:final value):
      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(value),
          ],
          child: const EventixApp(),
        ),
      );
    case Error(:final error):
      runApp(ConfigErrorApp(failure: error));
  }
}

class EventixApp extends ConsumerWidget {
  const EventixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      locale: AppLocale.locale,
      supportedLocales: const [AppLocale.locale],
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) => EnvironmentBanner(child: child!),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
