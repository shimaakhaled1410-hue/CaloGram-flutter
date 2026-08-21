import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:calogram_flutter/utils/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_gradient_button.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _nameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textMutedDark,
            ),
            validator: (value) {
              if (value == null || value.trim().length < 3) {
                return 'Please enter a valid name (min 3 characters)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
            hintText: 'Password (min 8 chars & 1 number)',
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
              if (value == null || !AppRegex.isPasswordValid(value)) {
                return 'Password must have at least 8 chars, letters and digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          CustomGradientButton(
            text: 'Create Account',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                GoRouter.of(context).pushReplacement(AppRoutes.dashboardScreen);
              }
            },
          ),
        ],
      ),
    );
  }
}
