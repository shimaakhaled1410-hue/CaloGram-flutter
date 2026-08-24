import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_gradient_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../utils/app_regex.dart';
import '../../manager/auth/auth_cubit.dart';
import '../../manager/auth/auth_state.dart';

class LinkAccountDialog extends StatefulWidget {
  const LinkAccountDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const LinkAccountDialog(),
      ),
    );
  }

  @override
  State<LinkAccountDialog> createState() => _LinkAccountDialogState();
}

class _LinkAccountDialogState extends State<LinkAccountDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LinkAccountSuccessState) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is LinkAccountLoadingState;

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDark
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorderLight,
              width: 1,
            ),
          ),
          title: Text(
            'Create Permanent Account',
            style: AppTextStyles.font18SemiBoldWhite.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Link your guest progress to a permanent account so you never lose your logged meals.',
                    style: AppTextStyles.font14RegularMuted.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (val) =>
                        val == null || !AppRegex.isEmailValid(val)
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isObscureText: _isPasswordObscure,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordObscure = !_isPasswordObscure,
                      ),
                    ),
                    validator: (val) => val == null || val.length < 6
                        ? 'Password must be 6+ chars'
                        : null,
                  ),
                  if (state is RegisterErrorState) ...[
                    const SizedBox(height: 10),
                    Text(
                      state.errMessage,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: isLoading ? 'Creating Account...' : 'Create Account',
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().linkAccount(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : () => context.pop(),
                      child: Text(
                        'Stay as Guest',
                        style: AppTextStyles.font14RegularMuted.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
