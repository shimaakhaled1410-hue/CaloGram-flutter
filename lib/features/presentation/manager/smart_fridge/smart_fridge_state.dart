import '../../../domain/entities/recipe_entity.dart';

abstract class SmartFridgeState {}

class SmartFridgeInitial extends SmartFridgeState {
  final List<String> ingredients;
  SmartFridgeInitial({this.ingredients = const []});
}

class SmartFridgeLoading extends SmartFridgeState {}

class SmartFridgeSuccess extends SmartFridgeState {
  final List<RecipeEntity> recipes;
  final List<String> currentIngredients;
  SmartFridgeSuccess({required this.recipes, required this.currentIngredients});
}

class SmartFridgeLoggingMeal extends SmartFridgeState {}

class SmartFridgeMealLoggedSuccess extends SmartFridgeState {
  final String mealTitle;
  SmartFridgeMealLoggedSuccess(this.mealTitle);
}

class SmartFridgeError extends SmartFridgeState {
  final String errMessage;
  SmartFridgeError(this.errMessage);
}