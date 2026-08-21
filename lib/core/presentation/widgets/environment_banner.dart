import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/flavor.dart';

class EnvironmentBanner extends StatelessWidget {
  final Widget child;

  const EnvironmentBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (appFlavor == Flavor.dev) {
      return Banner(
        message: Flavor.dev.toUpperCase(),
        location: BannerLocation.topStart,
        color: Colors.red,
        child: child,
      );
    }
    return child;
  }
}
