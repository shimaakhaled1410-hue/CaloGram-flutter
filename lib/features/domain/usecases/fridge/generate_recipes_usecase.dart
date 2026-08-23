import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/recipe_entity.dart';
import 'package:calogram_flutter/features/domain/repo/smart_fridge_repo.dart';
import 'package:dartz/dartz.dart';

class GenerateRecipesUseCase {
  final SmartFridgeRepo smartFridgeRepo;

  const GenerateRecipesUseCase(this.smartFridgeRepo);

  Future<Either<Failure, List<RecipeEntity>>> call(List<String> ingredients) {
    return smartFridgeRepo.generateRecipes(ingredients);
  }
}
