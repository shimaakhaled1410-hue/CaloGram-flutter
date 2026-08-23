import '../../domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  const RecipeModel({
    required super.title,
    required super.description,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.cookingTimeMinutes,
    required super.usedIngredients,
    required super.missingIngredients,
    required super.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      title: json['title']?.toString() ?? 'Healthy Recipe',
      description: json['description']?.toString() ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fats: (json['fats'] as num?)?.toInt() ?? 0,
      cookingTimeMinutes: (json['cookingTimeMinutes'] as num?)?.toInt() ?? 15,
      usedIngredients:
          (json['usedIngredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      missingIngredients:
          (json['missingIngredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
