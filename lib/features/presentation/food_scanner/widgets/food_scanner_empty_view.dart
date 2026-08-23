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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 80, color: primaryAccent),
          const SizedBox(height: 16),
          Text(
            'Snap a photo of your meal',
            style: AppTextStyles.font18SemiBoldWhite.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
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
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () => context.read<FoodScannerCubit>().pickImage(
                  ImageSource.camera,
                ),
                icon: Icon(Icons.camera_rounded, color: primaryAccent),
                label: const Text('Camera'),
              ),
              const SizedBox(width: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.cardDarkElevated
                      : AppColors.cardLightElevated,
                  foregroundColor: theme.colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () => context.read<FoodScannerCubit>().pickImage(
                  ImageSource.gallery,
                ),
                icon: Icon(Icons.photo_library_rounded, color: primaryAccent),
                label: const Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
