class UserEntity {
  final String uId;
  final String email;
  final String name;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final String? goal;
  final String? activityLevel;
  final int? targetCalories;
  final int? targetProtein;
  final int? targetCarbs;
  final int? targetFats;

  const UserEntity({
    required this.uId,
    required this.email,
    required this.name,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.goal,
    this.activityLevel,
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFats,
  });

  UserEntity copyWith({
    String? uId,
    String? email,
    String? name,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? goal,
    String? activityLevel,
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFats,
  }) {
    return UserEntity(
      uId: uId ?? this.uId,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
    );
  }
}