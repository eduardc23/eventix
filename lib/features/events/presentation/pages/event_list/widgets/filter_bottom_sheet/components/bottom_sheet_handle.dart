import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSpacing.xxxl,
        height: AppSpacing.xxs,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(AppSpacing.xxxs),
        ),
      ),
    );
  }
}
