import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../manager/dashboard/dashboard_cubit.dart';
import '../../manager/dashboard/dashboard_state.dart';
import 'calorie_progress_card.dart';
import 'macro_nutrients_row.dart';

class TodayTabView extends StatelessWidget {
  const TodayTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoadingState || state is DashboardInitialState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryNeonLime),
          );
        }

        if (state is DashboardLoadedState) {
          final user = state.user;
          final targetCalories = user.targetCalories ?? 2000;
          final targetProtein = user.targetProtein ?? 150;
          final targetCarbs = user.targetCarbs ?? 220;
          final targetFats = user.targetFats ?? 55;

          return SafeArea(
            child: RefreshIndicator(
              color: AppColors.primaryNeonLime,
              backgroundColor: AppColors.cardDarkElevated,
              onRefresh: () =>
                  context.read<DashboardCubit>().getDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                              'Hello, ${user.name.isNotEmpty ? user.name : 'Champion'}!',
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
                    CalorieProgressCard(
                      consumedCalories: state.consumedCalories,
                      targetCalories: targetCalories,
                    ),
                    const SizedBox(height: 16),
                    MacroNutrientsRow(
                      consumedProtein: state.consumedProtein,
                      targetProtein: targetProtein,
                      consumedCarbs: state.consumedCarbs,
                      targetCarbs: targetCarbs,
                      consumedFats: state.consumedFats,
                      targetFats: targetFats,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "Today's Meals",
                      style: AppTextStyles.font16BoldDark.copyWith(
                        color: AppColors.textMainDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.meals.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.meals.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final meal = state.meals[index];
                          return _buildMealItem(
                            title: meal.title,
                            details: 'P: ${meal.protein}g • C: ${meal.carbs}g • F: ${meal.fats}g',
                            calories: '${meal.calories} kcal',
                            icon: Icons.restaurant_rounded,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<DashboardCubit>().getDashboardData(),
            child: const Text('Reload Dashboard'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorderDark, width: 1),
      ),
      child: Center(
        child: Text(
          'No meals logged yet today',
          style: AppTextStyles.font14RegularMuted,
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
        border: Border.all(color: AppColors.inputBorderDark, width: 1),
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
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(calories, style: AppTextStyles.font14SemiBoldLime),
        ],
      ),
    );
  }
}
