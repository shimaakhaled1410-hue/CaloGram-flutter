import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationCardContainer extends StatelessWidget {
  final List<Widget> children;

  const NotificationCardContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark ? null : AppColors.cardGlowLight(opacity: 0.05),
      ),
      child: Material(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark
                ? AppColors.inputBorderDark
                : AppColors.cardLightBorder,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }
}
