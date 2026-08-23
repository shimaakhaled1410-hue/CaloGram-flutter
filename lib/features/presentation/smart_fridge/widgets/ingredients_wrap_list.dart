import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class IngredientsWrapList extends StatelessWidget {
  final List<String> ingredients;
  final ValueChanged<String> onDelete;

  const IngredientsWrapList({
    super.key,
    required this.ingredients,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map((item) {
        return Chip(
          backgroundColor: theme.colorScheme.surface,
          side: BorderSide(color: primaryAccent.withValues(alpha: 0.5)),
          label: Text(
            item,
            style: AppTextStyles.font14MediumWhite.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          deleteIcon: Icon(
            Icons.close,
            size: 18,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          onDeleted: () => onDelete(item),
        );
      }).toList(),
    );
  }
}
