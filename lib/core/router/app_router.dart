import 'package:calogram_flutter/core/router/app_routes.dart';
import 'package:calogram_flutter/features/presentation/auth/login_view.dart';
import 'package:calogram_flutter/features/presentation/auth/register_view.dart';
import 'package:calogram_flutter/features/presentation/dashboard/widgets/dashboard_view.dart';
import 'package:calogram_flutter/features/presentation/goal_setup/goal_setup_view.dart';
import 'package:calogram_flutter/features/presentation/onboarding/onboarding_view.dart';
import 'package:calogram_flutter/features/presentation/splash/splash_view.dart';
import 'package:go_router/go_router.dart';


abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboardingScreen,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: AppRoutes.goalSetupScreen,
        builder: (context, state) => const GoalSetupView(),
      ),
      GoRoute(
        path: AppRoutes.dashboardScreen,
        builder: (context, state) => const DashboardView(),
      ),
    ],
  );
}