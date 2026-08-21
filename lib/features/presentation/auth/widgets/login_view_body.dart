import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:calogram_flutter/utils/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/cache_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/custom_gradient_button.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continueAsGuest() async {
    await CacheHelper.setData(key: AppConstants.isGuestUser, value: true);
    if (!mounted) return;
    context.go(AppRoutes.goalSetupScreen);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryLimeGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryNeonLime.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      size: 40,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome Back!',
                  style: AppTextStyles.font28BoldWhite,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track calories, scan meals & achieve your goals.',
                  style: AppTextStyles.font14RegularMuted,
                ),
                const SizedBox(height: 32),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textMutedDark,
                  ),
                  validator: (value) {
                    if (value == null || !AppRegex.isEmailValid(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isObscureText: _isPasswordObscure,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMutedDark,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMutedDark,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordObscure = !_isPasswordObscure);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.font14SemiBoldLime,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomGradientButton(
                  text: 'Log In',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.go(AppRoutes.goalSetupScreen);
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _continueAsGuest,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.inputBorderDark,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Continue as Guest',
                      style: AppTextStyles.font14MediumWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTextStyles.font14RegularMuted,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.registerScreen);
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.font14SemiBoldLime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}