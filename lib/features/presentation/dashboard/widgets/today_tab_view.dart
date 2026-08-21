import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'calorie_progress_card.dart';
import 'macro_nutrients_row.dart';

class TodayTabView extends StatelessWidget {
  const TodayTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Champion!',
                      style: AppTextStyles.font24BoldWhite,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track every bite and reach your target.',
                      style: AppTextStyles.font14RegularMuted,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.cardDarkElevated,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textMainDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const CalorieProgressCard(
              consumedCalories: 1250,
              targetCalories: 2200,
            ),
            const SizedBox(height: 16),
            const MacroNutrientsRow(),
            const SizedBox(height: 28),
            Text(
              "Today's Meals",
              style: AppTextStyles.font16BoldDark.copyWith(
                color: AppColors.textMainDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildMealItem(
              title: 'Breakfast',
              details: 'Oats, Banana & Whey Protein',
              calories: '450 kcal',
              icon: Icons.breakfast_dining_rounded,
            ),
            const SizedBox(height: 10),
            _buildMealItem(
              title: 'Lunch',
              details: 'Grilled Chicken & Brown Rice',
              calories: '620 kcal',
              icon: Icons.lunch_dining_rounded,
            ),
            const SizedBox(height: 10),
            _buildMealItem(
              title: 'Snack',
              details: 'Greek Yogurt & Almonds',
              calories: '180 kcal',
              icon: Icons.coffee_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem({
    required String title,
    required String details,
    required String calories,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBorderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardDarkElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryNeonLime, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.font14MediumWhite),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: AppTextStyles.font14RegularMuted.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: AppTextStyles.font14SemiBoldLime,
          ),
        ],
      ),
    );
  }
}