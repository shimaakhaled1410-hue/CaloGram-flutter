import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_logo.dart';
import 'register_form.dart';
import 'terms_and_conditions_text.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: AppLogo(size: 70, showGlow: true)),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Create Account',
                  style: AppTextStyles.font28BoldWhite.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Start your smart AI nutrition journey today.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const RegisterForm(),
              const SizedBox(height: 20),
              const TermsAndConditionsText(),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.font14RegularMuted.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => GoRouter.of(context).pop(),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.font14SemiBoldLime.copyWith(
                        color: isDark
                            ? AppColors.primaryNeonLime
                            : AppColors.primaryLimeDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
