class ScannedFoodEntity {
  final String foodName;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String confidenceScore;
  final List<String> detectedIngredients;

  const ScannedFoodEntity({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.confidenceScore,
    required this.detectedIngredients,
  });
}