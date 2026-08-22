import 'dart:io' show Platform;
import 'package:calogram_flutter/core/router/app_router.dart';
import 'package:calogram_flutter/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/cache_helper.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  setupServiceLocator();

  final bool isDesktopOrWeb = kIsWeb || (!Platform.isAndroid && !Platform.isIOS);
  final bool enableDevicePreview = !kReleaseMode && isDesktopOrWeb;

  runApp(
    DevicePreview(
      enabled: enableDevicePreview,
      builder: (context) => CaloGramApp(enableDevicePreview: enableDevicePreview),
    ),
  );
}

class CaloGramApp extends StatelessWidget {
  final bool enableDevicePreview;

  const CaloGramApp({super.key, required this.enableDevicePreview});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CaloGram',
      debugShowCheckedModeBanner: false,
      locale: enableDevicePreview ? DevicePreview.locale(context) : null,
      builder: enableDevicePreview ? DevicePreview.appBuilder : null,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}