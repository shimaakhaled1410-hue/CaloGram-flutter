import 'package:calogram_flutter/features/data/models/app_notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationStorageService {
  NotificationStorageService._();
  static final NotificationStorageService instance =
      NotificationStorageService._();

  static const String boxName = 'notifications_box';

  Box<AppNotificationModel> get _box => Hive.box<AppNotificationModel>(boxName);

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(AppNotificationModelAdapter());
    }
    await Hive.openBox<AppNotificationModel>(boxName);

    await instance.cleanOldNotifications();
  }

  Future<void> cleanOldNotifications() async {
    final now = DateTime.now();
    final expiredKeys = _box.values
        .where((n) => now.difference(n.createdAt).inDays >= 7)
        .map((n) => n.key)
        .toList();

    if (expiredKeys.isNotEmpty) {
      await _box.deleteAll(expiredKeys);
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    await cleanOldNotifications();

    final notification = AppNotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _box.add(notification);

    if (_box.length > 30) {
      final keysToDelete = _box.keys.take(_box.length - 50).toList();
      await _box.deleteAll(keysToDelete);
    }
  }

  List<AppNotificationModel> getAllNotifications() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markAsRead(AppNotificationModel notification) async {
    notification.isRead = true;
    await notification.save();
  }

  Future<void> markAllAsRead() async {
    for (var notif in _box.values) {
      if (!notif.isRead) {
        notif.isRead = true;
        await notif.save();
      }
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  bool get hasUnreadNotifications =>
      _box.values.any((element) => !element.isRead);
}
