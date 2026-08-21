import 'package:calogram_flutter/features/domain/usecases/dashboard/get_dashboard_data_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/meal_entity.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUsecase getDashboardDataUsecase;
  final LogMealUsecase logMealUsecase;

  DashboardCubit({
    required this.getDashboardDataUsecase,
    required this.logMealUsecase,
  }) : super(DashboardInitialState());

  Future<void> getDashboardData() async {
    emit(DashboardLoadingState());
    final result = await getDashboardDataUsecase();

    result.fold((failure) => emit(DashboardErrorState(failure.errMessage)), (
      data,
    ) {
      int totalCalories = 0;
      int totalProtein = 0;
      int totalCarbs = 0;
      int totalFats = 0;

      for (final meal in data.meals) {
        totalCalories += meal.calories;
        totalProtein += meal.protein;
        totalCarbs += meal.carbs;
        totalFats += meal.fats;
      }

      emit(
        DashboardLoadedState(
          user: data.user,
          meals: data.meals,
          consumedCalories: totalCalories,
          consumedProtein: totalProtein,
          consumedCarbs: totalCarbs,
          consumedFats: totalFats,
        ),
      );
    });
  }

  Future<void> logNewMeal(MealEntity meal) async {
    final result = await logMealUsecase(meal);
    result.fold(
      (failure) => emit(DashboardErrorState(failure.errMessage)),
      (_) => getDashboardData(),
    );
  }
}
