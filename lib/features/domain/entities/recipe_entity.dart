class RecipeEntity {
  final String title;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int cookingTimeMinutes;
  final List<String> usedIngredients;
  final List<String> missingIngredients;
  final List<String> instructions;

  const RecipeEntity({
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.cookingTimeMinutes,
    required this.usedIngredients,
    required this.missingIngredients,
    required this.instructions,
  });
}
