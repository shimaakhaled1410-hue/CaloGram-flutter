import '../../domain/entities/scanned_food_entity.dart';

class ScannedFoodModel extends ScannedFoodEntity {
  const ScannedFoodModel({
    required super.foodName,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.confidenceScore,
    required super.detectedIngredients,
  });

  factory ScannedFoodModel.fromJson(Map<String, dynamic> json) {
    return ScannedFoodModel(
      foodName: json['foodName'] as String? ?? 'Custom Meal',
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fats: json['fats'] as int? ?? 0,
      confidenceScore: json['confidenceScore'] as String? ?? '95%',
      detectedIngredients:
          (json['detectedIngredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'confidenceScore': confidenceScore,
      'detectedIngredients': detectedIngredients,
    };
  }
}
