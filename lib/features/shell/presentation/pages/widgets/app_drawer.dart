import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../constants/main_shell_strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: AppText(
                AppStrings.appName,
                variant: AppTextVariant.headlineSmall,
              ),
            ),
          ),
          const Spacer(),
          ListTile(
            leading: AppIcon(Icons.logout, color: context.colorScheme.error),
            title: AppText(
              MainShellStrings.signOutLabel,
              color: context.colorScheme.error,
              variant: AppTextVariant.labelMedium,
            ),
            onTap: onSignOut,
          ),
          AppSpacing.md.vGap,
        ],
      ),
    );
  }
}
