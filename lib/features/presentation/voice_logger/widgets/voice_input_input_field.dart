import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class VoiceInputInputField extends StatefulWidget {
  const VoiceInputInputField({super.key});

  @override
  State<VoiceInputInputField> createState() => _VoiceInputInputFieldState();
}

class _VoiceInputInputFieldState extends State<VoiceInputInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = isDark
        ? AppColors.primaryNeonLime
        : AppColors.primaryLimeDark;
    final onAccentColor = isDark
        ? AppColors.backgroundDark
        : AppColors.textMainLight;

    return BlocListener<VoiceLoggerCubit, VoiceLoggerState>(
      listener: (context, state) {
        if (state is VoiceLoggerListening) {
          _controller.text = state.recognizedText;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        } else if (state is VoiceLoggerInitial) {
          _controller.clear();
        }
      },
      child: BlocBuilder<VoiceLoggerCubit, VoiceLoggerState>(
        builder: (context, state) {
          final isListening = state is VoiceLoggerListening;
          final isAnalyzing =
              state is VoiceLoggerAnalyzing || state is VoiceLoggerSaving;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      maxLines: 4,
                      minLines: 2,
                      enabled: !isAnalyzing,
                      style: AppTextStyles.font16SemiBoldWhite.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Speak or type what you ate (e.g. 2 boiled eggs and toast)...',
                        hintStyle: AppTextStyles.font14RegularMuted.copyWith(
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.inputBorderDark
                                : AppColors.inputBorderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.inputBorderDark
                                : AppColors.inputBorderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: primaryAccent,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            if (value.text.trim().isNotEmpty && !isAnalyzing) {
                              return IconButton(
                                icon: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: primaryAccent,
                                ),
                                onPressed: () {
                                  context.read<VoiceLoggerCubit>().analyzeText(
                                    _controller.text,
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          context.read<VoiceLoggerCubit>().analyzeText(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: isAnalyzing
                        ? null
                        : () {
                            final cubit = context.read<VoiceLoggerCubit>();
                            isListening
                                ? cubit.stopListening()
                                : cubit.startListening();
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isAnalyzing
                            ? null
                            : AppColors.primaryLimeGradient,
                        color: isAnalyzing
                            ? (isDark ? Colors.grey[800] : Colors.grey[300])
                            : null,
                        boxShadow: [
                          if (isListening)
                            BoxShadow(
                              color: primaryAccent.withValues(
                                alpha: isDark ? 0.6 : 0.4,
                              ),
                              blurRadius: 16,
                              spreadRadius: 4,
                            )
                          else if (!isAnalyzing)
                            BoxShadow(
                              color: primaryAccent.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: isAnalyzing
                          ? Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: CircularProgressIndicator(
                                color: isDark ? Colors.white54 : Colors.black45,
                                strokeWidth: 2.2,
                              ),
                            )
                          : Icon(
                              isListening
                                  ? Icons.stop_rounded
                                  : Icons.mic_rounded,
                              size: 26,
                              color: onAccentColor,
                            ),
                    ),
                  ),
                ],
              ),
              if (isListening) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Listening... Tap mic to stop',
                      style: AppTextStyles.font14RegularMuted.copyWith(
                        color: primaryAccent,
                      ),
                    ),
                  ],
                ),
              ],
              if (isAnalyzing) ...[
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: primaryAccent,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Analyzing nutritional macros with AI...',
                      style: AppTextStyles.font14MediumWhite.copyWith(
                        color: primaryAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
