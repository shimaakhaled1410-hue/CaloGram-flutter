import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class FoodScannerState {}

class FoodScannerInitialState extends FoodScannerState {}

class FoodScannerImagePickedState extends FoodScannerState {
  final XFile image;
  FoodScannerImagePickedState(this.image);
}

class FoodScannerLoadingState extends FoodScannerState {}

class FoodScannerSuccessState extends FoodScannerState {
  final ScannedFoodEntity food;
  final XFile image;
  FoodScannerSuccessState({required this.food, required this.image});
}

class FoodScannerSavingState extends FoodScannerState {}

class FoodScannerSavedSuccessState extends FoodScannerState {}

class FoodScannerErrorState extends FoodScannerState {
  final String errMessage;
  FoodScannerErrorState(this.errMessage);
}
