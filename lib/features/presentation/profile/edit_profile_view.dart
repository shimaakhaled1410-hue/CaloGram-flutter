import 'package:calogram_flutter/features/domain/entities/user_profile.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import 'widgets/macro_targets_section.dart';
import 'widgets/personal_metrics_section.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const EditProfileContent(),
    );
  }
}

class EditProfileContent extends StatefulWidget {
  const EditProfileContent({super.key});

  @override
  State<EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _targetWeightController = TextEditingController();
    _caloriesController = TextEditingController();
    _proteinController = TextEditingController();
    _carbsController = TextEditingController();
    _fatsController = TextEditingController();
  }

  void _populateControllers(UserProfile profile) {
    _nameController.text = profile.name;
    _weightController.text = profile.currentWeight.toStringAsFixed(1);
    _heightController.text = profile.height.toStringAsFixed(0);
    _targetWeightController.text = profile.targetWeight.toStringAsFixed(1);
    _caloriesController.text = profile.targetCalories.toString();
    _proteinController.text = profile.targetProtein.toString();
    _carbsController.text = profile.targetCarbs.toString();
    _fatsController.text = profile.targetFats.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdatedSuccess) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Profile targets updated successfully!',
          );
          context.pop();
        } else if (state is ProfileLoaded && !_isInitialized) {
          _populateControllers(state.profile);
          _isInitialized = true;
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileUpdating;

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Edit Goals & Metrics',
              style: AppTextStyles.font20BoldWhite,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PersonalMetricsSection(
                    nameController: _nameController,
                    weightController: _weightController,
                    heightController: _heightController,
                    targetWeightController: _targetWeightController,
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryNeonLime),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 46),
                    ),
                    onPressed: _autoCalculateNutrition,
                    icon: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryNeonLime,
                      size: 18,
                    ),
                    label: Text(
                      'Auto-Calculate Targets with AI',
                      style: AppTextStyles.font14SemiBoldLime,
                    ),
                  ),
                  const SizedBox(height: 24),
                  MacroTargetsSection(
                    caloriesController: _caloriesController,
                    proteinController: _proteinController,
                    carbsController: _carbsController,
                    fatsController: _fatsController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNeonLime,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : _saveProfile,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text('Save Changes', style: AppTextStyles.font16BoldDark),
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = UserProfile(
        name: _nameController.text.trim(),
        currentWeight: double.tryParse(_weightController.text) ?? 70.0,
        height: double.tryParse(_heightController.text) ?? 175.0,
        targetWeight: double.tryParse(_targetWeightController.text) ?? 68.0,
        targetCalories: int.tryParse(_caloriesController.text) ?? 2000,
        targetProtein: int.tryParse(_proteinController.text) ?? 140,
        targetCarbs: int.tryParse(_carbsController.text) ?? 200,
        targetFats: int.tryParse(_fatsController.text) ?? 65,
      );
      context.read<ProfileCubit>().updateProfile(updated);
    }
  }

  void _autoCalculateNutrition() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);
    final double? targetWeight = double.tryParse(_targetWeightController.text);

    if (weight == null || height == null) {
      CustomSnackBar.showError(
        context,
        message: 'Please enter valid weight and height first',
      );
      return;
    }

    final double bmr = (10 * weight) + (6.25 * height) - (5 * 25) + 5;
    double tdee = bmr * 1.375; // Moderate active

    if (targetWeight != null) {
      if (targetWeight < weight) {
        tdee -= 400;
      } else if (targetWeight > weight) {
        tdee += 300;
      }
    }

    final int calculatedCalories = tdee.round();

    final int protein = ((calculatedCalories * 0.30) / 4).round();
    final int carbs = ((calculatedCalories * 0.45) / 4).round();
    final int fats = ((calculatedCalories * 0.25) / 9).round();

    setState(() {
      _caloriesController.text = calculatedCalories.toString();
      _proteinController.text = protein.toString();
      _carbsController.text = carbs.toString();
      _fatsController.text = fats.toString();
    });
  }
}
