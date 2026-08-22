import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class FoodScannerView extends StatelessWidget {
  const FoodScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FoodScannerCubit>(),
      child: const _FoodScannerContent(),
    );
  }
}

class _FoodScannerContent extends StatelessWidget {
  const _FoodScannerContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('AI Food Scanner 📸', style: AppTextStyles.font20BoldWhite),
        centerTitle: true,
      ),
      body: BlocConsumer<FoodScannerCubit, FoodScannerState>(
        listener: (context, state) {
          if (state is FoodScannerSavedSuccessState) {
            CustomSnackBar.showSuccess(
              context,
              message: 'Meal logged successfully!',
            );
          } else if (state is FoodScannerErrorState) {
            CustomSnackBar.showError(context, message: state.errMessage);
          }
        },
        builder: (context, state) {
          if (state is FoodScannerLoadingState ||
              state is FoodScannerSavingState) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryNeonLime),
                  SizedBox(height: 16),
                  Text(
                    'Analyzing meal nutrition with AI...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          if (state is FoodScannerSuccessState) {
            final food = state.food;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder<List<int>>(
                      future: state.image.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data as dynamic,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }
                        return Container(
                          height: 220,
                          color: AppColors.cardDark,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryNeonLime,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(food.foodName, style: AppTextStyles.font24BoldWhite),
                  const SizedBox(height: 6),
                  Text(
                    'AI Confidence: ${food.confidenceScore}',
                    style: AppTextStyles.font14SemiBoldLime,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.inputBorderDark),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricCol('Calories', '${food.calories} kcal'),
                        _metricCol('Protein', '${food.protein}g'),
                        _metricCol('Carbs', '${food.carbs}g'),
                        _metricCol('Fats', '${food.fats}g'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNeonLime,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      context.read<FoodScannerCubit>().saveScannedMeal(
                        title: food.foodName,
                        calories: food.calories,
                        protein: food.protein,
                        carbs: food.carbs,
                        fats: food.fats,
                        mealType: 'lunch',
                      );
                    },
                    child: const Text(
                      'Confirm & Log Meal',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                  color: AppColors.primaryNeonLime,
                ),
                const SizedBox(height: 16),
                Text(
                  'Snap a photo of your meal',
                  style: AppTextStyles.font18SemiBoldWhite,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardDarkElevated,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => context
                          .read<FoodScannerCubit>()
                          .pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_rounded),
                      label: const Text('Camera'),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardDarkElevated,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => context
                          .read<FoodScannerCubit>()
                          .pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _metricCol(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.font12MediumMuted),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.font14SemiBoldWhite),
      ],
    );
  }
}
