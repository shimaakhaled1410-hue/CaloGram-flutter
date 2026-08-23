import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ProfileSummaryCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileSummaryCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.inputBorderDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: 'Weight',
            value: '${profile.currentWeight.toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight_outlined,
          ),
          _buildDivider(),
          _buildStatItem(
            label: 'BMI',
            value: profile.bmi.toStringAsFixed(1),
            icon: Icons.speed_rounded,
          ),
          _buildDivider(),
          _buildStatItem(
            label: 'Target',
            value: '${profile.targetCalories} kcal',
            icon: Icons.local_fire_department_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryNeonLime, size: 24),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.font14SemiBoldWhite),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.font12MediumMuted),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 38,
      width: 1,
      color: AppColors.inputBorderDark,
    );
  }
}