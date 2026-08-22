import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:calogram_flutter/features/domain/repo/voice_logger_repo.dart';
import 'package:dartz/dartz.dart';

class AnalyzeVoiceLogUsecase {
  final VoiceLoggerRepo voiceLoggerRepo;

  const AnalyzeVoiceLogUsecase(this.voiceLoggerRepo);

  Future<Either<Failure, ScannedFoodEntity>> call(String transcribedText) {
    return voiceLoggerRepo.analyzeVoiceLog(transcribedText);
  }
}
