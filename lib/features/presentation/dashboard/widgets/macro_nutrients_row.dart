import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class MacroNutrientsRow extends StatelessWidget {
  const MacroNutrientsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMacroCard(
          label: 'Protein',
          current: '65g',
          target: '140g',
          color: Colors.blueAccent,
        ),
        const SizedBox(width: 10),
        _buildMacroCard(
          label: 'Carbs',
          current: '110g',
          target: '200g',
          color: Colors.orangeAccent,
        ),
        const SizedBox(width: 10),
        _buildMacroCard(
          label: 'Fats',
          current: '32g',
          target: '65g',
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildMacroCard({
    required String label,
    required String current,
    required String target,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.inputBorderDark,
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
                  style: AppTextStyles.font14RegularMuted.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(current, style: AppTextStyles.font14MediumWhite),
            const SizedBox(height: 2),
            Text(
              'of $target',
              style: AppTextStyles.font14RegularMuted.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}