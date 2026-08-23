import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/cache_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../utils/app_regex.dart';
import '../../../../core/widgets/custom_gradient_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

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
    await CacheHelper.setBool(key: AppConstants.isGuestUser, value: true);
    if (!mounted) return;
    context.go(AppRoutes.goalSetupScreen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Logged in successfully!',
          );
          context.go(AppRoutes.dashboardScreen);
        } else if (state is LoginErrorState) {
          CustomSnackBar.showError(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is LoginLoadingState;

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
                              color: AppColors.primaryNeonLime.withValues(
                                alpha: 0.3,
                              ),
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
                      style: AppTextStyles.font28BoldWhite.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track calories, scan meals & achieve your goals.',
                      style: AppTextStyles.font14RegularMuted.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
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
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        onPressed: () {
                          setState(
                            () => _isPasswordObscure = !_isPasswordObscure,
                          );
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
                          style: AppTextStyles.font14SemiBoldLime.copyWith(
                            color: isDark
                                ? AppColors.primaryNeonLime
                                : AppColors.primaryLimeDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomGradientButton(
                      text: isLoading ? 'Logging In...' : 'Log In',
                      onPressed: isLoading
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: isLoading ? null : _continueAsGuest,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? AppColors.inputBorderDark
                                : AppColors.inputBorderLight,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Continue as Guest',
                          style: AppTextStyles.font14MediumWhite.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: AppTextStyles.font14RegularMuted.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.registerScreen);
                          },
                          child: Text(
                            'Sign Up',
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
          ),
        );
      },
    );
  }
}
