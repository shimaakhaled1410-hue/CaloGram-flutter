import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'register_form.dart';
import 'terms_and_conditions_text.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account 🚀',
                style: AppTextStyles.font28BoldWhite,
              ),
              const SizedBox(height: 8),
              Text(
                'Start your smart AI nutrition journey today.',
                style: AppTextStyles.font14RegularMuted,
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
                    style: AppTextStyles.font14RegularMuted,
                  ),
                  GestureDetector(
                    onTap: () => GoRouter.of(context).pop(),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.font14SemiBoldLime,
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