import 'dart:io';
import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:calogram_flutter/features/domain/repo/food_scanner_repo.dart';
import 'package:dartz/dartz.dart';

class AnalyzeFoodImageUsecase {
  final FoodScannerRepo scannerRepo;

  const AnalyzeFoodImageUsecase(this.scannerRepo);

  Future<Either<Failure, ScannedFoodEntity>> call(File imageFile) {
    return scannerRepo.analyzeFoodImage(imageFile);
  }
}
