import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_colors.dart';

class VoiceMicButton extends StatelessWidget {
  final VoiceLoggerState state;
  const VoiceMicButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onAccentColor = isDark
        ? AppColors.backgroundDark
        : AppColors.textMainLight;

    final isListening = state is VoiceLoggerListening;
    final isAnalyzing =
        state is VoiceLoggerAnalyzing || state is VoiceLoggerSaving;

    return GestureDetector(
      onTap: isAnalyzing
          ? null
          : () {
              final cubit = context.read<VoiceLoggerCubit>();
              isListening ? cubit.stopListening() : cubit.startListening();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isListening ? 85 : 72,
        width: isListening ? 85 : 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isAnalyzing ? null : AppColors.primaryLimeGradient,
          color: isAnalyzing
              ? (isDark ? Colors.grey[800] : Colors.grey[300])
              : null,
          boxShadow: [
            if (isListening)
              BoxShadow(
                color: AppColors.primaryNeonLime.withValues(
                  alpha: isDark ? 0.6 : 0.4,
                ),
                blurRadius: 28,
                spreadRadius: 8,
              )
            else if (!isAnalyzing)
              BoxShadow(
                color: AppColors.primaryNeonLime.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: isAnalyzing
            ? Padding(
                padding: const EdgeInsets.all(22.0),
                child: CircularProgressIndicator(
                  color: isDark ? Colors.white54 : Colors.black45,
                  strokeWidth: 3,
                ),
              )
            : Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: 34,
                color: onAccentColor,
              ),
      ),
    );
  }
}
