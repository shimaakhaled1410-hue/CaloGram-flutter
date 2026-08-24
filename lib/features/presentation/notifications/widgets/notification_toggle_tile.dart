import 'package:calogram_flutter/core/widgets/custom_toggle_switch.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class NotificationToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Color primaryAccent;
  final ValueChanged<bool> onChanged;

  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.primaryAccent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return InkWell(
      onTap: () => onChanged(!value),
      splashColor: primaryAccent.withValues(alpha: 0.08),
      highlightColor: primaryAccent.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: mutedColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            CustomToggleSwitch(
              value: value,
              primaryAccent: primaryAccent,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
