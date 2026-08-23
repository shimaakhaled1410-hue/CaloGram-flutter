import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/fridge/generate_recipes_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../../domain/entities/recipe_entity.dart';
import 'smart_fridge_state.dart';

class SmartFridgeCubit extends Cubit<SmartFridgeState> {
  final GenerateRecipesUseCase generateRecipesUseCase;
  final LogMealUsecase logMealUsecase;

  final List<String> _ingredients = [];
  List<RecipeEntity> _lastGeneratedRecipes = [];

  SmartFridgeCubit({
    required this.generateRecipesUseCase,
    required this.logMealUsecase,
  }) : super(SmartFridgeInitial());

  List<String> get currentIngredients => List.unmodifiable(_ingredients);

  void addIngredient(String ingredient) {
    final clean = ingredient.trim();
    if (_ingredients.length >= 10) {
      emit(SmartFridgeError('Maximum 10 ingredients allowed per search.'));
      return;
    }
    if (clean.isNotEmpty && !_ingredients.contains(clean)) {
      _ingredients.add(clean);
      _emitAppropriateState();
    }
  }

  void removeIngredient(String ingredient) {
    _ingredients.remove(ingredient);
    _emitAppropriateState();
  }

  void clearAll() {
    _ingredients.clear();
    _lastGeneratedRecipes.clear();
    emit(SmartFridgeInitial());
  }

  void _emitAppropriateState() {
    if (_lastGeneratedRecipes.isNotEmpty) {
      emit(
        SmartFridgeSuccess(
          recipes: _lastGeneratedRecipes,
          currentIngredients: List.from(_ingredients),
        ),
      );
    } else {
      emit(SmartFridgeInitial(ingredients: List.from(_ingredients)));
    }
  }

  Future<void> generateRecipes() async {
    if (_ingredients.isEmpty) {
      emit(SmartFridgeError('Please add at least one ingredient first.'));
      return;
    }

    emit(SmartFridgeLoading());
    final result = await generateRecipesUseCase(_ingredients);

    result.fold((failure) => emit(SmartFridgeError(failure.errMessage)), (
      recipes,
    ) {
      _lastGeneratedRecipes = recipes;
      emit(
        SmartFridgeSuccess(
          recipes: recipes,
          currentIngredients: List.from(_ingredients),
        ),
      );
    });
  }

  Future<void> logRecipeMeal(RecipeEntity recipe) async {
    emit(SmartFridgeLoggingMeal());

    final meal = MealEntity(
      id: '',
      title: recipe.title,
      mealType: 'dinner',
      calories: recipe.calories,
      protein: recipe.protein,
      carbs: recipe.carbs,
      fats: recipe.fats,
      loggedAt: DateTime.now(),
    );

    final result = await logMealUsecase(meal);

    result.fold((failure) => emit(SmartFridgeError(failure.errMessage)), (_) {
      emit(SmartFridgeMealLoggedSuccess(recipe.title));
      _emitAppropriateState();
    });
  }
}
