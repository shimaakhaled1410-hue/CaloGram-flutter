import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';

abstract class VoiceLoggerState {}

class VoiceLoggerInitial extends VoiceLoggerState {}

class VoiceLoggerListening extends VoiceLoggerState {
  final String recognizedText;
  VoiceLoggerListening(this.recognizedText);
}

class VoiceLoggerAnalyzing extends VoiceLoggerState {}

class VoiceLoggerSuccess extends VoiceLoggerState {
  final ScannedFoodEntity food;
  VoiceLoggerSuccess(this.food);
}

class VoiceLoggerSaving extends VoiceLoggerState {}

class VoiceLoggerSavedSuccess extends VoiceLoggerState {}

class VoiceLoggerError extends VoiceLoggerState {
  final String errMessage;
  VoiceLoggerError(this.errMessage);
}
