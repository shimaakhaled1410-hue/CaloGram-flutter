import 'package:calogram_flutter/core/widgets/custom_gradient_button.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class FoodScannerResultView extends StatelessWidget {
  final ScannedFoodEntity food;
  final XFile image;

  const FoodScannerResultView({
    super.key,
    required this.food,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent =
        isDark ? AppColors.primaryNeonLime : AppColors.primaryLimeDark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FutureBuilder<List<int>>(
              future: image.readAsBytes(),
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
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(color: primaryAccent),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            food.foodName,
            style: AppTextStyles.font24BoldWhite.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'AI Confidence: ${food.confidenceScore}',
            style: AppTextStyles.font14SemiBoldLime.copyWith(
              color: primaryAccent,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? AppColors.inputBorderDark
                    : AppColors.inputBorderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricCol(context, 'Calories', '${food.calories} kcal'),
                _metricCol(context, 'Protein', '${food.protein}g'),
                _metricCol(context, 'Carbs', '${food.carbs}g'),
                _metricCol(context, 'Fats', '${food.fats}g'),
              ],
            ),
          ),
          const SizedBox(height: 24),
         CustomGradientButton(
  text: 'Confirm & Log Meal',
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
),
       
        ],
      ),
    );
  }

  Widget _metricCol(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.font12MediumMuted.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.font14SemiBoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}