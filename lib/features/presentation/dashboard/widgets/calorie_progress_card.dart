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
    final bool isOverTarget = consumedCalories > targetCalories;
    final int difference = isOverTarget
        ? consumedCalories - targetCalories
        : targetCalories - consumedCalories;

    final double progress = targetCalories > 0
        ? (consumedCalories / targetCalories).clamp(0.0, 1.0)
        : 0.0;

    final Color statusColor = isOverTarget
        ? const Color(0xFFEF4444)
        : AppColors.primaryNeonLime;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isOverTarget
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : AppColors.inputBorderDark,
          width: 1,
        ),
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
                  '$difference',
                  style: AppTextStyles.font28BoldWhite.copyWith(
                    color: statusColor,
                    fontSize: 32,
                  ),
                ),
                Text(
                  isOverTarget ? 'kcal over target ⚠️' : 'kcal remaining',
                  style: AppTextStyles.font14MediumWhite.copyWith(
                    color: isOverTarget
                        ? const Color(0xFFEF4444)
                        : Colors.white,
                  ),
                ),
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
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    isOverTarget
                        ? '${((consumedCalories / targetCalories) * 100).toInt()}%'
                        : '${(progress * 100).toInt()}%',
                    style: AppTextStyles.font16BoldDark.copyWith(
                      color: isOverTarget
                          ? const Color(0xFFEF4444)
                          : AppColors.textMainDark,
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
