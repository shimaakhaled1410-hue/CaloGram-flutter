import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:calogram_flutter/features/data/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/cache_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'custom_dots_indicator.dart';
import 'onboarding_page_item.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = const [
    OnboardingModel(
      title: 'Snap, Scan & Track Your',
      highlightWord: 'Meals',
      description:
          'Take a quick photo of your food, and Multimodal AI will instantly break down calories and macros.',
      icon: Icons.camera_alt_rounded,
    ),
    OnboardingModel(
      title: 'Cook Smart From Your',
      highlightWord: 'Fridge',
      description:
          'Scan whatever ingredients you have left, and get personalized healthy recipes fitting your remaining daily calories.',
      icon: Icons.kitchen_rounded,
    ),
    OnboardingModel(
      title: 'Log Faster With Just Your',
      highlightWord: 'Voice',
      description:
          'Too busy to type? Just speak your meal naturally, and AI will log the nutritional details with ease.',
      icon: Icons.mic_rounded,
    ),
  ];

  Future<void> _completeOnboarding() async {
    await CacheHelper.setData(key: AppConstants.isOnboardingSeen, value: true);
    if (!mounted) return;
    context.go(AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentIndex == _pages.length - 1;

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Skip',
                  style: AppTextStyles.font14RegularMuted.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) => OnboardingPageItem(
                model: _pages[index],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDotsIndicator(
                  currentIndex: _currentIndex,
                  itemCount: _pages.length,
                ),
                GestureDetector(
                  onTap: () {
                    if (isLastPage) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    height: 56,
                    width: isLastPage ? 140 : 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryLimeGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.primaryNeonLime.withValues(alpha: 0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLastPage
                          ? Text(
                              'Get Started',
                              style: AppTextStyles.font16BoldDark,
                            )
                          : const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.backgroundDark,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}