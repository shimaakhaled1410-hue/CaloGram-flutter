class MealEntity {
  final String id;
  final String title;
  final String mealType;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final DateTime loggedAt;

  const MealEntity({
    required this.id,
    required this.title,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.loggedAt,
  });
}