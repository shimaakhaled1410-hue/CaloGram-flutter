import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ProfileSummaryCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileSummaryCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? AppColors.inputBorderDark
              : AppColors.inputBorderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context: context,
            label: 'Weight',
            value: '${profile.currentWeight.toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight_outlined,
            accentColor: primaryAccent,
          ),
          _buildDivider(isDark),
          _buildStatItem(
            context: context,
            label: 'BMI',
            value: profile.bmi.toStringAsFixed(1),
            icon: Icons.speed_rounded,
            accentColor: primaryAccent,
          ),
          _buildDivider(isDark),
          _buildStatItem(
            context: context,
            label: 'Target',
            value: '${profile.targetCalories} kcal',
            icon: Icons.local_fire_department_outlined,
            accentColor: primaryAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Icon(icon, color: accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.font14SemiBoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.font12MediumMuted.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 38,
      width: 1,
      color: isDark ? AppColors.inputBorderDark : AppColors.inputBorderLight,
    );
  }
}
