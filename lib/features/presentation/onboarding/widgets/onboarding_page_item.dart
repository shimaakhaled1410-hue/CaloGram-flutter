import 'package:calogram_flutter/data/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageItem({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: AppColors.primaryLimeGradient,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNeonLime.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              model.icon,
              size: 70,
              color: AppColors.backgroundDark,
            ),
          ),
          const SizedBox(height: 48),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.font28BoldWhite,
              children: [
                TextSpan(text: '${model.title} '),
                TextSpan(
                  text: model.highlightWord,
                  style: AppTextStyles.font28BoldWhite.copyWith(
                    color: AppColors.primaryNeonLime,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            model.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16MediumSecondary.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}