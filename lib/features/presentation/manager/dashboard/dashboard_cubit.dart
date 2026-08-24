import 'package:calogram_flutter/features/domain/entities/user_entity.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/delete_meal_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/get_dashboard_data_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/meal_entity.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUsecase getDashboardDataUsecase;
  final LogMealUsecase logMealUsecase;
  final DeleteMealUsecase deleteMealUsecase;

  DashboardCubit({
    required this.getDashboardDataUsecase,
    required this.logMealUsecase,
    required this.deleteMealUsecase,
  }) : super(DashboardInitialState());

  Future<void> getDashboardData() async {
    emit(DashboardLoadingState());
    final result = await getDashboardDataUsecase();

    result.fold((failure) => emit(DashboardErrorState(failure.errMessage)), (
      data,
    ) {
      _emitLoaded(data.user, data.meals);
    });
  }

  void _emitLoaded(UserEntity user, List<MealEntity> meals) {
    int totalCalories = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFats = 0;

    for (final meal in meals) {
      totalCalories += meal.calories;
      totalProtein += meal.protein;
      totalCarbs += meal.carbs;
      totalFats += meal.fats;
    }

    emit(
      DashboardLoadedState(
        user: user,
        meals: meals,
        consumedCalories: totalCalories,
        consumedProtein: totalProtein,
        consumedCarbs: totalCarbs,
        consumedFats: totalFats,
      ),
    );
  }

  Future<void> logNewMeal(MealEntity meal) async {
    final result = await logMealUsecase(meal);
    result.fold(
      (failure) => emit(DashboardErrorState(failure.errMessage)),
      (_) => getDashboardData(),
    );
  }

  Future<void> deleteMeal(String mealId) async {
    if (state is DashboardLoadedState) {
      final currentState = state as DashboardLoadedState;
      final updatedMeals = currentState.meals
          .where((m) => m.id != mealId)
          .toList();

      _emitLoaded(currentState.user, updatedMeals);

      final result = await deleteMealUsecase(mealId);
      result.fold((failure) {
        emit(DashboardErrorState(failure.errMessage));
        getDashboardData();
      }, (_) {});
    }
  }
}
