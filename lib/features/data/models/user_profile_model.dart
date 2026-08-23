import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.currentWeight,
    required super.height,
    required super.targetWeight,
    required super.targetCalories,
    required super.targetProtein,
    required super.targetCarbs,
    required super.targetFats,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String? ?? 'User',
      currentWeight: (json['currentWeight'] as num?)?.toDouble() ?? 70.0,
      height: (json['height'] as num?)?.toDouble() ?? 175.0,
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 68.0,
      targetCalories: (json['targetCalories'] as num?)?.toInt() ?? 2000,
      targetProtein: (json['targetProtein'] as num?)?.toInt() ?? 140,
      targetCarbs: (json['targetCarbs'] as num?)?.toInt() ?? 200,
      targetFats: (json['targetFats'] as num?)?.toInt() ?? 65,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentWeight': currentWeight,
      'height': height,
      'targetWeight': targetWeight,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      name: entity.name,
      currentWeight: entity.currentWeight,
      height: entity.height,
      targetWeight: entity.targetWeight,
      targetCalories: entity.targetCalories,
      targetProtein: entity.targetProtein,
      targetCarbs: entity.targetCarbs,
      targetFats: entity.targetFats,
    );
  }

  factory UserProfileModel.defaultProfile() {
    return const UserProfileModel(
      name: 'User',
      currentWeight: 75.0,
      height: 175.0,
      targetWeight: 70.0,
      targetCalories: 2200,
      targetProtein: 150,
      targetCarbs: 220,
      targetFats: 65,
    );
  }
}
