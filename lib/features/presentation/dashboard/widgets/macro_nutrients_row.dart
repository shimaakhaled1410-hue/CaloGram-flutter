import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class MacroNutrientsRow extends StatelessWidget {
  final int consumedProtein;
  final int targetProtein;
  final int consumedCarbs;
  final int targetCarbs;
  final int consumedFats;
  final int targetFats;

  const MacroNutrientsRow({
    super.key,
    required this.consumedProtein,
    required this.targetProtein,
    required this.consumedCarbs,
    required this.targetCarbs,
    required this.consumedFats,
    required this.targetFats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMacroCard(
          context: context,
          label: 'Protein',
          current: '${consumedProtein}g',
          target: '${targetProtein}g',
          color: Colors.blueAccent,
        ),
        const SizedBox(width: 10),
        _buildMacroCard(
          context: context,
          label: 'Carbs',
          current: '${consumedCarbs}g',
          target: '${targetCarbs}g',
          color: Colors.orangeAccent,
        ),
        const SizedBox(width: 10),
        _buildMacroCard(
          context: context,
          label: 'Fats',
          current: '${consumedFats}g',
          target: '${targetFats}g',
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildMacroCard({
    required BuildContext context,
    required String label,
    required String current,
    required String target,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.inputBorderDark
                : AppColors.inputBorderLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              current,
              style: AppTextStyles.font14MediumWhite.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'of $target',
              style: AppTextStyles.font14RegularMuted.copyWith(
                fontSize: 10,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
