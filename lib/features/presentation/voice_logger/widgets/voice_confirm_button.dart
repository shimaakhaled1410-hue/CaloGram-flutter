import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/custom_gradient_button.dart';

class VoiceConfirmButton extends StatelessWidget {
  final VoiceLoggerSuccess state;
  const VoiceConfirmButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomGradientButton(
      text: 'Confirm & Log Meal',
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
    );
  }
}
