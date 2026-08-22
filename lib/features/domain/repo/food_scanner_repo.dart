import 'dart:io';
import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/scanned_food_entity.dart';

abstract class FoodScannerRepo {
  Future<Either<Failure, ScannedFoodEntity>> analyzeFoodImage(File imageFile);
}