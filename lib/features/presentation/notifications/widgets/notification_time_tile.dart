import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class NotificationTimeTile extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;
  final bool enabled;

  const NotificationTimeTile({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;
    final mutedColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final disabledColor = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;

    final effectiveAccent = enabled ? primaryAccent : disabledColor;

    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.45,
        child: InkWell(
          onTap: onTap,
          splashColor: primaryAccent.withValues(alpha: 0.08),
          highlightColor: primaryAccent.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 14, color: mutedColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveAccent.withValues(
                      alpha: isDark ? 0.15 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: effectiveAccent.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: effectiveAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time.format(context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: effectiveAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
