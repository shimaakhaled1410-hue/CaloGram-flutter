import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.title,
    required super.mealType,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.loggedAt,
  });

  factory MealModel.fromJson(Map<String, dynamic> json, String id) {
    return MealModel(
      id: id,
      title: json['title'] as String? ?? '',
      mealType: json['mealType'] as String? ?? 'snack',
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fats: json['fats'] as int? ?? 0,
      loggedAt: (json['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }
}