import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class TodayMealItem extends StatelessWidget {
  final String title;
  final String details;
  final String calories;
  final IconData icon;

  const TodayMealItem({
    super.key,
    required this.title,
    required this.details,
    required this.calories,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent =
        isDark ? AppColors.primaryNeonLime : AppColors.primaryLimeDark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark ? AppColors.inputBorderDark : AppColors.inputBorderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardDarkElevated
                  : AppColors.cardLightElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryAccent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font14MediumWhite.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            calories,
            style: AppTextStyles.font14SemiBoldLime.copyWith(
              color: primaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}