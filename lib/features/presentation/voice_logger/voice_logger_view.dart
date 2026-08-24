import 'package:calogram_flutter/core/theme/app_colors.dart';
import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'widgets/parsed_food_card.dart';
import 'widgets/voice_confirm_button.dart';
import 'widgets/voice_input_input_field.dart';

class VoiceLoggerView extends StatelessWidget {
  const VoiceLoggerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VoiceLoggerCubit>(),
      child: const _VoiceLoggerContent(),
    );
  }
}

class _VoiceLoggerContent extends StatelessWidget {
  const _VoiceLoggerContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Smart Food Logger',
          style: AppTextStyles.font20BoldWhite.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<VoiceLoggerCubit, VoiceLoggerState>(
        listener: (context, state) {
          if (state is VoiceLoggerSavedSuccess) {
            CustomSnackBar.showSuccess(
              context,
              message: 'Meal logged successfully!',
            );
            context.read<VoiceLoggerCubit>().reset();
          } else if (state is VoiceLoggerError) {
            CustomSnackBar.showError(context, message: state.errMessage);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is! VoiceLoggerSuccess) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cardDarkElevated.withValues(alpha: 0.6)
                          : AppColors.cardLightElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            (isDark
                                    ? AppColors.primaryNeonLime
                                    : AppColors.primaryLimeDark)
                                .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.primaryNeonLime
                              : AppColors.primaryLimeDark,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Speak or type what you ate',
                                style: AppTextStyles.font14SemiBoldWhite
                                    .copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Say e.g., "2 boiled eggs with brown toast and coffee" and AI will extract the nutrition data automatically.',
                                style: AppTextStyles.font12MediumMuted.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state is VoiceLoggerSuccess
                      ? Column(
                          key: const ValueKey('success_card'),
                          children: [
                            ParsedFoodCard(food: state.food),
                            const SizedBox(height: 24),
                            VoiceConfirmButton(state: state),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton.icon(
                                onPressed: () =>
                                    context.read<VoiceLoggerCubit>().reset(),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                ),
                                label: const Text('Log another meal'),
                              ),
                            ),
                          ],
                        )
                      : const VoiceInputInputField(key: ValueKey('input_area')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
