import 'package:calogram_flutter/features/domain/entities/meal_entity.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/food_scanner/analyze_food_image_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'food_scanner_state.dart';

class FoodScannerCubit extends Cubit<FoodScannerState> {
  final AnalyzeFoodImageUsecase analyzeFoodImageUsecase;
  final LogMealUsecase logMealUsecase;
  final ImagePicker _picker = ImagePicker();

  FoodScannerCubit({
    required this.analyzeFoodImageUsecase,
    required this.logMealUsecase,
  }) : super(FoodScannerInitialState());

  XFile? _selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _selectedImage = pickedFile;
        emit(FoodScannerImagePickedState(_selectedImage!));
        await analyzeMeal();
      }
    } catch (_) {
      emit(FoodScannerErrorState('Failed to pick image'));
    }
  }

  Future<void> analyzeMeal() async {
    if (_selectedImage == null) return;

    emit(FoodScannerLoadingState());
    final result = await analyzeFoodImageUsecase(_selectedImage!);

    result.fold(
      (failure) => emit(FoodScannerErrorState(failure.errMessage)),
      (scannedFood) => emit(
        FoodScannerSuccessState(food: scannedFood, image: _selectedImage!),
      ),
    );
  }

  Future<void> saveScannedMeal({
    required String title,
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
    required String mealType,
  }) async {
    emit(FoodScannerSavingState());

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
      (failure) => emit(FoodScannerErrorState(failure.errMessage)),
      (_) => emit(FoodScannerSavedSuccessState()),
    );
  }
}
