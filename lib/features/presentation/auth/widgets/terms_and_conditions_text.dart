import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.font14RegularMuted.copyWith(
          fontSize: 12,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        children: [
          const TextSpan(text: 'By signing up, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: AppTextStyles.font14SemiBoldLime.copyWith(
              fontSize: 12,
              color: isDark
                  ? AppColors.primaryNeonLime
                  : AppColors.primaryLimeDark,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTextStyles.font14SemiBoldLime.copyWith(
              fontSize: 12,
              color: isDark
                  ? AppColors.primaryNeonLime
                  : AppColors.primaryLimeDark,
            ),
          ),
        ],
      ),
    );
  }
}
