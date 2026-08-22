import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/scanned_food_entity.dart';

abstract class FoodScannerRepo {
  Future<Either<Failure, ScannedFoodEntity>> analyzeFoodImage(XFile imageFile);
}