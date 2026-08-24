import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:calogram_flutter/core/services/notification_storage_service.dart';
import 'package:calogram_flutter/features/data/models/app_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/app_logo.dart';

class TodayHeaderSection extends StatelessWidget {
  final String userName;

  const TodayHeaderSection({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const AppLogo(size: 40, showGlow: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${userName.isNotEmpty ? userName : 'Champion'}!',
                      style: AppTextStyles.font20BoldWhite.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Track every bite and reach your target.',
                      style: AppTextStyles.font12MediumMuted.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ValueListenableBuilder(
          valueListenable: Hive.box<AppNotificationModel>(
            NotificationStorageService.boxName,
          ).listenable(),
          builder: (context, Box<AppNotificationModel> box, _) {
            final hasUnread =
                NotificationStorageService.instance.hasUnreadNotifications;

            return GestureDetector(
              onTap: () {
                context.push(AppRoutes.notificationsScreen);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDark
                        ? AppColors.cardDarkElevated
                        : AppColors.cardLightElevated,
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (hasUnread)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryNeonLime
                              : AppColors.primaryLimeDark,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
