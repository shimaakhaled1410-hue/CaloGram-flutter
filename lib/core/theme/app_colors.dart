import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryNeonLime = Color(0xFF70E000);
  static const Color primaryLimeDark = Color(0xFF5FCB00);
  static const Color secondaryAmber = Color(0xFFFF9F1C);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentCyanLight = Color(0xFF0891B2);

  static const Color backgroundDark = Color(0xFF0B1015);
  static const Color cardDark = Color(0xFF141C24);
  static const Color cardDarkElevated = Color(0xFF1B2631);
  static const Color inputBorderDark = Color(0xFF22303C);
  static const Color textMainDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  static const Color backgroundLight = Color(0xFFFBFBFB);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardLightElevated = Color(0xFFF6FAF1);
  static const Color cardLightBorder = Color(0xFFDCE6D1);
  static const Color inputBorderLight = Color(0xFFDCE6D1);
  static const Color textMainLight = Color(0xFF10190D);
  static const Color textSecondaryLight = Color(0xFF44513E);
  static const Color textMutedLight = Color(0xFF83937A);
  static const Color glowLight = Color(0xFF5FCB00);

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient primaryLimeGradient = LinearGradient(
    colors: [Color(0xFF9EFF3D), Color(0xFF5FCB00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireCalorieGradient = LinearGradient(
    colors: [Color(0xFFFF9F1C), Color(0xFFFF4800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1A232E), Color(0xFF10171E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient scannerGlassGradient = LinearGradient(
    colors: [Color(0x3370E000), Color(0x0070E000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> cardGlowLight({double opacity = 0.08}) => [
    BoxShadow(
      color: glowLight.withValues(alpha: opacity),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];
}
