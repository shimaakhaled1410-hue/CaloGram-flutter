import 'package:calogram_flutter/core/widgets/custom_confirm_dialog.dart';
import 'package:calogram_flutter/features/presentation/dashboard/widgets/today_empty_state.dart';
import 'package:calogram_flutter/features/presentation/dashboard/widgets/today_header_section.dart';
import 'package:calogram_flutter/features/presentation/dashboard/widgets/today_meal_item.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoadingState || state is DashboardInitialState) {
          return Center(child: CircularProgressIndicator(color: primaryAccent));
        }

        if (state is DashboardLoadedState) {
          final user = state.user;
          final targetCalories = user.targetCalories ?? 2000;
          final targetProtein = user.targetProtein ?? 150;
          final targetCarbs = user.targetCarbs ?? 220;
          final targetFats = user.targetFats ?? 55;

          return SafeArea(
            child: RefreshIndicator(
              color: primaryAccent,
              backgroundColor: isDark
                  ? AppColors.cardDarkElevated
                  : AppColors.cardLightElevated,
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
                    TodayHeaderSection(userName: user.name),
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.meals.isEmpty)
                      const TodayEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.meals.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final meal = state.meals[index];
                          final mealKey = meal.id.isNotEmpty
                              ? meal.id
                              : '$index-${meal.title}';

                          return Dismissible(
                            key: ValueKey(mealKey),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await CustomConfirmDialog.show(
                                context,
                                title: 'Delete Meal',
                                content:
                                    'Are you sure you want to remove "${meal.title}" from today\'s log?',
                                confirmText: 'Delete',
                                confirmButtonColor: const Color(0xFFEF4444),
                                onConfirm: () {},
                              );
                            },
                            onDismissed: (direction) {
                              context.read<DashboardCubit>().deleteMeal(
                                meal.id,
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: TodayMealItem(
                              title: meal.title,
                              details:
                                  'P: ${meal.protein}g • C: ${meal.carbs}g • F: ${meal.fats}g',
                              calories: '${meal.calories} kcal',
                              icon: Icons.restaurant_rounded,
                            ),
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
}
