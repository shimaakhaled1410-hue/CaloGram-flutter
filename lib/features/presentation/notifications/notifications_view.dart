import 'package:calogram_flutter/features/data/models/app_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/notification_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () async {
              await NotificationStorageService.instance.markAllAsRead();
            },
          ),
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () async {
              await NotificationStorageService.instance.clearAll();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AppNotificationModel>(
          NotificationStorageService.boxName,
        ).listenable(),
        builder: (context, Box<AppNotificationModel> box, _) {
          final notifications = NotificationStorageService.instance
              .getAllNotifications();

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: AppTextStyles.font16BoldDark.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You\'re all caught up with your daily logs!',
                    style: AppTextStyles.font12MediumMuted,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _NotificationCard(notification: notif, isDark: isDark);
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotificationModel notification;
  final bool isDark;

  const _NotificationCard({required this.notification, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final iconData = _getIcon(notification.type);
    final color = _getColor(notification.type, isDark);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        NotificationStorageService.instance.markAsRead(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? (notification.isRead
                    ? AppColors.cardDark
                    : AppColors.cardDarkElevated)
              : (notification.isRead
                    ? AppColors.cardLight
                    : AppColors.cardLightElevated),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : color.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.font14SemiBoldWhite.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(notification.createdAt),
                        style: AppTextStyles.font12MediumMuted.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyles.font12MediumMuted.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'meal':
        return Icons.restaurant_rounded;
      case 'calorie_limit':
        return Icons.warning_amber_rounded;
      case 'ai_tip':
        return Icons.auto_awesome;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getColor(String type, bool isDark) {
    switch (type) {
      case 'water':
        return Colors.blueAccent;
      case 'calorie_limit':
        return Colors.orangeAccent;
      case 'ai_tip':
        return isDark ? AppColors.primaryNeonLime : AppColors.primaryLimeDark;
      default:
        return isDark ? AppColors.primaryNeonLime : AppColors.primaryLimeDark;
    }
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
