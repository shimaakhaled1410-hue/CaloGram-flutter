import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${userName.isNotEmpty ? userName : 'Champion'}!',
                style: AppTextStyles.font24BoldWhite.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Track every bite and reach your target.',
                style: AppTextStyles.font14RegularMuted.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 22,
          backgroundColor: isDark
              ? AppColors.cardDarkElevated
              : AppColors.cardLightElevated,
          child: Icon(
            Icons.notifications_none_rounded,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
