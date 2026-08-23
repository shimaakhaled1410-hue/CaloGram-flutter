import 'package:calogram_flutter/features/presentation/profile/widgets/profile_text_file.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class PersonalMetricsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController targetWeightController;

  const PersonalMetricsSection({
    super.key,
    required this.nameController,
    required this.weightController,
    required this.heightController,
    required this.targetWeightController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Metrics',
          style: AppTextStyles.font18SemiBoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ProfileTextField(
          label: 'Full Name',
          controller: nameController,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileTextField(
                label: 'Weight (kg)',
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileTextField(
                label: 'Height (cm)',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ProfileTextField(
          label: 'Target Weight (kg)',
          controller: targetWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}