import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ParsedFoodCard extends StatelessWidget {
  final ScannedFoodEntity food;
  const ParsedFoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.inputBorderDark
              : AppColors.inputBorderLight,
        ),
      ),
      child: Column(
        children: [
          Text(
            food.foodName,
            style: AppTextStyles.font24BoldWhite.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'AI Confidence: ${food.confidenceScore}',
            style: AppTextStyles.font14SemiBoldLime.copyWith(
              color: primaryAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Calories', value: '${food.calories}'),
              _StatItem(label: 'Protein', value: '${food.protein}g'),
              _StatItem(label: 'Carbs', value: '${food.carbs}g'),
              _StatItem(label: 'Fats', value: '${food.fats}g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.font12MediumMuted.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.font16SemiBoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
