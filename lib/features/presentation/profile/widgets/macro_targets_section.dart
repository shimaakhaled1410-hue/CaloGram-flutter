import 'package:calogram_flutter/features/presentation/profile/widgets/profile_text_file.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class MacroTargetsSection extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;

  const MacroTargetsSection({
    super.key,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fatsController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Nutrition Targets',
          style: AppTextStyles.font18SemiBoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ProfileTextField(
          label: 'Daily Target Calories (kcal)',
          controller: caloriesController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileTextField(
                label: 'Protein (g)',
                controller: proteinController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileTextField(
                label: 'Carbs (g)',
                controller: carbsController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileTextField(
                label: 'Fats (g)',
                controller: fatsController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}