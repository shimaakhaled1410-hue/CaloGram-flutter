import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:dartz/dartz.dart';

abstract class VoiceLoggerRepo {
  Future<Either<Failure, ScannedFoodEntity>> analyzeVoiceLog(
    String transcribedText,
  );
}
