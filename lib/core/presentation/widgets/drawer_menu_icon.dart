import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../../features/shell/presentation/pages/main_shell.dart';

class DrawerMenuIcon extends StatelessWidget {
  const DrawerMenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      Icons.menu,
      onPressed: () => MainShell.scaffoldKey.currentState?.openDrawer(),
      semanticLabel: AppConstants.openDrawerLabel,
    );
  }
}
