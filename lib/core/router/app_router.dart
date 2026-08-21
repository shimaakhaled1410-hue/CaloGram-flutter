import 'package:calogram_flutter/features/presentation/onboarding/onboarding_view.dart';
import 'package:calogram_flutter/features/presentation/splash/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) =>
            const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboardingScreen,
        builder: (context, state) => const OnboardingView(),
      ),
    ],
  );
}
