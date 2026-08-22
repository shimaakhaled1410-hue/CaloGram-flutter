import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class CalorieProgressCard extends StatelessWidget {
  final int consumedCalories;
  final int targetCalories;

  const CalorieProgressCard({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    final int remaining = targetCalories - consumedCalories;
    final double progress = targetCalories > 0
        ? (consumedCalories / targetCalories).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorderDark, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Calories', style: AppTextStyles.font14RegularMuted),
                const SizedBox(height: 6),
                Text(
                  '${remaining < 0 ? 0 : remaining}',
                  style: AppTextStyles.font28BoldWhite.copyWith(
                    color: AppColors.primaryNeonLime,
                    fontSize: 32,
                  ),
                ),
                Text('kcal remaining', style: AppTextStyles.font14MediumWhite),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 9,
                  backgroundColor: AppColors.cardDarkElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryNeonLime,
                  ),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.font16BoldDark.copyWith(
                      color: AppColors.textMainDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
