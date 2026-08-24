import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class FoodScannerEmptyView extends StatelessWidget {
  const FoodScannerEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: primaryAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 64,
                color: primaryAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Snap or Upload Your Meal',
              style: AppTextStyles.font18SemiBoldWhite.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a clear photo of your dish or food label. Our AI will instantly recognize items and calculate calories & macros.',
              textAlign: TextAlign.center,
              style: AppTextStyles.font12MediumMuted.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.cardDarkElevated
                        : AppColors.cardLightElevated,
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: primaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  onPressed: () => context.read<FoodScannerCubit>().pickImage(
                    ImageSource.camera,
                  ),
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    color: primaryAccent,
                    size: 20,
                  ),
                  label: const Text('Camera'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.cardDarkElevated
                        : AppColors.cardLightElevated,
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: primaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  onPressed: () => context.read<FoodScannerCubit>().pickImage(
                    ImageSource.gallery,
                  ),
                  icon: Icon(
                    Icons.photo_library_rounded,
                    color: primaryAccent,
                    size: 20,
                  ),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
