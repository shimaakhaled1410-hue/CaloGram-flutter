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
    DateTime parsedDate;
    final loggedAtRaw = json['loggedAt'];

    if (loggedAtRaw is Timestamp) {
      parsedDate = loggedAtRaw.toDate();
    } else if (loggedAtRaw is String) {
      parsedDate = DateTime.tryParse(loggedAtRaw) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return MealModel(
      id: id.isNotEmpty ? id : (json['id'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      mealType: json['mealType'] as String? ?? 'snack',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fats: (json['fats'] as num?)?.toInt() ?? 0,
      loggedAt: parsedDate,
    );
  }

  /// للـ Firestore Remote
  Map<String, dynamic> toFirestoreJson() {
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

  /// للـ Local Cache
  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'title': title,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }
}
