import 'package:hive_flutter/hive_flutter.dart';

part 'app_notification_model.g.dart';

@HiveType(typeId: 6)
class AppNotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  bool isRead;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });
}
