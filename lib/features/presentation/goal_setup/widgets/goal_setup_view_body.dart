import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_gradient_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'selectable_card.dart';

class GoalSetupViewBody extends StatefulWidget {
  const GoalSetupViewBody({super.key});

  @override
  State<GoalSetupViewBody> createState() => _GoalSetupViewBodyState();
}

class _GoalSetupViewBodyState extends State<GoalSetupViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedGoal = 'lose_weight';
  String _activityLevel = 'moderate';

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateAndSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final int age = int.parse(_ageController.text.trim());
    final double height = double.parse(_heightController.text.trim());
    final double weight = double.parse(_weightController.text.trim());

    double bmr;
    if (_selectedGender == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double multiplier = 1.2;
    if (_activityLevel == 'moderate') multiplier = 1.55;
    if (_activityLevel == 'very_active') multiplier = 1.725;

    final double tdee = bmr * multiplier;

    int targetCalories;
    if (_selectedGoal == 'lose_weight') {
      targetCalories = (tdee - 400).round();
    } else if (_selectedGoal == 'gain_muscle') {
      targetCalories = (tdee + 350).round();
    } else {
      targetCalories = tdee.round();
    }

    final int targetProtein = ((targetCalories * 0.30) / 4).round();
    final int targetCarbs = ((targetCalories * 0.45) / 4).round();
    final int targetFats = ((targetCalories * 0.25) / 9).round();

    context.read<AuthCubit>().updateProfileMetrics(
          gender: _selectedGender,
          age: age,
          height: height,
          weight: weight,
          goal: _selectedGoal,
          activityLevel: _activityLevel,
          targetCalories: targetCalories,
          targetProtein: targetProtein,
          targetCarbs: targetCarbs,
          targetFats: targetFats,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UpdateMetricsSuccessState) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Plan customized successfully!',
          );
          context.go(AppRoutes.dashboardScreen);
        } else if (state is UpdateMetricsErrorState) {
          context.go(AppRoutes.dashboardScreen);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is UpdateMetricsLoadingState;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalize Your Plan 🎯',
                    style: AppTextStyles.font24BoldWhite,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'AI uses these metrics to accurately calculate your daily macros & targets.',
                    style: AppTextStyles.font14RegularMuted,
                  ),
                  const SizedBox(height: 24),
                  Text('Gender', style: AppTextStyles.font14MediumWhite),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableCard(
                          title: 'Male',
                          icon: Icons.male_rounded,
                          isSelected: _selectedGender == 'male',
                          onTap: () => setState(() => _selectedGender = 'male'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SelectableCard(
                          title: 'Female',
                          icon: Icons.female_rounded,
                          isSelected: _selectedGender == 'female',
                          onTap: () => setState(() => _selectedGender = 'female'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _ageController,
                          hintText: 'Age (yrs)',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _heightController,
                          hintText: 'Height (cm)',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _weightController,
                          hintText: 'Weight (kg)',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              (value == null || value.isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Primary Goal', style: AppTextStyles.font14MediumWhite),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Lose Weight',
                    subtitle: 'Burn fat and stay lean with a calorie deficit',
                    icon: Icons.trending_down_rounded,
                    isSelected: _selectedGoal == 'lose_weight',
                    onTap: () => setState(() => _selectedGoal = 'lose_weight'),
                  ),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Maintain Weight',
                    subtitle: 'Keep current weight while improving energy & health',
                    icon: Icons.horizontal_rule_rounded,
                    isSelected: _selectedGoal == 'maintain',
                    onTap: () => setState(() => _selectedGoal = 'maintain'),
                  ),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Gain Muscle',
                    subtitle: 'Build muscle mass with calculated calorie surplus',
                    icon: Icons.fitness_center_rounded,
                    isSelected: _selectedGoal == 'gain_muscle',
                    onTap: () => setState(() => _selectedGoal = 'gain_muscle'),
                  ),
                  const SizedBox(height: 24),
                  Text('Activity Level', style: AppTextStyles.font14MediumWhite),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Sedentary',
                    subtitle: 'Little to no exercise (desk job)',
                    icon: Icons.chair_rounded,
                    isSelected: _activityLevel == 'sedentary',
                    onTap: () => setState(() => _activityLevel = 'sedentary'),
                  ),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Moderate Activity',
                    subtitle: 'Exercise 3-5 times a week',
                    icon: Icons.directions_run_rounded,
                    isSelected: _activityLevel == 'moderate',
                    onTap: () => setState(() => _activityLevel = 'moderate'),
                  ),
                  const SizedBox(height: 10),
                  SelectableCard(
                    title: 'Very Active',
                    subtitle: 'Intense daily workouts or physical job',
                    icon: Icons.bolt_rounded,
                    isSelected: _activityLevel == 'very_active',
                    onTap: () => setState(() => _activityLevel = 'very_active'),
                  ),
                  const SizedBox(height: 32),
                  CustomGradientButton(
                    text: isLoading ? 'Calculating Plan...' : 'Calculate My Plan & Continue',
                    onPressed: isLoading ? () {} : _calculateAndSubmit,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}