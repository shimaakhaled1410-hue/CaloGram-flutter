import 'package:calogram_flutter/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'core/services/cache_helper.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  setupServiceLocator();
  runApp(const CaloGramApp());
}

class CaloGramApp extends StatelessWidget {
  const CaloGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CaloGram',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}