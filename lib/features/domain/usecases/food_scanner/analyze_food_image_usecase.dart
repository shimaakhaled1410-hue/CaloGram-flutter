import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:calogram_flutter/features/domain/repo/food_scanner_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzeFoodImageUsecase {
  final FoodScannerRepo scannerRepo;

  const AnalyzeFoodImageUsecase(this.scannerRepo);

  Future<Either<Failure, ScannedFoodEntity>> call(XFile imageFile) {
    return scannerRepo.analyzeFoodImage(imageFile);
  }
}
