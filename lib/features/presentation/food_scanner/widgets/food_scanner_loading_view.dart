import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class FoodScannerLoadingView extends StatelessWidget {
  const FoodScannerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryAccent =
        isDark ? AppColors.primaryNeonLime : AppColors.primaryLimeDark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryAccent),
          const SizedBox(height: 16),
          Text(
            'Analyzing meal nutrition with AI...',
            style: AppTextStyles.font14RegularMuted.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}