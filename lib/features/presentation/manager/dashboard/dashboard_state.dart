import '../../../domain/entities/meal_entity.dart';
import '../../../domain/entities/user_entity.dart';

abstract class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final UserEntity user;
  final List<MealEntity> meals;
  final int consumedCalories;
  final int consumedProtein;
  final int consumedCarbs;
  final int consumedFats;

  DashboardLoadedState({
    required this.user,
    required this.meals,
    required this.consumedCalories,
    required this.consumedProtein,
    required this.consumedCarbs,
    required this.consumedFats,
  });
}

class DashboardErrorState extends DashboardState {
  final String errMessage;
  DashboardErrorState(this.errMessage);
}