import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final double currentWeight; // kg
  final double height; // cm
  final double targetWeight; // kg
  final int targetCalories;
  final int targetProtein; // grams
  final int targetCarbs; // grams
  final int targetFats; // grams

  const UserProfile({
    required this.name,
    required this.currentWeight,
    required this.height,
    required this.targetWeight,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
  });

  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final val = bmi;
    if (val < 18.5) return 'Underweight';
    if (val < 25.0) return 'Normal weight';
    if (val < 30.0) return 'Overweight';
    return 'Obese';
  }

  UserProfile copyWith({
    String? name,
    double? currentWeight,
    double? height,
    double? targetWeight,
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFats,
  }) {
    return UserProfile(
      name: name ?? this.name,
      currentWeight: currentWeight ?? this.currentWeight,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
    );
  }

  @override
  List<Object?> get props => [
    name,
    currentWeight,
    height,
    targetWeight,
    targetCalories,
    targetProtein,
    targetCarbs,
    targetFats,
  ];
}
