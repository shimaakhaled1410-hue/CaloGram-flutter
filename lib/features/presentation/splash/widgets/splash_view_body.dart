import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/cache_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNextScreen();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      final bool isOnboardingSeen =
          CacheHelper.getBool(key: AppConstants.isOnboardingSeen) ?? false;
      final bool isGuest =
          CacheHelper.getBool(key: AppConstants.isGuestUser) ?? false;
      final String? token =
          CacheHelper.getString(key: AppConstants.cachedUserToken);

      if (!isOnboardingSeen) {
        context.go(AppRoutes.onboardingScreen);
      } else if (isGuest || (token != null && token.isNotEmpty)) {
        context.go(AppRoutes.dashboardScreen);
      } else {
        context.go(AppRoutes.loginScreen);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryLimeGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNeonLime.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 52,
                  color: AppColors.backgroundDark,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Calo', style: AppTextStyles.font28BoldWhite),
                  Text(
                    'Gram',
                    style: AppTextStyles.font28BoldWhite.copyWith(
                      color: AppColors.primaryNeonLime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'AI Smart Nutrition & Health',
                style: AppTextStyles.font14RegularMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
