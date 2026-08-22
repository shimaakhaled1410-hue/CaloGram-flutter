import 'package:calogram_flutter/features/domain/entities/meal_entity.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/voice_logger/analyze_voice_log_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'voice_logger_state.dart';

class VoiceLoggerCubit extends Cubit<VoiceLoggerState> {
  final AnalyzeVoiceLogUsecase analyzeVoiceLogUsecase;
  final LogMealUsecase logMealUsecase;
  final SpeechToText _speechToText = SpeechToText();

  String _currentWords = "";

  VoiceLoggerCubit({
    required this.analyzeVoiceLogUsecase,
    required this.logMealUsecase,
  }) : super(VoiceLoggerInitial());

  Future<void> startListening() async {
    _currentWords = "";
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' && _currentWords.isNotEmpty) {
          _processVoiceCommand();
        }
      },
      onError: (errorNotification) {
        emit(VoiceLoggerError("Speech Error: ${errorNotification.errorMsg}"));
      },
    );

    if (available) {
      emit(VoiceLoggerListening("Listening..."));
      _speechToText.listen(
        listenOptions: SpeechListenOptions(localeId: 'ar-EG'),
        onResult: (result) {
          _currentWords = result.recognizedWords;
          emit(VoiceLoggerListening(_currentWords));
        },
      );
    } else {
      emit(VoiceLoggerError("Microphone permission denied."));
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    if (_currentWords.isNotEmpty) {
      await _processVoiceCommand();
    } else {
      emit(VoiceLoggerInitial());
    }
  }

  Future<void> _processVoiceCommand() async {
    if (_currentWords.isEmpty) return;

    emit(VoiceLoggerAnalyzing());
    final result = await analyzeVoiceLogUsecase(_currentWords);

    result.fold(
      (failure) => emit(VoiceLoggerError(failure.errMessage)),
      (food) => emit(VoiceLoggerSuccess(food)),
    );
  }

  Future<void> saveVoiceMeal({
    required String title,
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
    required String mealType,
  }) async {
    emit(VoiceLoggerSaving());

    final meal = MealEntity(
      id: '',
      title: title,
      mealType: mealType,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      loggedAt: DateTime.now(),
    );

    final result = await logMealUsecase(meal);

    result.fold(
      (failure) => emit(VoiceLoggerError(failure.errMessage)),
      (_) => emit(VoiceLoggerSavedSuccess()),
    );
  }

  void reset() {
    emit(VoiceLoggerInitial());
  }
}
