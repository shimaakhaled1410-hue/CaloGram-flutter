import 'package:calogram_flutter/core/widgets/custom_snack_bar.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Voice Logger', style: AppTextStyles.font20BoldWhite),
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

                _TextDisplayArea(state: state),

                const SizedBox(height: 40),

                if (state is VoiceLoggerSuccess)
                  _ParsedFoodCard(food: state.food),
                if (state is VoiceLoggerSuccess) const SizedBox(height: 24),
                if (state is VoiceLoggerSuccess) _ConfirmButton(state: state),

                const Spacer(),

                // 3. Microphone Button
                if (state is! VoiceLoggerSuccess) _MicButton(state: state),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TextDisplayArea extends StatelessWidget {
  final VoiceLoggerState state;
  const _TextDisplayArea({required this.state});

  @override
  Widget build(BuildContext context) {
    String displayText = 'Tap the mic and say what you ate...';
    Color textColor = AppColors.textMutedDark;

    if (state is VoiceLoggerListening) {
      displayText = (state as VoiceLoggerListening).recognizedText;
      if (displayText.isEmpty) displayText = "Listening...";
      textColor = Colors.white;
    } else if (state is VoiceLoggerAnalyzing || state is VoiceLoggerSaving) {
      displayText = "Analyzing with AI...";
      textColor = AppColors.primaryNeonLime;
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

class _MicButton extends StatelessWidget {
  final VoiceLoggerState state;
  const _MicButton({required this.state});

  @override
  Widget build(BuildContext context) {
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
        height: isListening ? 90 : 75,
        width: isListening ? 90 : 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isAnalyzing ? Colors.grey[800] : AppColors.primaryNeonLime,
          boxShadow: [
            if (isListening)
              BoxShadow(
                color: AppColors.primaryNeonLime.withValues(alpha: 0.6),
                blurRadius: 30,
                spreadRadius: 10,
              ),
          ],
        ),
        child: isAnalyzing
            ? const Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: 38,
                color: isAnalyzing ? Colors.white54 : Colors.black,
              ),
      ),
    );
  }
}

class _ParsedFoodCard extends StatelessWidget {
  final dynamic food;
  const _ParsedFoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorderDark),
      ),
      child: Column(
        children: [
          Text(
            food.foodName,
            style: AppTextStyles.font24BoldWhite,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'AI Confidence: ${food.confidenceScore}',
            style: AppTextStyles.font14SemiBoldLime,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Calories', value: '${food.calories}'),
              _StatItem(label: 'Protein', value: '${food.protein}g'),
              _StatItem(label: 'Carbs', value: '${food.carbs}g'),
              _StatItem(label: 'Fats', value: '${food.fats}g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.font12MediumMuted),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.font16SemiBoldWhite),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final VoiceLoggerSuccess state;
  const _ConfirmButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNeonLime,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        context.read<VoiceLoggerCubit>().saveVoiceMeal(
          title: state.food.foodName,
          calories: state.food.calories,
          protein: state.food.protein,
          carbs: state.food.carbs,
          fats: state.food.fats,
          mealType: 'snack',
        );
      },
      child: const Text(
        'Confirm & Log Meal',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
