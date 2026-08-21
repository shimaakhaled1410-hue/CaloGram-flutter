import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/custom_gradient_button.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
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

  @override
  Widget build(BuildContext context) {
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
                text: 'Calculate My Plan & Continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.go(AppRoutes.dashboardScreen);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
