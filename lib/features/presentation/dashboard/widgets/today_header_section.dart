import 'package:flutter/material.dart';
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
                      maxLines: 1,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: isDark
              ? AppColors.cardDarkElevated
              : AppColors.cardLightElevated,
          child: Icon(
            Icons.notifications_none_rounded,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
