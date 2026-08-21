import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uId,
    required super.email,
    required super.name,
    super.gender,
    super.age,
    super.height,
    super.weight,
    super.goal,
    super.activityLevel,
    super.targetCalories,
    super.targetProtein,
    super.targetCarbs,
    super.targetFats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      goal: json['goal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      targetCalories: json['targetCalories'] as int?,
      targetProtein: json['targetProtein'] as int?,
      targetCarbs: json['targetCarbs'] as int?,
      targetFats: json['targetFats'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (goal != null) 'goal': goal,
      if (activityLevel != null) 'activityLevel': activityLevel,
      if (targetCalories != null) 'targetCalories': targetCalories,
      if (targetProtein != null) 'targetProtein': targetProtein,
      if (targetCarbs != null) 'targetCarbs': targetCarbs,
      if (targetFats != null) 'targetFats': targetFats,
    };
  }
}
