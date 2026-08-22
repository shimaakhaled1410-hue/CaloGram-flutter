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
      foodName: json['foodName'] ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fats: (json['fats'] as num?)?.toInt() ?? 0,
      confidenceScore: json['confidenceScore']?.toString() ?? '0%',
      detectedIngredients: json['detectedIngredients'] != null
          ? List<String>.from(json['detectedIngredients'])
          : [],
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
