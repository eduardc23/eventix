import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: Center(child: CircularProgressIndicator()));
  }
}
