import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class VoiceTextDisplayArea extends StatelessWidget {
  final VoiceLoggerState state;
  const VoiceTextDisplayArea({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;

    String displayText = 'Tap the mic and say what you ate...';
    Color textColor = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;

    if (state is VoiceLoggerListening) {
      displayText = (state as VoiceLoggerListening).recognizedText;
      if (displayText.isEmpty) displayText = "Listening...";
      textColor = theme.colorScheme.onSurface;
    } else if (state is VoiceLoggerAnalyzing || state is VoiceLoggerSaving) {
      displayText = "Analyzing with AI...";
      textColor = primaryAccent;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        displayText,
        key: ValueKey<String>(displayText),
        textAlign: TextAlign.center,
        style: AppTextStyles.font20SemiBoldWhite.copyWith(
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }
}
