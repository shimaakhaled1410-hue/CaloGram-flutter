import 'package:calogram_flutter/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const AppLogo({super.key, this.size = 64, this.showGlow = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Container(
      width: size,
      height: size,
      decoration: showGlow
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: size * 0.4,
                  spreadRadius: 2,
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset(AppConstants.logo, fit: BoxFit.contain),
      ),
    );
  }
}
