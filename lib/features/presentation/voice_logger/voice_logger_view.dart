import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'widgets/parsed_food_card.dart';
import 'widgets/voice_confirm_button.dart';
import 'widgets/voice_mic_button.dart';
import 'widgets/voice_text_display_area.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Voice Logger',
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                VoiceTextDisplayArea(state: state),
                const SizedBox(height: 40),
                if (state is VoiceLoggerSuccess)
                  ParsedFoodCard(food: state.food),
                if (state is VoiceLoggerSuccess) const SizedBox(height: 24),
                if (state is VoiceLoggerSuccess)
                  VoiceConfirmButton(state: state),
                const Spacer(),
                if (state is! VoiceLoggerSuccess) VoiceMicButton(state: state),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
